//
//  KEPEntryMultiPhotosView.m
//  Keep
//
//  Created by jianjun on 2018-04-01.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <KEPIntlCommonUI/KEPIntlCommonUI.h>
#import <Masonry/Masonry.h>
#import <KEPIntlCommon/KEPCommon.h>

#import "TripDetailModel.h"
#import "KEPEntryMultiPhotosView.h"
#import "Passport-Swift.h"


@interface KEPEntryMultiPhotosView () <MMImagesPreviewViewDelegate>

@property (nonatomic, strong) FlexiblePageControl *pageControl;
@property (nonatomic, strong) MMImagesPreviewView *bannerView;

@property (nonatomic, strong) TripDetailModel *TripDetailModel;
@property (nonatomic, strong) UITapGestureRecognizer *preViewGesture;

@end

@implementation KEPEntryMultiPhotosView

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self configureSubviews];
    [self configureGesture];
    return self;
}


- (void)configureSubviews {
    self.bannerView = [[MMImagesPreviewView alloc] init];
    self.bannerView.zoomEnabled = NO;
    self.bannerView.imageContentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.bannerView];
    self.bannerView.delegate = self;
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
    }];
    self.pageControl = [[FlexiblePageControl alloc] init];
    self.pageControl.dotSize = 7;
    self.pageControl.dotSpace = 8;
    self.pageControl.pageIndicatorTintColor = [KColorManager storeDisabledColor];
    self.pageControl.currentPageIndicatorTintColor = [KColorManager buttonGreenTitleColor];
    [self addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-7.5);
        make.height.mas_equalTo(14);
        make.centerX.equalTo(self);
    }];
}

- (void)updateData:(TripDetailModel *)model {
    self.TripDetailModel = model;
    if ([model.pictures isEqualToArray:self.bannerView.images]) {
        return;
    }
    
    [self.bannerView updateWithImages:model.pictures scrollToIndex:0];
    
    self.pageControl.numberOfPages = model.pictures.count;
    self.pageControl.currentPage = 0;
    
    self.pageControl.smallDotSizeRatio = 0.6;
    self.pageControl.mediumDotSizeRatio = 0.8;
    
    self.pageControl.displayCount = MIN(5, model.pictures.count);
    
    [self.pageControl setNeedsLayout];
    [self.pageControl layoutIfNeeded];
}

+ (BOOL)shouldDisplayForData:(TripDetailModel *)model {
    return model.pictures.count > 1;
}



+ (CGFloat)bottomPadding {
    return 26.5;
}




- (void)configureGesture {
    self.preViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preViewImage:)];
    [self.bannerView addGestureRecognizer:self.preViewGesture];
}

- (void)previewView:(MMImagesPreviewView *)previewView didScroll:(UIScrollView *)scrollView {
    [self.pageControl setProgressWithContentOffsetX:scrollView.contentOffset.x pageWidth:scrollView.bounds.size.width];
}

- (void)previewView:(MMImagesPreviewView *)previewView didEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)preViewImage:(UIGestureRecognizer *)tap {
    [KEPPreviewDircter previewTimelineImages:self.TripDetailModel.pictures
                                currentIndex:self.pageControl.currentPage
                                  authorName:@""];
}

@end
