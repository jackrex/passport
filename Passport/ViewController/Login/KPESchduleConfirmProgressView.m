//
//  KPESchduleConfirmProgressView.m
//  Keep
//
//  Created by Wenbo Cao on 12/02/2018.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <KEPIntlCommon/CAAnimation+KEP_OutdoorActivity.h>
#import "KPESchduleConfirmProgressView.h"

static CGSize const ProgressViewSize = {128, 128};

@interface KPESchduleConfirmProgressView ()

@property(nonatomic, strong) UIImageView *stateImageView;
@property(nonatomic, strong) CAShapeLayer *backgroundCircleLayer;
@property(nonatomic, strong) CAShapeLayer *animationCircleLayer;

@end

@implementation KPESchduleConfirmProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, ProgressViewSize.width, ProgressViewSize.height)];
    if (!self) {
        return nil;
    }
    [self _kep_setupSubviews];
    return self;
}

- (CGSize)intrinsicContentSize {
    return ProgressViewSize;
}

- (void)startAnimation {
    self.animationCircleLayer.strokeEnd = 1;
    CABasicAnimation *animaiton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animaiton.fromValue = @(0);
    __weak __typeof(self)weakSelf = self;
    [animaiton kep_didCompletedBlock:^(BOOL success) {
        weakSelf.stateImageView.image = [UIImage imageNamed:@"icon_building_plan_done"];
        NSParameterAssert(weakSelf.animationDidEnd);
        weakSelf.animationDidEnd();
    }];
    animaiton.duration = 5;
    animaiton.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.17 :.67 :.75 :.43];
    [self.animationCircleLayer addAnimation:animaiton forKey:nil];
}

#pragma mark - Properties

- (UIImageView *)stateImageView {
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
        _stateImageView.image = [UIImage imageNamed:@"icon_building_plan"];
    }
    return _stateImageView;
}

- (CAShapeLayer *)backgroundCircleLayer {
    if (!_backgroundCircleLayer) {
        _backgroundCircleLayer = [CAShapeLayer layer];
        _backgroundCircleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(ProgressViewSize.width / 2, ProgressViewSize.height / 2)
                                                                     radius:ProgressViewSize.width / 2
                                                                 startAngle:-M_PI / 2
                                                                   endAngle:-M_PI / 2 + M_PI * 2
                                                                  clockwise:YES].CGPath;
        _backgroundCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _backgroundCircleLayer.strokeColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
        _backgroundCircleLayer.lineWidth = 3;
    }
    return _backgroundCircleLayer;
}

- (CAShapeLayer *)animationCircleLayer {
    if (!_animationCircleLayer) {
        _animationCircleLayer = [CAShapeLayer layer];
        _animationCircleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(ProgressViewSize.width / 2, ProgressViewSize.height / 2)
                                                                    radius:ProgressViewSize.width / 2
                                                                startAngle:-M_PI / 2
                                                                  endAngle:-M_PI / 2 + M_PI * 2
                                                                 clockwise:YES].CGPath;
        _animationCircleLayer.strokeColor = [UIColor kep_colorFromHex:0x24c789].CGColor;
        _animationCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _animationCircleLayer.lineWidth = 3;
        _animationCircleLayer.strokeEnd = 0;
    }
    return _animationCircleLayer;
}
#pragma mark - Private Methods

- (void)_kep_setupSubviews {
    [self.layer addSublayer:self.backgroundCircleLayer];
    [self.layer addSublayer:self.animationCircleLayer];
    [self addSubview:self.stateImageView];
  
    self.backgroundCircleLayer.frame = self.bounds;
    self.animationCircleLayer.frame = self.bounds;
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

@end
