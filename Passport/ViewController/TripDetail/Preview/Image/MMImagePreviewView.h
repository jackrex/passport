//
//  MMImagePreviewView.h
//  Keep
//
//  Created by CharlesChen on 2017/5/21.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MMImagePreviewView : UIView

- (void)updateWithImage:(id)image zoomEnabled:(BOOL)zoomEnabled userNameForSave:(NSString *)userNameForSave imageContentMode:(UIViewContentMode)imageContentMode;

@end
