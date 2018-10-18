//
//  KEPOutdoorActivitySummaryMGLMapView.m
//  Keep
//
//  Created by 曹文博 on 8/29/16.
//  Copyright © 2016 JackRex. All rights reserved.
//

#import "KEPOutdoorActivitySummaryMGLMapView.h"

@interface KEPOutdoorActivitySummaryMGLMapView ()
@property (nonatomic, strong) UITapGestureRecognizer *mapTapGestureRecognizer;
@end

@implementation KEPOutdoorActivitySummaryMGLMapView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame styleURL:[NSURL URLWithString:@"mapbox://styles/keepintl/cjl4lpr8uasrw2sqnayhda480"]];
    if (self) {
        [self addTap];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTap];
    }
    
    return self;
}

- (void)addTap {
    self.mapTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    self.mapTapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.mapTapGestureRecognizer];
}

/*!
 @brief 在指定区域内截图(默认会包含该区域内的annotationView),
 @param rect 指定的区域
 @param block 回调block(resultImage 是返回的图片,state是返回的状态：返回1为全面）
 */
- (void)takeSnapshotInRect:(CGRect)rect withCompletionBlock:(void (^)(UIImage *resultImage, NSInteger state))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block([self takeSnapshotInRect:rect], 1);
        }
    });
}

- (UIImage *)takeSnapshotInRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [self drawViewHierarchyInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.bounds.size.width, self.bounds.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didTap:(UITapGestureRecognizer *)gesture {
    if (self.didClickMapViewBlock) {
        CGPoint point = [gesture locationInView:self];
        self.didClickMapViewBlock(point);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.mapTapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }
    
    [super touchesCancelled:touches withEvent:event];
    if (self.mapViewMoveByUser) {
        self.mapViewMoveByUser();
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isEqual:self.mapTapGestureRecognizer] && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }
    
    return NO;
}

@end
