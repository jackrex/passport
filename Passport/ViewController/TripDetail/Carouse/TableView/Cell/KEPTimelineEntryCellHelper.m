//
//  KEPTimelineEntryCellHelper.m
//  Keep
//
//  Created by jianjun on 2018-04-01.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <KEPIntlCommon/KEPCommon.h>

#import "KEPTimelineEntryCellHelper.h"

#import "KEPTimelineEntryCell.h"
#import "KEPBaseEntryCell+Helper.h"
#import "KEPEntryMultiPhotosView.h"
#import "TripDetailModel.h"

static KEPTimelineEntryCell *gCell = nil;

@implementation KEPTimelineEntryCellHelper

+ (CGFloat)cellHeightOfModel:(TripDetailModel *)model
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gCell = [[KEPTimelineEntryCell alloc] init];
        gCell.updateHeightOnly = YES;
    });
    gCell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 10000);
    [gCell updateData:model];
    return gCell.frame.size.height;
}

+ (CGFloat)photoHeight:(TripDetailModel *)model {
    if (model.pictures.count == 0) {
        return 0;
    }

    if (model.pictures.count > 1) {
        CGFloat width = ScreenSize.width - [self leadingMargin] - [self tailingMargin];
        CGFloat height = width + [KEPEntryMultiPhotosView bottomPadding];
        return height;
    }
    
    CGSize size = [KEPBaseEntryCell handleImageWidthAndHeight:model.pictures.firstObject];
    if (size.width == size.height) {
        return [KEPDeviceManager manager].horizontalLength - [self leadingMargin] - [self tailingMargin];
    }
    
    return ([KEPDeviceManager manager].horizontalLength - [self leadingMargin] - [self tailingMargin]) * size.height / size.width;
}

+ (CGFloat)leadingMargin {
    return [self photoLeadingMargin];
}
+ (CGFloat)tailingMargin {
    return [self photoTailingMargin];
}
+ (CGFloat)photoLeadingMargin {
    if (IPAD_DEVICE) {
        return 14;
    }
    
    return 0;
}

+ (CGFloat)photoTailingMargin {
    if (IPAD_DEVICE) {
        return 14;
    }
    return 0;
}

@end
