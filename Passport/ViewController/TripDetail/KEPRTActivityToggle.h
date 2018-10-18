//
//  KEPRTActivityToggle.h
//  Keep
//
//  Created by Zachary on 2018/6/28.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import UIKit;


FOUNDATION_EXPORT CGSize const KEPOutdoorActivitySummaryToggleSize;

NS_ASSUME_NONNULL_BEGIN

@interface KEPRTActivityToggle : UIControl

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, assign) BOOL scaleDisappearEnabled;

@property (nonatomic, copy, nullable) void(^didClickToggleBlock)(void);
@property (nonatomic, assign, readonly) BOOL touchEnabled;

@property (nonatomic, copy, nullable) void (^cancelPressureBlock)(void);

@property (nonatomic, strong, nullable) UIColor *selectedColor;
@property (nonatomic, strong, nullable) UIImage *selectedIconImage;

/*
 * support voiceOver
 * if you set progressEnabled to YES, this toggle will use tap instead of long press
 */
- (instancetype)initWithSize:(CGSize)size
        backgroundImageColor:(UIColor *)backgroundImageColor
                   iconImage:(nullable UIImage *)iconImage
                        text:(nullable NSString *)text
             progressEnabled:(BOOL)progressEnabled;

- (instancetype)initWithSize:(CGSize)size
        backgroundImageColor:(UIColor *)backgroundImageColor
                   iconImage:(nullable UIImage *)iconImage
                        text:(nullable NSString *)text;

- (void)updateBackgroundImage:(UIImage *)image;
- (void)updateIconImage:(UIImage *)image text:(NSString *)text;
- (void)updateBackgroundColor:(UIColor *)color;
- (void)updateBorderColor:(UIColor *)color;
- (void)updateIconTextHorizontalTypeWithIconImage:(UIImage *)image text:(NSString *)text;

- (void)showToggle;
- (void)disappearWithCompletion:(void(^_Nullable)(void))completion;

- (void)setupOnlyImageWithSize:(CGSize)size borderEnabled:(BOOL)borderEnabled;
- (void)setupOnlyTextWithBorderEnabled:(BOOL)borderEnabled;

- (void)updateConstraintWidth:(CGFloat)width;

@end


NS_ASSUME_NONNULL_END
