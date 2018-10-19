//
//  MMTimelineImagesPreviewVC.h
//  Keep
//
//  Created by CharlesChen on 2017/5/23.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMImagesPreviewVC.h"


@interface MMTimelineImagesPreviewVC : MMImagesPreviewVC

@property (nonatomic, copy) void (^closeHandler)();

@end
