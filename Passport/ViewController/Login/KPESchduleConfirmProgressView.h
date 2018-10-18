//
//  KPESchduleConfirmProgressView.h
//  Keep
//
//  Created by Wenbo Cao on 12/02/2018.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface KPESchduleConfirmProgressView : UIView

@property(nonatomic, strong, readonly) UIImageView *stateImageView;
@property(nonatomic, strong, readonly) CAShapeLayer *backgroundCircleLayer;
@property(nonatomic, strong, readonly) CAShapeLayer *animationCircleLayer;
@property(nonatomic, copy, nullable) void (^animationDidEnd)();

- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
