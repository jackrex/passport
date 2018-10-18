//
//  KEPOutdoorActivitySummaryMGLMapView.h
//  Keep
//
//  Created by 曹文博 on 8/29/16.
//  Copyright © 2016 JackRex. All rights reserved.
//

#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN


@interface KEPOutdoorActivitySummaryMGLMapView : MGLMapView <UIGestureRecognizerDelegate>

@property (nonatomic, copy, nullable) void (^mapViewMoveByUser)();
@property (nonatomic, copy, nullable) void (^didClickMapViewBlock)(CGPoint point);

- (void)takeSnapshotInRect:(CGRect)rect withCompletionBlock:(void (^)(UIImage *resultImage, NSInteger state))block;

- (UIImage *)takeSnapshotInRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
