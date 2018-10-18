//
//  KEPEntryTextView.m
//  Keep
//
//  Created by jianjun on 2018-04-01.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <KEPIntlCommonUI/UILabel+KEPLineSpace.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <Masonry/Masonry.h>
#import <KEPIntlLocalization/KEPLocalization.h>

#import "KEPEntryTextView.h"
#import "KEPBaseEntryCell+Helper.h"
#import "TripDetailModel.h"

static CGFloat const kLineSpace = 4;

@interface KEPEntryTextView ()
@property (nonatomic, strong) TripDetailModel *TripDetailModel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *allTipsLabel;
@end

@implementation KEPEntryTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureTextLabel];
        [self configureAllTipsLabel];
    }
    return self;
}


#pragma mark - Getter

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor kep_colorFromHex:0x666666 alpha:1.0];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _textLabel;
}


- (UILabel *)allTipsLabel {
    if (!_allTipsLabel) {
        _allTipsLabel = [[UILabel alloc] init];
        _allTipsLabel.font = [UIFont systemFontOfSize:15];
        _allTipsLabel.textColor = [UIColor kep_colorFromHex:0x999999 alpha:1.0];
    }
    return _allTipsLabel;
}


#pragma mark - Configure

- (void)configureTextLabel {
    [self addSubview:self.textLabel];
    self.textLabel.preferredMaxLayoutWidth = ScreenSize.width - 16 * 2;
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
    }];
}


- (void)configureAllTipsLabel {
    [self addSubview:self.allTipsLabel];
    
    [self.allTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(4);
        make.left.equalTo(self.mas_left).offset(16);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(0).priorityLow();
    }];
}

- (void)setTextNumberOfLines:(NSInteger)lines {
    self.textLabel.numberOfLines = lines;
}

- (void)updateData:(TripDetailModel *)model
{
    self.TripDetailModel = model;
    [self handleContent:model];
}

- (void)handleContent:(TripDetailModel *)TripDetailModel {
    NSString *content = [TripDetailModel.text filterSuffixEnter];
    [self.textLabel setText:content lineSpacing:kLineSpace];
    [self handleAllTipsLabel];
}

- (void)handleAllTipsLabel {
    CGFloat height = 0;
    CGFloat bottomMargin = 0;
    CGFloat allTopMargin = 0;
 
    if (self.textLabel.numberOfLines != 0) {
        if ([self.TripDetailModel.text filterSuffixEnter].length == 0) {
            self.allTipsLabel.text = @"";
        } else {
            CGFloat textHeight = [UILabel heightWithFontSize:self.textLabel.font.pointSize
                                                            text:self.textLabel.text
                                                           width:self.textLabel.preferredMaxLayoutWidth
                                                     lineSpacing:kLineSpace
                                                   numberOfLines:0];
            CGFloat fiveLineHeight = [UILabel heightWithFontSize:self.textLabel.font.pointSize
                                                        text:self.textLabel.text
                                                       width:self.textLabel.preferredMaxLayoutWidth
                                                 lineSpacing:kLineSpace
                                               numberOfLines:self.textLabel.numberOfLines];
            if (round(textHeight) > round(fiveLineHeight)) {
                self.allTipsLabel.text = KEPLocalizedString(@"intl_view_all");
                height = 20;
                allTopMargin = 8;
            } else {
                self.allTipsLabel.text = @"";
            }
            bottomMargin = [self bottomMargin];
        }
    } else {
        bottomMargin = [self bottomMargin];
    }
    [self updateAllTipsLabelLayout:allTopMargin bottom:bottomMargin height:height];
}

- (void)updateAllTipsLabelLayout:(CGFloat)top bottom:(CGFloat)bottom height:(CGFloat)height {
    [self.allTipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(top);
        make.bottom.equalTo(self.mas_bottom).offset(bottom);
        make.height.mas_equalTo(height).priorityHigh();
    }];
}

- (CGFloat)bottomMargin {
    return 0;
}



@end
