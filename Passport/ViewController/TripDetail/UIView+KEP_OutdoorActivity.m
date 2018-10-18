//
//  UIView+KEP_OutdoorActivity.m
//  Keep
//
//  Created by Zachary on 8/21/16.
//  Copyright © 2016 JackRex. All rights reserved.
//

#import "UIView+KEP_OutdoorActivity.h"
#import <KEPIntlCommon/KEPCommon.h>


@implementation UIView (KEP_OutdoorActivity)

- (void)kep_loadSummaryCardStyle {
    self.layer.cornerRadius = 5;
    [self kep_loadSummaryCardShadow];
}

- (void)kep_loadSummaryCardShadow {
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowRadius = 8;
    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
    self.layer.shadowOpacity = .2;
}

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

- (void)kep_loadSiblingShadowEffectWithBounds:(CGRect)bounds
                                    opacities:(NSArray<NSNumber *> *)opacities
                                 shadowColors:(NSArray<UIColor *> *)shadowColors
                                 shadowRadius:(NSArray<NSNumber *> *)shadowRadius
                                shadowOffsets:(NSArray<NSValue *> *)shadowOffsets {
    //array must be nonull
    NSParameterAssert(opacities);
    NSParameterAssert(shadowColors);
    NSParameterAssert(shadowRadius);
    NSParameterAssert(shadowOffsets);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.layer.cornerRadius];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.shadowOpacity = opacities.firstObject.floatValue;
    maskLayer.fillColor = self.backgroundColor.CGColor;
    maskLayer.shadowColor = shadowColors.firstObject.CGColor;
    maskLayer.shadowOffset = shadowOffsets.firstObject.CGSizeValue;
    maskLayer.shadowRadius = shadowRadius.firstObject.floatValue;
    [self.layer insertSublayer:maskLayer atIndex:0];

    CAShapeLayer *shadowLayer = [[CAShapeLayer alloc] init];
    shadowLayer.frame = bounds;
    shadowLayer.fillColor = self.backgroundColor.CGColor;
    shadowLayer.shadowOpacity = opacities.lastObject.floatValue;
    shadowLayer.shadowColor = shadowColors.lastObject.CGColor;
    shadowLayer.shadowOffset = shadowOffsets.lastObject.CGSizeValue;
    shadowLayer.shadowRadius = shadowRadius.lastObject.floatValue;
    shadowLayer.path = maskPath.CGPath;
    [self.layer insertSublayer:shadowLayer atIndex:0];
}

- (void)kep_appearAlphaWithAnimation {
    [self kep_appearAlphaWithAnimationCompletion:NULL];
}

- (void)kep_appearAlphaWithAnimationCompletion:(void (^__nullable)(void))completion {
    self.alpha = 0;
    self.hidden = NO;
    [UIView animateWithDuration:.25
        animations:^{
            self.alpha = 1;
        }
        completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
}

- (void)kep_disappearAlphaWithAnimation {
    [self kep_disappearAlphaWithAnimationCompletion:NULL];
}

- (void)kep_disappearAlphaWithAnimationCompletion:(void (^__nullable)(void))completion {
    self.alpha = 1;
    [UIView animateWithDuration:.25
        animations:^{
            self.alpha = 0;
        }
        completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
}

@end
