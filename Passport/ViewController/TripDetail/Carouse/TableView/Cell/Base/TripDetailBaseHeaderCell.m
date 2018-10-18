
//
//  TripDetailBaseHeaderCell.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <KEPIntlCommon/KEPCommon.h>

#import "TripDetailBaseHeaderCell.h"


@interface TripDetailBaseHeaderCell ()

@property(nonatomic, strong) UIView *gapView;
@property (nonatomic, strong) UIView *bottomWhiteView;

@end

@implementation TripDetailBaseHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self _kep_setViews];
    return self;
}


- (void)adjustTableViewContent {
    self.layer.cornerRadius = 0;
    self.gapView.hidden = YES;
    self.bottomWhiteView.hidden = YES;
}

- (void)addRoundCorner {
    self.layer.cornerRadius = 5;
    self.gapView.hidden = NO;
    self.bottomWhiteView.hidden = NO;
}

- (UIView *)gapView {
    if (!_gapView) {
        _gapView = [[UIView alloc] init];
        _gapView.backgroundColor = [UIColor kep_colorFromHex:0xececec];
        _gapView.layer.cornerRadius = 2;
    }
    return _gapView;
}


- (UIView *)bottomWhiteView {
    if (!_bottomWhiteView) {
        _bottomWhiteView = [[UIView alloc] init];
        _bottomWhiteView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomWhiteView;
}

- (void)_kep_setViews {
    [self.contentView addSubview:self.gapView];
    [self.contentView addSubview:self.bottomWhiteView];
    [self.bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.height.mas_offset(5);
    }];
    [self.gapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_offset(6);
        make.size.mas_equalTo(CGSizeMake(16, 2));
    }];
}
@end
