//
//  UIView+KEP_OutdoorActivity.h
//  Keep
//
//  Created by Zachary on 8/21/16.
//  Copyright © 2016 JackRex. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN


@interface UIView (KEP_OutdoorActivity)

- (void)kep_loadSummaryCardStyle;
- (void)kep_loadSummaryCardShadow;
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

- (void)kep_loadSiblingShadowEffectWithBounds:(CGRect)bounds
                                    opacities:(NSArray<NSNumber *> *)opacities
                                 shadowColors:(NSArray<UIColor *> *)shadowColors
                                 shadowRadius:(NSArray<NSNumber *> *)shadowRadius
                                shadowOffsets:(NSArray<NSValue *> *)shadowOffsets;

- (void)kep_appearAlphaWithAnimationCompletion:(void (^__nullable)(void))completion;
- (void)kep_disappearAlphaWithAnimationCompletion:(void (^__nullable)(void))completion;

- (void)kep_appearAlphaWithAnimation;
- (void)kep_disappearAlphaWithAnimation;


@end

NS_ASSUME_NONNULL_END
