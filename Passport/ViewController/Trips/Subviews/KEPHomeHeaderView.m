//
//  KEPHomeHeaderView.m
//  Keep
//
//  Created by Wenbo Cao on 13/04/2018.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <KEPIntlCommon/KEPCommon.h>
#import <BlocksKit/UIView+BlocksKit.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "KEPHomeHeaderView.h"
#import "TripsModel.h"

static CGFloat const ExpandViewHeight = 302;
static CGFloat const FoldViewHeight = 152;

static CGFloat const ExpandDataViewHeight = 272;
static CGFloat const FoldDataViewHeight = 92;

@interface KEPHomeHeaderView ()

@property(nonatomic, strong) UIView *dataContainerView;
@property(nonatomic, strong) UILabel *totalMinLabel;
@property(nonatomic, strong) UILabel *totalMinTitleLabel;
@property(nonatomic, strong) UILabel *trainingDayLabel;
@property(nonatomic, strong) UILabel *trainingDayTitleLabel;
@property(nonatomic, strong) UILabel *longestStreakLabel;
@property(nonatomic, strong) UILabel *longestStreakTitleLabel;

@property(nonatomic, strong) UIView *insightContainerView;
@property(nonatomic, strong) UIView *insightContainerAnimationView;
@property(nonatomic, strong) UIImageView *insightImageView;
@property(nonatomic, strong) UILabel *insightLabel;
@property(nonatomic, strong) UIImageView *insightArrow;
@property(nonatomic, strong) UIView *middleLine;

@property(nonatomic, assign) CGFloat progress;

@property(nonatomic, strong) UIButton *trainglogButton;


@end

@implementation KEPHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [[self class] viewHeight])];
    if (!self) {
        return nil;
    }
    [self _kep_setupSubviews];
    [self _kep_setupNotification];
    return self;
}


#pragma mark - Public Methods

+ (CGFloat)viewHeight {
    return ExpandViewHeight + iPhoneXTopOffsetY;
}

+ (CGFloat)foldViewHeight {
    return FoldViewHeight + iPhoneXTopOffsetY;
}

- (void)updateUIWithModel:(TripsModel *)trips {
    self.totalMinLabel.text = [NSString stringWithFormat:@"%ld", trips.dayCount];
    self.trainingDayLabel.text = [NSString stringWithFormat:@"%ld", trips.countryCount];
    self.longestStreakLabel.text = [NSString stringWithFormat:@"%ld", trips.longestTripDayCount];
    self.insightLabel.attributedText = [self _kep_beatTextWithPercentage:trips.beatRate];
    [self updateFrameWithProgress:self.progress];
}


- (void)updateFrameWithProgress:(CGFloat)progress {
    progress = MIN(MAX(progress, 0), 1);
    self.progress = progress;
    
    self.size = CGSizeMake(self.width, [[self class] viewHeight] + progress * (FoldViewHeight - ExpandViewHeight));
    self.dataContainerView.frame = CGRectMake(0, 0, self.width, ExpandDataViewHeight + iPhoneXTopOffsetY + progress * (FoldViewHeight - ExpandDataViewHeight));
    
    self.totalMinLabel.font = [UIFont kep_fontForKeepWithSize:59 + progress * (32 - 59)];
    [self.totalMinLabel sizeToFit];
    self.totalMinLabel.frame = CGRectMake((self.width - self.totalMinLabel.width) / 2 + progress * (16 - (self.width - self.totalMinLabel.width) / 2 ), 51.5 + iPhoneXTopOffsetY + progress * (45.5 - 51.5), self.totalMinLabel.width, self.totalMinLabel.height);
    self.totalMinTitleLabel.frame = CGRectMake((self.width - self.totalMinTitleLabel.width) / 2 + progress * (16 + self.totalMinLabel.width + 8 - (self.width - self.totalMinTitleLabel.width) / 2 ), 114 + iPhoneXTopOffsetY + progress * (56 - 114), self.totalMinTitleLabel.width, self.totalMinTitleLabel.height);
    
    self.trainglogButton.y = self.totalMinTitleLabel.y;
    self.trainglogButton.left = self.totalMinTitleLabel.right + 6;
    
    CGFloat bottomLabelCenterMargin = [UIScreen mainScreen].bounds.size.width / 4;
    CGFloat bottomLabelY = 157.5 + iPhoneXTopOffsetY;
    CGFloat bottomTitleLabelY = 197 + iPhoneXTopOffsetY;
    
    self.trainingDayTitleLabel.alpha = self.longestStreakTitleLabel.alpha = self.longestStreakLabel.alpha = self.trainingDayLabel.alpha = 1 + 2.4 * progress * (0 - 1);
    
    [self.trainingDayLabel sizeToFit];
    self.trainingDayLabel.frame = CGRectMake(self.width / 2 - bottomLabelCenterMargin - self.trainingDayLabel.width / 2, bottomLabelY, self.trainingDayLabel.width, self.trainingDayLabel.height);
    
    self.trainingDayTitleLabel.top = bottomTitleLabelY;
    self.trainingDayTitleLabel.center = CGPointMake(self.trainingDayLabel.center.x, self.trainingDayTitleLabel.center.y);

    
    [self.longestStreakLabel sizeToFit];
    self.longestStreakLabel.frame = CGRectMake(self.width / 2 + bottomLabelCenterMargin - self.longestStreakLabel.width / 2, bottomLabelY, self.longestStreakLabel.width, self.longestStreakLabel.height);
    
    self.longestStreakTitleLabel.top = bottomTitleLabelY;
    self.longestStreakTitleLabel.center = CGPointMake(self.longestStreakLabel.center.x, self.longestStreakTitleLabel.center.y);
    
    self.insightContainerView.frame = CGRectMake(16 + progress * (0 - 16), 242 + iPhoneXTopOffsetY + progress * (FoldDataViewHeight - 242), self.width - 2 * 16 + progress * 2 * 16, 60);
    self.insightContainerView.layer.shadowOpacity = 0.1 + progress * (0 - 0.1) * 1.875;
    
    self.insightContainerAnimationView.frame = self.insightContainerView.bounds;
    self.insightContainerAnimationView.alpha = 1 + progress * (0 - 1) * 1.875;
    
    self.insightImageView.left = 16;
    self.insightImageView.center = CGPointMake(self.insightImageView.center.x, self.insightContainerView.height / 2);
    
    [self.insightLabel sizeToFit];
    self.insightLabel.left = 44;
    self.insightLabel.width = self.width - 2 * self.insightContainerView.left - 2 * self.insightLabel.left;
    self.insightLabel.center = CGPointMake(self.insightLabel.center.x, self.insightContainerView.height / 2);
    
    self.insightArrow.left = self.insightContainerView.width - 16 - self.insightArrow.width;
    self.insightArrow.center = CGPointMake(self.insightArrow.center.x, self.insightContainerView.height / 2);
    
    self.insightContainerView.layer.shadowOpacity = 0.1 + progress * (0 - 0.1);
    self.insightContainerView.layer.cornerRadius = 4 + progress * (0 - 4);
    
    if (progress <= 0.825) {
        self.middleLine.alpha = 0;
    } else {
        self.middleLine.alpha = 0 + (progress - 0.825) * (1 - 0) / (1 - 0.825);
    }
    
    self.middleLine.frame = CGRectMake(0, 92 + iPhoneXTopOffsetY, self.width, [KEPDeviceManager manager].lineHeight);
}


#pragma mark - Properties

- (UILabel *)totalMinLabel {
    if (!_totalMinLabel) {
        _totalMinLabel = [UILabel kep_createLabel];
        _totalMinLabel.font = [UIFont kep_fontForKeepWithSize:59];
        _totalMinLabel.textColor = [KColorManager commonBlackTextColor];
        _totalMinLabel.text = @"0";
    }
    return _totalMinLabel;
}

- (UILabel *)totalMinTitleLabel {
    if (!_totalMinTitleLabel) {
        _totalMinTitleLabel = [UILabel kep_createLabel];
        _totalMinTitleLabel.font = [UIFont kep_systemRegularSize:16.f];
        _totalMinTitleLabel.textColor = [KColorManager subFeedTextColor];
        _totalMinTitleLabel.text = @"旅行天数";
    }
    return _totalMinTitleLabel;
}

- (UILabel *)trainingDayLabel {
    if (!_trainingDayLabel) {
        _trainingDayLabel = [UILabel kep_createLabel];
        _trainingDayLabel.font = [UIFont kep_fontForKeepWithSize:36];
        _trainingDayLabel.textColor = [KColorManager commonBlackTextColor];
        _trainingDayLabel.text = @"0";
    }
    return _trainingDayLabel;
}

- (UILabel *)trainingDayTitleLabel {
    if (!_trainingDayTitleLabel) {
        _trainingDayTitleLabel = [UILabel kep_createLabel];
        _trainingDayTitleLabel.font = [UIFont kep_systemRegularSize:16];
        _trainingDayTitleLabel.textColor = [KColorManager subFeedTextColor];
        _trainingDayTitleLabel.text = @"旅行国家";
    }
    return _trainingDayTitleLabel;
}

- (UILabel *)longestStreakLabel {
    if (!_longestStreakLabel) {
        _longestStreakLabel = [UILabel kep_createLabel];
        _longestStreakLabel.font = [UIFont kep_fontForKeepWithSize:36];
        _longestStreakLabel.textColor = [KColorManager commonBlackTextColor];
        _longestStreakLabel.text = @"0";
    }
    return _longestStreakLabel;
}

- (UILabel *)longestStreakTitleLabel {
    if (!_longestStreakTitleLabel) {
        _longestStreakTitleLabel = [UILabel kep_createLabel];
        _longestStreakTitleLabel.font = [UIFont kep_systemRegularSize:16];
        _longestStreakTitleLabel.textColor = [KColorManager subFeedTextColor];
        _longestStreakTitleLabel.text = @"最长出行";
    }
    return _longestStreakTitleLabel;
}

- (UIView *)insightContainerView {
    if (!_insightContainerView) {
        _insightContainerView = [[UIView alloc] init];
        _insightContainerView.backgroundColor = [UIColor clearColor];
        [_insightContainerView setShadowOffset:CGSizeMake(0, 6) radius:20 opacity:0.1];
        _insightContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
        @weakify(self);
        [_insightContainerView bk_whenTapped:^{
            @strongify(self);
            !self.didClickInsightView ?: self.didClickInsightView();
        }];
    }
    return _insightContainerView;
}

- (UIView *)insightContainerAnimationView {
    if (!_insightContainerAnimationView) {
        _insightContainerAnimationView = [[UIView alloc] init];
        _insightContainerAnimationView.layer.cornerRadius = 4;
        _insightContainerAnimationView.backgroundColor = [UIColor whiteColor];
    }
    return _insightContainerAnimationView;
}

- (UIImageView *)insightImageView {
    if (!_insightImageView) {
        _insightImageView = [UIImageView kep_createImageView];
        _insightImageView.image = [UIImage imageNamed:@"icon_home_insight"];
    }
    return _insightImageView;
}

- (UILabel *)insightLabel {
    if (!_insightLabel) {
        _insightLabel = [UILabel kep_createLabel];
        _insightLabel.font = [UIFont kep_systemRegularSize:16.f];
        _insightLabel.textColor = [KColorManager subTextColor];
        _insightLabel.attributedText = [self _kep_beatTextWithPercentage:0];
    }
    return _insightLabel;
}

- (UIImageView *)insightArrow {
    if (!_insightArrow) {
        _insightArrow = [UIImageView kep_createImageView];
        _insightArrow.image = [UIImage imageNamed:@"icon_arrow_purple"];
    }
    return _insightArrow;
}

- (UIView *)middleLine {
    if (!_middleLine) {
        _middleLine = [[UIView alloc] init];
        _middleLine.alpha = 0;
        _middleLine.backgroundColor = [UIColor kep_colorFromHex:0xEBEBEB];
    }
    return _middleLine;
}

- (UIView *)dataContainerView {
    if (!_dataContainerView) {
        _dataContainerView = [[UIView alloc] init];
        _dataContainerView.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        [_dataContainerView bk_whenTapped:^{
            @strongify(self);
            !self.didClickDataCenterView ?: self.didClickDataCenterView();
        }];
    }
    return _dataContainerView;
}

- (UIButton *)trainglogButton {
    if (!_trainglogButton) {
        _trainglogButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_trainglogButton setBackgroundImage:[UIImage imageNamed:@"ic_home_error"] forState:UIControlStateNormal];
        _trainglogButton.hidden = YES;
        @weakify(self);
        [_trainglogButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            !self.didClickAutoTrainingLogView ?: self.didClickAutoTrainingLogView();
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _trainglogButton;
}
#pragma mark - Private Methods

- (void)_kep_setupSubviews {
    self.layer.masksToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.dataContainerView];
    [self.dataContainerView addSubview:self.totalMinLabel];
    [self.dataContainerView addSubview:self.totalMinTitleLabel];
    [self.dataContainerView addSubview:self.trainingDayLabel];
    [self.dataContainerView addSubview:self.trainingDayTitleLabel];
    [self.dataContainerView addSubview:self.longestStreakLabel];
    [self.dataContainerView addSubview:self.longestStreakTitleLabel];
    [self.dataContainerView addSubview:self.middleLine];
    [self.dataContainerView addSubview:self.trainglogButton];
    [self.totalMinTitleLabel sizeToFit];
    [self.trainingDayTitleLabel sizeToFit];
    [self.longestStreakTitleLabel sizeToFit];
    [self.trainglogButton sizeToFit];
    
    [self addSubview:self.insightContainerView];
    [self.insightContainerView addSubview:self.insightContainerAnimationView];
    [self.insightContainerView addSubview:self.insightImageView];
    [self.insightContainerView addSubview:self.insightLabel];
    [self.insightContainerView addSubview:self.insightArrow];
    [self.insightImageView sizeToFit];
    [self.insightArrow sizeToFit];
    
    [self updateFrameWithProgress:0];
}

- (void)_kep_setupNotification {
    
}



- (NSAttributedString *)_kep_beatTextWithPercentage:(NSInteger)percentage {
    percentage = MAX(0, MIN(100, percentage));
    NSMutableAttributedString *string = nil;
    NSString *percentageString = [NSString stringWithFormat:@"%ld%%", percentage];
    NSString *beatString = [NSString stringWithFormat:@"你的足迹打败了 %@ 的旅人", percentageString];
    string = [[NSMutableAttributedString alloc] initWithString: beatString];
    NSRange range = [beatString rangeOfString:percentageString];
    [string addAttribute:NSForegroundColorAttributeName
                   value:[KColorManager buttonGreenTitleColor]
                   range:range];
    return [string copy];
}

@end
