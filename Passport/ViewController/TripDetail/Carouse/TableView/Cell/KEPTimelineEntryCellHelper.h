//
//  KEPTimelineEntryCellHelper.h
//  Keep
//
//  Created by jianjun on 2018-04-01.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import Foundation;

@class KEPTimelineView;
@class TripDetailModel;

@interface KEPTimelineEntryCellHelper : NSObject

+ (CGFloat)cellHeightOfModel:(TripDetailModel *)model;

+ (CGFloat)photoHeight:(TripDetailModel *)model;

+ (CGFloat)photoLeadingMargin;

+ (CGFloat)photoTailingMargin;

@end
