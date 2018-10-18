//
//  KEPEntryHeaderView.h
//  Keep
//
//  Created by caowenbo on 2018-07-18.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import UIKit;

@class TripDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface KEPEntryHeaderView : UIView


+ (CGFloat)viewHeight;

- (void)updateData:(TripDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
