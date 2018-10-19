//
//  MMImagesPreviewVC.m
//  Keep
//
//  Created by CharlesChen on 2017/5/20.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "MMImagesPreviewVC.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <KEPIntlLocalization/KEPLocalization.h>
#import "MMImagesPreviewView.h"
#import "UIImage+KEPIntlCommonUI.h"

@interface MMImagesPreviewVC () <UIActionSheetDelegate, MMImagesPreviewViewDelegate>

@property (nonatomic, assign) NSUInteger index;

@end


@implementation MMImagesPreviewVC

@synthesize images = _images;
@synthesize previewView = _previewView;
@synthesize cancelButton = _cancelButton;
@synthesize deleteButton = _deleteButton;
@synthesize titleLabel = _titleLabel;

- (instancetype)initWithImages:(NSArray *)images scrollToIndex:(NSUInteger)index {
    if (self = [super init]) {
        _images = [images mutableCopy];
        _index = (index < images.count) ? index : 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self configEvents];
    [self reloadData];
}

- (void)initUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];

    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(22 + iPhoneXTopOffsetY);
        make.height.mas_equalTo(44);
    }];

    [topView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48.f, 30.f));
        make.left.equalTo(topView);
        make.centerY.equalTo(topView);
    }];

    [topView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48.f, 30.f));
        make.right.equalTo(topView);
        make.centerY.equalTo(topView);
    }];

    [topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelButton.mas_right);
        make.right.equalTo(self.deleteButton.mas_left);
        make.centerY.equalTo(topView);
    }];

    [self.view insertSubview:self.previewView atIndex:0];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)configEvents {
    @weakify(self);
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self) if (!self) {
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];

    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self) if (!self) {
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:KEPLocalizedString(@"cancel") destructiveButtonTitle:KEPLocalizedString(@"intl_delete") otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }];
}

- (void)reloadData {
    self.previewView.userNameForSave = self.userNameForSave;
    [self.previewView updateWithImages:self.images scrollToIndex:self.index];
    [self updateIndex:self.index];
}

- (void)updateIndex:(NSUInteger)index {
    self.index = (index < self.images.count) ? index : self.images.count - 1;
    self.titleLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.index + 1), @(self.images.count)];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.images.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (self.images.count == 1) {
            if ([self.delegate respondsToSelector:@selector(previewVC:didDeleteImageAtIndex:)]) {
                [self.delegate previewVC:self didDeleteImageAtIndex:0];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (self.index >= self.images.count) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(previewVC:didDeleteImageAtIndex:)]) {
            [self.delegate previewVC:self didDeleteImageAtIndex:self.index];
        }
        [self.images removeObjectAtIndex:self.index];
        self.index = MIN(self.index, self.images.count - 1);
        [self reloadData];
    }
}

#pragma mark - MMImagesPreviewViewDelegate

- (void)previewView:(MMImagesPreviewView *)previewView didScroll:(UIScrollView *)scrollView {
    NSUInteger pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.size.width);
    [self updateIndex:pageIndex];
}


#pragma mark - Getter

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage commonUI_imageNamed:@"icon_back"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage commonUI_imageNamed:@"icon_trash"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor kep_colorFromHex:0xDDDDDD];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (MMImagesPreviewView *)previewView {
    if (!_previewView) {
        _previewView = [[MMImagesPreviewView alloc] init];
        _previewView.delegate = self;
    }
    return _previewView;
}

#pragma mark - Support

- (BOOL)hideNavigationBar {
    return YES;
}

@end
