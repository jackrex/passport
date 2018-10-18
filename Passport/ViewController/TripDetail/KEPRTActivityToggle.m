//
//  KEPRTActivityToggle.m
//  Keep
//
//  Created by Zachary on 2018/6/28.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <KEPIntlCommon/KEPCommon.h>
#import <Masonry/Masonry.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <BlocksKit/NSTimer+BlocksKit.h>

#import "KEPRTActivityToggle.h"

CGSize const KEPOutdoorActivitySummaryToggleSize = {36, 36};

typedef NS_ENUM(NSUInteger, KEPRTActivityToggleAnimationState) {
    KEPRTActivityToggleAnimationStateNone,
    KEPRTActivityToggleAnimationStateDrawCircle,
    KEPRTActivityToggleAnimationStateCancel,
    KEPRTActivityToggleAnimationStateEnd
};

static CGSize const RTActivityToggleSize = {96, 96};
static CGSize const IconSize = {24, 24};
static CGFloat const TextOffset = 4;

static NSTimeInterval const ToggleAnimationDuration = 0.2;
static CGFloat const TransMinScale = 0.0000001;
static CGFloat const TransMaxScale = 1.2;


static const NSTimeInterval KEPZoomAnimationDuration = 0.15;
static const NSTimeInterval KEPDrawCircleAnimationDuration = 0.85;

static const CGFloat KEPLowestAnimationProgress = 0.25;

@interface _KEPRTAnimationView : UIView

@property (nonatomic, strong) CAShapeLayer *animationLayer;

@end

@implementation _KEPRTAnimationView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                          cornerRadius:RTActivityToggleSize.width / 2];
    _animationLayer = [[CAShapeLayer alloc] init];
    _animationLayer.frame = self.bounds;
    _animationLayer.fillColor = [UIColor clearColor].CGColor;
    _animationLayer.strokeColor = [UIColor whiteColor].CGColor;
    _animationLayer.lineWidth = 2;
    _animationLayer.path = circlePath.CGPath;
    _animationLayer.strokeStart = 0;
    _animationLayer.strokeEnd = 0;
    [self.layer addSublayer:_animationLayer];
    return self;
}

@end

@interface KEPRTActivityToggle ()

@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIColor *backgroundImageColor;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL touchEnabled;
@property (nonatomic, assign) BOOL touchUpInsided;
@property (nonatomic, assign) BOOL touchDownAnimationCompleted;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;

#pragma mark - progress
@property (nonatomic, assign) BOOL progressEnabled;
@property (nonatomic, strong) _KEPRTAnimationView *animationView;
@property (nonatomic, assign) KEPRTActivityToggleAnimationState animationState;
@property (nonatomic, assign) CGFloat lastProgress;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger startTimerCount;
@property (nonatomic, assign) BOOL shouldStopDrawCircle;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation KEPRTActivityToggle

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithSize:(CGSize)size
        backgroundImageColor:(UIColor *)backgroundImageColor
                   iconImage:(nullable UIImage *)iconImage
                        text:(nullable NSString *)text
             progressEnabled:(BOOL)progressEnabled {
    NSAssert(size.width == size.height, @"size.width is not equal to size.height, this is a circle");
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (!self) {
        return nil;
    }
    _touchEnabled = YES;
    _size = size;
    _backgroundImageColor = backgroundImageColor;
    _iconImage = iconImage;
    _text = [text copy];
    _progressEnabled = progressEnabled;
    [self _kep_setupSubviews];
    return self;
}

- (instancetype)initWithSize:(CGSize)size
        backgroundImageColor:(UIColor *)backgroundImageColor
                   iconImage:(nullable UIImage *)iconImage
                        text:(nullable NSString *)text {
    return [self initWithSize:size
         backgroundImageColor:backgroundImageColor
                    iconImage:iconImage
                         text:text
              progressEnabled:NO];
}

#pragma mark - Public

- (void)updateBackgroundImage:(UIImage *)image {
    self.bgImageView.image = image;
    self.bgImageView.backgroundColor = image ? [UIColor clearColor] : _backgroundImageColor;
}

- (void)updateBackgroundColor:(UIColor *)color {
    self.bgImageView.backgroundColor = color;
}

- (void)updateBorderColor:(UIColor *)color {
    self.bgImageView.layer.borderColor = color.CGColor;
}

- (void)updateIconTextHorizontalTypeWithIconImage:(UIImage *)image text:(NSString *)text {
    self.iconImageView.image = image;
    self.textLabel.text = text;
    self.textLabel.textColor = [KColorManager subTextColor];
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(-4);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(19);
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(4);
        make.centerY.equalTo(self);
    }];
}

- (void)showToggle {
    self.touchEnabled = NO;
    self.transform = CGAffineTransformMakeScale(TransMinScale, TransMinScale);
    self.bgImageView.transform = CGAffineTransformMakeScale(TransMinScale, TransMinScale);
    self.textLabel.alpha = 0;
    self.iconImageView.alpha = 0;
    self.alpha = 1;
    self.hidden = NO;
    _animationView.alpha = 0;
    [UIView animateWithDuration:ToggleAnimationDuration
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.bgImageView.transform = CGAffineTransformMakeScale(TransMaxScale, TransMaxScale);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:ToggleAnimationDuration
                                          animations:^{
                                              self.bgImageView.transform = CGAffineTransformIdentity;
                                          }
                                          completion:^(BOOL finished) {
                                              self.touchEnabled = YES;
                                          }];
                     }];
    [UIView animateWithDuration:ToggleAnimationDuration
                          delay:.3
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.textLabel.alpha = 1;
        self.iconImageView.alpha = 1;
    }
                     completion:NULL];
}

- (void)disappearWithCompletion:(void(^_Nullable)(void))completion {
    _animationView.alpha = 0;
    [UIView animateWithDuration:ToggleAnimationDuration
                     animations:^{
                         self.textLabel.alpha = 0;
                         self.iconImageView.alpha = 0;
                     }
                     completion:NULL];
    [UIView animateWithDuration:ToggleAnimationDuration
                          delay:ToggleAnimationDuration / 2
                        options:0
                     animations:^{
                         self.bgImageView.transform = CGAffineTransformMakeScale(TransMinScale, TransMinScale);
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                         _touchEnabled = YES;
                         _touchUpInsided = NO;
                         _touchDownAnimationCompleted = NO;
                         self.alpha = 0;
                     }];
}

- (void)setupOnlyImageWithSize:(CGSize)size borderEnabled:(BOOL)borderEnabled {
    self.bgImageView.image = nil;
    if (borderEnabled) {
        self.bgImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.1].CGColor;
        self.bgImageView.layer.borderWidth = 1;
    }

    [self.textLabel removeFromSuperview];
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(size);
    }];
}

- (void)setupOnlyTextWithBorderEnabled:(BOOL)borderEnabled {
    self.bgImageView.image = nil;
    if (borderEnabled) {
        self.bgImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.1].CGColor;
        self.bgImageView.layer.borderWidth = 1;
    }
    
    [self.iconImageView removeFromSuperview];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)updateIconImage:(UIImage *)image text:(NSString *)text {
    self.iconImageView.image = image;
    self.textLabel.text = text;
}

- (void)updateConstraintWidth:(CGFloat)width {
    _size = CGSizeMake(width, _size.height);
    _contentView.clipsToBounds = NO;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Overrides

- (CGSize)intrinsicContentSize {
    return CGSizeEqualToSize(CGSizeZero, _size) ? RTActivityToggleSize : _size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeEqualToSize(CGSizeZero, _size) ? RTActivityToggleSize : _size;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _bgImageView.backgroundColor = selected ? _selectedColor : _backgroundImageColor;
    _iconImageView.image = selected ? _selectedIconImage : _iconImage;
}

#pragma mark - Privates

- (void)_kep_setupShadow {
    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:.05].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowRadius = 8;
}

- (void)_kep_setupSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    CGSize size = [self intrinsicContentSize];
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.clipsToBounds = YES;
    _contentView.userInteractionEnabled = NO;
    _contentView.layer.cornerRadius = size.width * TransMaxScale / 2;
    [self addSubview:_contentView];
    
    _bgImageView = [UIImageView kep_createImageView];
    _bgImageView.backgroundColor = _backgroundImageColor;
    _bgImageView.layer.cornerRadius = size.width / 2;
    [_contentView addSubview:_bgImageView];
    
    _iconImageView = [UIImageView kep_createImageView];
    _iconImageView.image = _iconImage;
    [_contentView addSubview:_iconImageView];
    
    _textLabel = [UILabel kep_createLabel];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont kep_systemRegularSize:14.f];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.text = _text;
    [_contentView addSubview:_textLabel];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.with.mas_equalTo(size.width * TransMaxScale);
        make.size.height.mas_equalTo(size.height * TransMaxScale);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(IconSize);
        make.centerY.equalTo(self).mas_offset(-(IconSize.height + TextOffset) / 2 + 1);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).mas_offset(TextOffset);
        make.width.mas_lessThanOrEqualTo(RTActivityToggleSize.width * .75);
    }];
    if (_progressEnabled) {
        _animationView = [[_KEPRTAnimationView alloc] initWithFrame:CGRectMake(0, 0, RTActivityToggleSize.width, RTActivityToggleSize.height)];
        _animationView.backgroundColor = [UIColor clearColor];
        _animationView.alpha = 0;
        [_contentView addSubview:_animationView];
        if (_animationView.superview) {
            [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.size.mas_equalTo(RTActivityToggleSize);
            }];
        }
    }
    [self _kep_addHandleEvents];
    [self _kep_setupShadow];
}

- (void)_kep_addHandleEvents {
    @weakify(self);
    [self bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self _kep_handleTouchUpInsideEvent];
    }
            forControlEvents:UIControlEventTouchUpInside];
    [self bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self _kep_handleTouchDownEvent];
    }
            forControlEvents:UIControlEventTouchDown];
    [self bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self _kep_handleTouchUpOutsideEvent];
    }
            forControlEvents:UIControlEventTouchUpOutside];
}

- (void)_kep_handleTouchDownEvent {
    BOOL isVoiceOverRunning = UIAccessibilityIsVoiceOverRunning();
    if (self.progressEnabled && !isVoiceOverRunning) {
        //如果进度模式 即progressEnabled = YES，VoiceOver开启才使用tap代替长按
        return;
    }
    if (!self.touchEnabled) {
        return;
    }
    _touchEnabled = NO;
    _touchDownAnimationCompleted = NO;
    [CATransaction begin];
    [self.bgImageView.layer removeAllAnimations];
    [CATransaction commit];
    [UIView animateWithDuration:ToggleAnimationDuration
                     animations:^{
                         self.bgImageView.transform = CGAffineTransformMakeScale(TransMaxScale, TransMaxScale);
                     }
                     completion:^(BOOL finished) {
                         self.touchDownAnimationCompleted = YES;
                     }];
}

- (void)_kep_handleTouchUpInsideEvent {
    BOOL isVoiceOverRunning = UIAccessibilityIsVoiceOverRunning();
    if (self.progressEnabled && !isVoiceOverRunning) {
        //如果进度模式 即progressEnabled = YES，VoiceOver开启才使用tap代替长按
        return;
    }
    if (self.touchUpInsided) {
        return;
    }
    _touchUpInsided = YES;
    [CATransaction begin];
    [self.bgImageView.layer removeAllAnimations];
    [CATransaction commit];
    if (_scaleDisappearEnabled) {
        [self disappearWithCompletion:^{
            if (self.didClickToggleBlock) {
                self.didClickToggleBlock();
            }
        }];
    }
    else {
        if (_touchDownAnimationCompleted) {
            [self _kep_transformIdentityBgImageViewDuration:ToggleAnimationDuration];
        }
        else {
            [UIView animateWithDuration:ToggleAnimationDuration / 2
                             animations:^{
                self.bgImageView.transform = CGAffineTransformMakeScale(TransMaxScale + TransMinScale, TransMaxScale + TransMinScale);
            }
                             completion:^(BOOL finished) {
                [self _kep_transformIdentityBgImageViewDuration:ToggleAnimationDuration / 2];
            }];
        }
    }
}

- (void)_kep_transformIdentityBgImageViewDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration
                     animations:^{
                         self.bgImageView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (self.didClickToggleBlock) {
                             self.didClickToggleBlock();
                         }
                         _touchEnabled = YES;
                         _touchUpInsided = NO;
                         _touchDownAnimationCompleted = NO;
                     }];
}

- (void)_kep_handleTouchUpOutsideEvent {
    BOOL isVoiceOverRunning = UIAccessibilityIsVoiceOverRunning();
    if (self.progressEnabled && !isVoiceOverRunning) {
        //如果进度模式 即progressEnabled = YES，VoiceOver开启才使用tap代替长按
        return;
    }
    [UIView animateWithDuration:ToggleAnimationDuration
                     animations:^{
                         self.bgImageView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         _touchEnabled = YES;
                         _touchUpInsided = NO;
                         _touchDownAnimationCompleted = NO;
                     }];
}


#pragma mark - end

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"__toggle %s", __FUNCTION__);
    BOOL isVoiceOverRunning = UIAccessibilityIsVoiceOverRunning();
    if (_progressEnabled && !isVoiceOverRunning) {
        [self _kep_beginAnimation];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"__toggle %s", __FUNCTION__);
    BOOL isVoiceOverRunning = UIAccessibilityIsVoiceOverRunning();
    if (_progressEnabled && !isVoiceOverRunning) {
        [self _kep_beginReductionAnimation];
        if (self.cancelPressureBlock) {
            self.cancelPressureBlock();
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    BOOL isVoiceOverRunning = UIAccessibilityIsVoiceOverRunning();
    if (_progressEnabled && !isVoiceOverRunning) {
        [self _kep_beginReductionAnimation];
    }
}

- (void)_kep_beginAnimation {
    _touchEnabled = NO;
    self.shouldStopDrawCircle = NO;
    self.animationState = KEPRTActivityToggleAnimationStateNone;
    [UIView animateWithDuration:ToggleAnimationDuration
                     animations:^{
                         self.bgImageView.transform = CGAffineTransformMakeScale(TransMaxScale, TransMaxScale);
                     }
                     completion:^(BOOL finished) {
                         [self _kep_setAnimiatonLayerPath];
                         NSInteger startTimerCount = self.startTimerCount;
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KEPZoomAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             if (startTimerCount == self.startTimerCount) {
                                 self.animationState = KEPRTActivityToggleAnimationStateDrawCircle;
                                 [self _kep_startTimer];
                             }
                         });
                     }];
}

- (void)_kep_beginReductionAnimation {
    if (self.currentProgress < KEPLowestAnimationProgress && self.animationState != KEPRTActivityToggleAnimationStateEnd) {
        self.shouldStopDrawCircle = YES;
        return;
    }
    if (self.animationState != KEPRTActivityToggleAnimationStateEnd) {
        self.lastProgress = self.currentProgress;
        self.animationState = KEPRTActivityToggleAnimationStateCancel;
        [self _kep_drawCircle];
    }
    self.startTimerCount++;
    [UIView animateWithDuration:ToggleAnimationDuration
                     animations:^{
                         self.bgImageView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         _touchEnabled = YES;
                         _touchUpInsided = NO;
                         _touchDownAnimationCompleted = NO;
                         self.animationView.alpha = 0;
                         self.currentProgress = 0;
                         self.animationView.animationLayer.strokeEnd = 0;
                     }];
}

- (void)_kep_setAnimiatonLayerPath {
    self.animationView.alpha = 1;
    self.animationView.animationLayer.strokeEnd = self.currentProgress;
}

- (void)_kep_drawCircle {
    if (KEPRTActivityToggleAnimationStateNone == self.animationState || KEPRTActivityToggleAnimationStateEnd == self.animationState) {
        return;
    }
    if (KEPRTActivityToggleAnimationStateDrawCircle == self.animationState) {
        if (self.currentProgress >= 1) {
            self.animationState = KEPRTActivityToggleAnimationStateEnd;
            [self _kep_stopTimer];
            if (self.didClickToggleBlock) {
                self.didClickToggleBlock();
            }
            return;
        }
        if (self.currentProgress >= KEPLowestAnimationProgress && self.shouldStopDrawCircle) {
            [self _kep_beginReductionAnimation];
        }
        self.currentProgress = MIN(self.currentProgress + 1 / KEPDrawCircleAnimationDuration / 50, 1);
    }
    else if (KEPRTActivityToggleAnimationStateCancel == self.animationState) {
        if (self.currentProgress == 0) {
            [self _kep_stopTimer];
            self.animationState = KEPRTActivityToggleAnimationStateNone;
        }
        self.currentProgress = MAX(self.currentProgress - self.lastProgress / KEPZoomAnimationDuration / 50, 0);
    }
    [self _kep_setAnimiatonLayerPath];
}

- (void)_kep_startTimer {
    if (self.timer) {
        return;
    }
    @weakify(self);
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:0.02
                                                      block:^(NSTimer *timer) {
                                                          @strongify(self);
                                                          [self _kep_drawCircle];
    }
                                                    repeats:YES];
}

- (void)_kep_stopTimer {
    self.currentProgress = 0;
    if (_timer) {
        [_timer invalidate];
        self.timer = nil;
    }
}

@end

