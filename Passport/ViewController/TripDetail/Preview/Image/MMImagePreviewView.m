//
//  MMImagePreviewView.m
//  Keep
//
//  Created by CharlesChen on 2017/5/21.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "MMImagePreviewView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <KEPIntlCommon/KEPCommon.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <KEPSVProgressHUD/SVProgressHUD.h>
#import <KEPIntlLocalization/KEPLocalization.h>
#import "KCircleView.h"
#import "MMAssetService.h"

@interface MMImagePreviewView () <UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) NSString *userNameForSave;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) KCircleView *progressView;

@property (nonatomic, strong) UITapGestureRecognizer *singleFingerGesture;
@property (nonatomic, strong) UITapGestureRecognizer *doubleFingerGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end


@implementation MMImagePreviewView

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
        [self configGestures];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.scrollView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.edges.equalTo(self.scrollView);
    }];

    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(70);
    }];
}

- (void)configGestures {
    self.singleFingerGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.singleFingerGesture.numberOfTouchesRequired = 1;
    self.singleFingerGesture.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:self.singleFingerGesture];

    self.doubleFingerGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.doubleFingerGesture.numberOfTouchesRequired = 2;
    self.doubleFingerGesture.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:self.doubleFingerGesture];

    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.scrollView addGestureRecognizer:self.longPressGesture];
}

- (void)updateWithImage:(id)image zoomEnabled:(BOOL)zoomEnabled userNameForSave:(NSString *)userNameForSave imageContentMode:(UIViewContentMode)imageContentMode {
    self.scrollView.zoomScale = 1.f;
    self.progressView.hidden = YES;

    self.imageView.contentMode = imageContentMode;
    self.imageView.image = nil;
    [self.imageView sd_cancelCurrentImageLoad];
    if ([image isKindOfClass:UIImage.class]) {
        self.imageView.image = image;
    } else if ([image isKindOfClass:NSString.class] || [image isKindOfClass:NSURL.class]) {
        NSURL *url = [image isKindOfClass:NSURL.class] ? image : [NSURL URLWithString:image];
        __weak __typeof(self) weakSelf = self;
        [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage createImageWithColor:[UIColor kep_colorFromHex:0xEEEDEF]] options:SDWebImageRetryFailed | SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = NO;
                [weakSelf.progressView updateWithTotalBytes:expectedSize downloadedBytes:receivedSize animated:NO];
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.progressView.hidden = YES;
        }];
    } else if ([image isKindOfClass:[PHAsset class]]) {
        self.progressView.hidden = YES;
        __weak __typeof(self) weakSelf = self;
        [[MMAssetService service] requestImageWithAsset:image
                                                handler:^(MMAssetErrorCode errorCode, UIImage *image, MMAssetExtraInfoModel *extraInfoModel) {
                                                    weakSelf.progressView.hidden = YES;
                                                    [weakSelf.imageView setImage:image];
                                                } progress:^(double progress, NSError * _Nullable error, BOOL *stop, NSDictionary * _Nullable info) {
                                                    weakSelf.progressView.hidden = NO;
                                                    [weakSelf.progressView updateWithTotalBytes:1 downloadedBytes:progress animated:NO];
                                                }];
     
    }
    if (zoomEnabled) {
        self.singleFingerGesture.enabled = YES;
        self.doubleFingerGesture.enabled = YES;
        self.scrollView.maximumZoomScale = 4.f;
    } else {
        self.singleFingerGesture.enabled = NO;
        self.doubleFingerGesture.enabled = NO;
        self.scrollView.maximumZoomScale = 1.f;
    }

    self.userNameForSave = userNameForSave;
    if (self.userNameForSave.length > 0) {
        self.longPressGesture.enabled = YES;
    } else {
        self.longPressGesture.enabled = NO;
    }
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    CGPoint location = [tapGesture locationInView:self.imageView];
    if (tapGesture.numberOfTouchesRequired == 1) {
        CGFloat zoomScale = MIN(self.scrollView.zoomScale * 1.5f, self.scrollView.maximumZoomScale);
        CGSize boundsSize = self.scrollView.bounds.size;

        CGFloat width = boundsSize.width / zoomScale;
        CGFloat height = boundsSize.height / zoomScale;
        CGFloat left = location.x - width / 2;
        CGFloat top = location.y - height / 2;
        [self.scrollView zoomToRect:CGRectMake(left, top, width, height) animated:YES];
    } else {
        CGFloat zoomScale = MAX(self.scrollView.zoomScale / 1.5f, self.scrollView.minimumZoomScale);
        [self.scrollView setZoomScale:zoomScale animated:YES];
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:KEPLocalizedString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:KEPLocalizedString(@"save_picture"), nil];
        [actionSheet showInView:self];
    }
}

#pragma mark - #pragma mark - UIScrollViewDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        __weak __typeof(self) weakSelf = self;
        [library saveImage:self.imageView.image toAlbum:@"Keep" userName:self.userNameForSave withCompletionBlock:^(NSError *error) {
            if (error == nil) {
                [SVProgressHUD showInfoWithStatus:KEPLocalizedString(@"save_picture_success") inView:weakSelf.window];
            }
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.f;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (KCircleView *)progressView {
    if (!_progressView) {
        _progressView = [[KCircleView alloc] init];
        _progressView.strokeColor = [UIColor kep_colorFromHex:0xFFFFFF];
        _progressView.duration = 0;
        _progressView.closedIndicatorBackgroundStrokeColor = [UIColor kep_colorFromHex:0xD0CDD2];
        _progressView.coverWidth = 5.0;
        [_progressView loadIndicator];
        _progressView.hidden = YES;
    }
    return _progressView;
}

@end
