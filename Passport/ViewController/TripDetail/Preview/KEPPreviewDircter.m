//
//  KEPPreviewDircter.m
//  KEPIntlCommonUI
//
//  Created by Wenbo Cao on 2018/7/29.
//  Copyright © 2018 Wenbo Cao. All rights reserved.
//

#import "KEPPreviewDircter.h"
#import "MMTimelineImagesPreviewVC.h"

@implementation KEPPreviewDircter

+ (void)previewTimelineImages:(NSArray<NSString *> *)images
                 currentIndex:(NSUInteger)index
                   authorName:(NSString *)authorName {
    [[UIApplication sharedApplication].delegate.window endEditing:YES]; //把主window收起来
    
    MMTimelineImagesPreviewVC *previewVC = [[MMTimelineImagesPreviewVC alloc] initWithImages:images scrollToIndex:index];
    previewVC.userNameForSave = authorName;
    
    UIWindow *maskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskWindow.windowLevel = UIWindowLevelAlert;
    maskWindow.backgroundColor = [UIColor clearColor];
    [maskWindow makeKeyAndVisible];
    maskWindow.rootViewController = previewVC;
    
    previewVC.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        previewVC.view.alpha = 1;
    }];
    previewVC.closeHandler = ^{
        [UIView animateWithDuration:0.3 animations:^{
            maskWindow.rootViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            maskWindow.hidden = YES;
        }];
    };
}


@end
