//
//  ForchTouchManager.m
//  Passport
//
//  Created by xiongshuangquan on 2018/10/19.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import "ForchTouchManager.h"

@implementation ForchTouchManager

+ (void)add3DTouch:(UIViewController *)controller view:(UIView *)view {
    if (controller.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        //-- 控件添加3DTouch功能  注意 必须要判断设备是否支持此功能
        if ([controller respondsToSelector:@selector(traitCollection)]) {
            if ([controller.traitCollection respondsToSelector:@selector(forceTouchCapability)])
            {
                if(controller.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
                {
                    [controller registerForPreviewingWithDelegate:controller sourceView:view];
                }
            }
        }
    }
}

@end
