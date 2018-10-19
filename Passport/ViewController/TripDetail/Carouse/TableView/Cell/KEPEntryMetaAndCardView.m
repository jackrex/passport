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


@interface _MetaView : UIView

@property(nonatomic, strong) UIImageView *typeIconImageView;
@property(nonatomic, strong) UILabel *nameLabel;

@end

@implementation _MetaView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self _kep_setupSubivews];
    return self;
}

- (void)_kep_setupSubivews {
    [self addSubview:self.typeIconImageView];
    [self addSubview:self.nameLabel];
    
    [self.typeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).inset(8);
        make.top.mas_equalTo(self).inset(4);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.mas_equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.typeIconImageView);
        make.leading.mas_equalTo(self.typeIconImageView.mas_trailing).offset(4);
        make.trailing.mas_lessThanOrEqualTo(self).offset(-16);
    }];
}

- (void)updateUIWithMeta:(TripMetaData *)metaData {
    self.nameLabel.text = metaData.text;
    if (metaData.dataType == TripMetaDataTypeStep) {
        self.typeIconImageView.image = [UIImage imageNamed:@"ic_step"];
    } else {
        self.typeIconImageView.image = [UIImage imageNamed:@"ic_train"];
    }
}

- (UIImageView *)typeIconImageView {
    if (!_typeIconImageView) {
        _typeIconImageView = [UIImageView kep_createImageView];
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



@end
@interface KEPEntryMetaAndCardView ()

@property(nonatomic, strong) NSMutableArray <_MetaView *> *metaViews;
@end

@implementation KEPEntryMetaAndCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    return self;
}

+ (BOOL)shouldDisplayForData:(TripDetailModel *)model {
    return model.keepDatas.count > 0;
}

- (void)updateData:(TripDetailModel *)model {
    self.backgroundColor = [UIColor kep_colorFromHex:0XfaFAFA];
    [self.metaViews enumerateObjectsUsingBlock:^(_MetaView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.metaViews removeAllObjects];
    
    for (NSInteger i = 0; i < model.keepDatas.count; i++) {
        _MetaView *view = [[_MetaView alloc] init];
        [view updateUIWithMeta:model.keepDatas[i]];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_offset(0);
            make.height.mas_equalTo(24);
            if (i == 0) {
                make.top.mas_offset(12);
            } else {
                make.top.mas_equalTo(self.metaViews.lastObject.mas_bottom);
            }
            if (i == model.keepDatas.count - 1) {
                make.bottom.mas_offset(-12);
            }
        }];
        [self.metaViews addObject:view];
    }
}


- (NSMutableArray<_MetaView *> *)metaViews {
    if (!_metaViews) {
        _metaViews = [NSMutableArray array];
    }
    return _metaViews;
}



@end
