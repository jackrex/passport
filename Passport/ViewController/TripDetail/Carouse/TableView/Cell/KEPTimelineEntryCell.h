//
//  KEPTimelineEntryCell.h
//  Keep
//
//  Created by jianjun on 2018-04-01.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//


#import "KEPBaseEntryCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TripDetailModel;

@interface KEPTimelineEntryCell : KEPBaseEntryCell

@property (nonatomic) BOOL updateHeightOnly;

+ (NSString *)reuseIdentifierByModel:(TripDetailModel *)model;
+ (void)registerInTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
