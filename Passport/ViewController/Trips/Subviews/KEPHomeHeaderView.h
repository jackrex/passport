//
//  KEPHomeHeaderView.h
//  Keep
//
//  Created by Wenbo Cao on 13/04/2018.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@class TripsModel;

@interface KEPHomeHeaderView : UIView

@property(nonatomic, copy, nullable) void (^didClickInsightView)();
@property(nonatomic, copy, nullable) void (^didClickDataCenterView)();
@property(nonatomic, copy, nullable) void (^didClickAutoTrainingLogView)();

+ (CGFloat)viewHeight;

+ (CGFloat)foldViewHeight;

- (void)updateUIWithModel:(TripsModel *)trips;

- (void)updateFrameWithProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
