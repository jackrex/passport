//
//  KEPEntryHeaderView.m
//  Keep
//
//  Created by caowenbo on 2018-07-18.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <BlocksKit/UIView+BlocksKit.h>
#import <KEPIntlCommonUI/KEPIntlCommonUI.h>
#import <Masonry/Masonry.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "KEPEntryHeaderView.h"
#import "TripDetailModel.h"


static CGSize const kAvatarSize = {35, 35};

@interface KEPEntryHeaderView ()

@property (nonatomic, strong) TripDetailModel *TripDetailModel;

@property(nonatomic, strong) UIView *dayIndexBackgroundView;
@property(nonatomic, strong) UILabel *dayIndexLabel;
@property(nonatomic, strong) UIImageView *avatarView;


@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation KEPEntryHeaderView

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self _kep_setupSubviews];
    return self;
}


#pragma mark - Public Methods

- (void)updateData:(TripDetailModel *)model {
    self.TripDetailModel = model;
    
    if (model.isGroupData) {
        TripGroupFeature *data = model;
        self.dayIndexBackgroundView.hidden = YES;
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:data.properties.avatar]];
        self.nameLabel.text = data.properties.username;
        self.timeLabel.text = [NSString stringWithFormat:@"%@", data.properties.country];
    } else {
        self.dayIndexLabel.text = [NSString stringWithFormat:@"D%ld", model.dayIndex + 1];
        self.nameLabel.text = model.cityName;
        self.timeLabel.text = model.dateText;
    }

}

+ (CGFloat)viewHeight {
    return 95;
}


#pragma mark - Private Methods

- (void)_kep_setupSubviews {
    [self addSubview:self.dayIndexBackgroundView];
    [self.dayIndexBackgroundView addSubview:self.dayIndexLabel];
    [self addSubview:self.avatarView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    
    
    [self.dayIndexBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).inset(15.5);
        make.top.mas_equalTo(self).inset(16);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.dayIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        make.edges.mas_equalTo(self.dayIndexBackgroundView);
    }];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.dayIndexBackgroundView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.dayIndexBackgroundView.mas_trailing).offset(8);
        make.top.mas_equalTo(self).inset(15.5);
        make.trailing.mas_equalTo(self).inset(32);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4);
        make.trailing.mas_equalTo(self).inset(32);
    }];
}


#pragma mark - Getter

- (UIView *)dayIndexBackgroundView {
    if (!_dayIndexBackgroundView) {
        _dayIndexBackgroundView = [[UIView alloc] init];
        _dayIndexBackgroundView.backgroundColor = [KColorManager buttonGreenTitleColor];
    }
    return _dayIndexBackgroundView;
}

- (UILabel *)dayIndexLabel {
    if (!_dayIndexLabel) {
        _dayIndexLabel = [UILabel kep_createLabel];
        _dayIndexLabel.font = [UIFont kep_systemBoldSize:32];
        _dayIndexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayIndexLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel kep_createLabel];
        _nameLabel.font = [UIFont kep_systemBoldSize:23];
        _nameLabel.textColor = [KColorManager commonBlackTextColor];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel kep_createLabel];
        _timeLabel.font = [UIFont kep_systemRegularSize:14];
        _timeLabel.textColor = [KColorManager subFeedTextColor];
    }
    return _timeLabel;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView kep_createImageView];
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = 30;
        _avatarView.layer.borderColor = [KColorManager buttonGreenTitleColor].CGColor;
        _avatarView.layer.borderWidth = 2;
    }
    return _avatarView;
}
@end
