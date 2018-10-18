//
//  KEPBaseEntryCell+Helper.m
//  Keep
//
//  Created by jianjun on 2018-04-02.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <objc/message.h>
#import <KEPIntlCommon/KEPCommon.h>
#import "KEPBaseEntryCell+Helper.h"
#import "KEPTimelineEntryCell.h"
#import "KEPTimelineEntryCellHelper.h"


@implementation KEPBaseEntryCell (Helper)

+ (void)registerCellIdentifier:(UITableView *)tableView {
    [KEPTimelineEntryCell registerInTableView:tableView];
}

+ (NSString *)reuseIdOfModel:(TripDetailModel *)model {
    return [KEPTimelineEntryCell reuseIdentifierByModel:model];
}

+ (CGFloat)cellHeightOfModel:(TripDetailModel *)model {
    return [KEPTimelineEntryCellHelper cellHeightOfModel:model];
}
+ (CGSize)handleImageWidthAndHeight:(NSString *)photo {
    if (!photo || [photo isKindOfClass:[NSNull class]]) {
        return CGSizeZero;
    }
    
    NSArray *photoUrlArray = [photo componentsSeparatedByString:@"_"];
    if (!photoUrlArray.count) {
        return CGSizeZero;
    }
    
    NSString *photoSize = [photoUrlArray kep_objectAtIndexChecked:1];
    NSArray *photoSizeArray = [photoSize componentsSeparatedByString:@"x"];
    if (photoSizeArray.count == 0) {
        return CGSizeZero;
    }
    CGFloat photoWidth = [[photoSizeArray kep_objectAtIndexChecked:0] integerValue];
    CGFloat photoHeight = [[photoSizeArray kep_objectAtIndexChecked:1] integerValue];
    if (!photoWidth || !photoHeight) {
        return CGSizeZero;
    }
    CGSize size = CGSizeMake(photoWidth, photoHeight);
    return size;
}

//限制文本高度的总高度
+ (CGFloat)heightForTimeLineContent:(NSAttributedString *)content lineSpace:(CGFloat)lineSpace font:(UIFont *)font {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:content];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    
    CGSize size = CGSizeMake([[KEPDeviceManager manager] horizontalLength] - 16 * 2, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}

@end
