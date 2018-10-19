//
//  TripDetailAnnotation.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/19.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "TripDetailAnnotation.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <Masonry/Masonry.h>

@implementation TripDetailAnnotation



@end
@implementation TripDetailAnnotationView


- (instancetype)initWithAnnotation:(id<MGLAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor kep_colorFromHex:0xC8CCD0];
        self.backgroundView.frame = CGRectMake(0, 0, 34, 34);
        self.backgroundView.layer.cornerRadius = 17;
        self.backgroundView.layer.masksToBounds = YES;
        self.frame = self.backgroundView.frame;
        [self addSubview:self.backgroundView];
        self.frame = self.backgroundView.frame;
        
        self.centerOffset = CGVectorMake(0, -CGRectGetHeight(self.frame)/2);
        
        self.label = [UILabel kep_createLabel];
        self.label.font = [UIFont kep_systemBoldSize:13];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        self.label.preferredMaxLayoutWidth = 30;
        self.label.adjustsFontSizeToFitWidth = YES;
        
        self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundView.layer.borderWidth = 2;
    }
    return self;
}


- (void)setCurrentModel:(TripDetailModel *)currentModel {
    _currentModel = currentModel;
    @weakify(self);
    [[RACObserve(self.currentModel, selected) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.backgroundView.backgroundColor = self.currentModel.selected ? [KColorManager buttonGreenTitleColor] : [UIColor kep_colorFromHex:0xC8CCD0];
        
    }];
}

@end
