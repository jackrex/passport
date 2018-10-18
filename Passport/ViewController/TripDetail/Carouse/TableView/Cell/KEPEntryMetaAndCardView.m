//
//  KEPEntryMetaAndCardView.m
//  Keep
//
//  Created by Wenbo Cao on 2018/7/19.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <KEPIntlCommon/KEPCommon.h>
#import <Masonry/Masonry.h>

#import "KEPEntryMetaAndCardView.h"
#import "TripDetailModel.h"
//#import "UIImage+SocialLoad.h"

@interface KEPEntryMetaAndCardView ()

@property(nonatomic, strong) UIImageView *typeIconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIImageView *timeImageView;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIImageView *calorieImageView;
@property(nonatomic, strong) UILabel *calorieLabel;
@end

@implementation KEPEntryMetaAndCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self _kep_setupSubviews];
    return self;
}

+ (BOOL)shouldDisplayForData:(TripDetailModel *)model {
    return NO;
}


+ (CGFloat)viewHeight {
    return 58;
}

- (void)updateData:(TripDetailModel *)model {
//    self.nameLabel.text = [model.trainingDetail nameText];
//    self.timeLabel.text = [NSString hourWithSecond:[model.trainingDetail.secondDuration integerValue]];
//    self.calorieLabel.text = [model.trainingDetail.calorie stringValue];
}

#pragma mark - Private Methods

- (void)_kep_setupSubviews {
    self.backgroundColor = [UIColor kep_colorFromHex:0XfaFAFA];
    [self addSubview:self.typeIconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.calorieImageView];
    [self addSubview:self.calorieLabel];
    
    [self.typeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).inset(8);
        make.top.mas_equalTo(self).inset(11);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.typeIconImageView);
        make.leading.mas_equalTo(self.typeIconImageView.mas_trailing).offset(4);
        make.trailing.mas_lessThanOrEqualTo(self).offset(-16);
    }];
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).inset(29);
        make.top.mas_equalTo(self).inset(35);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeImageView);
        make.leading.mas_equalTo(self.timeImageView.mas_trailing).offset(5);
    }];
    [self.calorieImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeImageView);
        make.leading.mas_equalTo(self.timeLabel.mas_trailing).offset(9.5);
    }];
    [self.calorieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeImageView);
        make.leading.mas_equalTo(self.calorieImageView.mas_trailing).offset(5);
    }];
}


#pragma mark - Properties

- (UIImageView *)typeIconImageView {
    if (!_typeIconImageView) {
        _typeIconImageView = [UIImageView kep_createImageView];
//        _typeIconImageView.image = [UIImage sl_imageNamed:@"ic_activity_training"];
    }
    return _typeIconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel kep_createLabel];
        _nameLabel.textColor = [KColorManager subFeedTextColor];
        _nameLabel.font = [UIFont kep_systemRegularSize:12];
    }
    return _nameLabel;
}

- (UIImageView *)timeImageView {
    if (!_timeImageView) {
        _timeImageView = [UIImageView kep_createImageView];
//        _timeImageView.image = [UIImage sl_imageNamed:@"ic_activity_time"];
    }
    return _timeImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel kep_createLabel];
        _timeLabel.textColor = [KColorManager subFeedTextColor];
        _timeLabel.font = [UIFont kep_systemRegularSize:12];
    }
    return _timeLabel;
}

- (UIImageView *)calorieImageView {
    if (!_calorieImageView) {
        _calorieImageView = [UIImageView kep_createImageView];
//        _calorieImageView.image = [UIImage sl_imageNamed:@"ic_activity_calories"];
    }
    return _calorieImageView;
}

- (UILabel *)calorieLabel {
    if (!_calorieLabel) {
        _calorieLabel = [UILabel kep_createLabel];
        _calorieLabel.textColor = [KColorManager subFeedTextColor];
        _calorieLabel.font = [UIFont kep_systemRegularSize:12];
    }
    return _calorieLabel;
}

@end
