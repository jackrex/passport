//
//  KEPEntryPhotoAndVideoView.m
//  Keep
//
//  Created by caowenbo on 2018-07-18.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import <KEPIntlCommonUI/KCircleView.h>
#import <KEPIntlCommonUI/KEPPreviewDircter.h>

#import "KEPEntryPhotoAndVideoView.h"

#import "KEPBaseEntryCell+Helper.h"

@interface KEPEntryPhotoAndVideoView ()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) KCircleView *progressView;

@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) TripDetailModel *TripDetailModel;

@end

@implementation KEPEntryPhotoAndVideoView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.photoImageView = [[UIImageView alloc] init];
        self.photoImageView.clipsToBounds = YES;
        self.photoImageView.userInteractionEnabled = YES;
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.photoImageView];
        
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}



#pragma mark - Getter


- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[UIButton alloc] init];
        _refreshBtn.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
//        [_refreshBtn setBackgroundImage:[UIImage sl_imageNamed:@"icon_timeline_refresh"] forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(reloadImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

- (KCircleView *)progressView {
    if (!_progressView) {
        _progressView = [[KCircleView alloc] init];
        _progressView.strokeColor = [UIColor kep_colorFromHex:0xffffff];
        _progressView.duration = 0;
        _progressView.closedIndicatorBackgroundStrokeColor = [UIColor kep_colorFromHex:0xD0CDD2];
        _progressView.coverWidth = 5.0;
        [_progressView loadIndicator];
    }
    return _progressView;
}


#pragma mark - Setter
- (void)configureProgressView {
    [self addProgressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.photoImageView);
        make.width.height.mas_equalTo(70);
    }];
}

- (void)configureRefreshView {
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.photoImageView);
        make.width.mas_equalTo(78);
        make.height.mas_equalTo(66);
    }];
}

- (void)updateData:(TripDetailModel *)model {
    self.TripDetailModel = model;
    [self handleImage:model];
}

+ (BOOL)shouldDisplayForData:(TripDetailModel *)model {
    return model.pictures.count == 1;
}



- (void)handleImage:(TripDetailModel *)model {
    NSString *photo = model.pictures.firstObject;
    
    [self removeRefreshButton];
    [self configureGesture];
    
    [self configureProgressView];
    
    [self handleNormalImage:photo];
}

//正常entry的图片处理
- (void)handleNormalImage:(NSString *)photo {
    if (!photo.length) {
        self.photoImageView.hidden = YES;
        return;
    }
    
    self.photoImageView.hidden = NO;
    [self ImageProgress:0];
    
    KEPWeak(self);
    [self.photoImageView sd_setImageWithURL:[NSURL encodeURLWithString:[photo timeLinePhotoThum]] placeholderImage:[UIImage createImageWithColor:[UIColor kep_colorFromHex:0xEEEDEF]] options:SDWebImageRetryFailed | SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        KEPStrong(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ImageProgress:receivedSize / (float)expectedSize];
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        KEPStrong(self);
        [self removeProgressView];
        if (error) {
            [self showRefreshButton];
        }
    }];
}



- (void)ImageProgress:(float)progress {
    if (self.progressView) {
        [self.progressView updateWithTotalBytes:1 downloadedBytes:progress animated:NO];
    }
}

- (void)reloadImage:(UIButton *)btn {
    [self removeRefreshButton];
    [self updateProgressView];
}

- (void)addProgressView {
    [self.photoImageView addSubview:self.progressView];
}

- (void)updateProgressView {
    [self addProgressView];
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.photoImageView);
    }];
}

- (void)handleProgressView:(BOOL)hiden {
    self.progressView.hidden = hiden;
}

#pragma mark - Actions


- (void)configureGesture {
    UITapGestureRecognizer *preViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preViewImage:)];
    [self.photoImageView addGestureRecognizer:preViewGesture];
}

- (void)preViewImage:(UIGestureRecognizer *)tap {
    [KEPPreviewDircter previewTimelineImages:self.TripDetailModel.pictures
                                currentIndex:0
                                  authorName:nil];
}


- (void)removeProgressView {
    if (_progressView) {
        [_progressView removeFromSuperview];
    }
}

- (void)showRefreshButton {
    if (!self.refreshBtn.superview) {
        [self.photoImageView addSubview:self.refreshBtn];
        [self configureRefreshView];
    }
}

- (void)removeRefreshButton {
    if (_refreshBtn) {
        [_refreshBtn removeFromSuperview];
    }
}

@end
