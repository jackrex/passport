//
//  KEPBaseEntryCell+Helper.h
//  Keep
//
//  Created by jianjun on 2018-04-02.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "KEPBaseEntryCell.h"

@interface KEPBaseEntryCell (Helper)

#pragma mark - helper
+ (void)registerCellIdentifier:(UITableView *)tableView;

+ (NSString *)reuseIdOfModel:(TripDetailModel *)model;

+ (CGFloat)cellHeightOfModel:(TripDetailModel *)model;

+ (CGSize)handleImageWidthAndHeight:(NSString *)photo;

+ (CGFloat)heightForTimeLineContent:(NSAttributedString *)content lineSpace:(CGFloat)lineSpace font:(UIFont *)font;


@end
