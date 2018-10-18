//
//  KEPEntryMultiPhotosView.h
//  Keep
//
//  Created by jianjun on 2018-04-01.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import UIKit;

@class TripDetailModel;
@class MMImagesPreviewView;
@class FlexiblePageControl;

@interface KEPEntryMultiPhotosView : UIView

@property (nonatomic, strong, readonly) FlexiblePageControl *pageControl;
@property (nonatomic, strong, readonly) MMImagesPreviewView *bannerView;

- (void)updateData:(TripDetailModel *)model;
+ (BOOL)shouldDisplayForData:(TripDetailModel *)model;

+ (CGFloat)bottomPadding;

@end
