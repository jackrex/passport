//
//  KEPBaseEntryCell.h
//  Keep
//
//  Created by jianjun on 2018-04-02.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//


#import "TripDetailBaseHeaderCell.h"
@import UIKit;
@class TripDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface KEPBaseEntryCell : TripDetailBaseHeaderCell

@property (nonatomic, strong, nullable) TripDetailModel *TripDetailModel;

- (void)updateData:(TripDetailModel *)model;
- (void)updateDataForHeight:(TripDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
