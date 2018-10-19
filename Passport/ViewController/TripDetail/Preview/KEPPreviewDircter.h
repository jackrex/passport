//
//  KEPPreviewDircter.h
//  KEPIntlCommonUI
//
//  Created by Wenbo Cao on 2018/7/29.
//  Copyright © 2018 Wenbo Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KEPPreviewDircter : NSObject

+ (void)previewTimelineImages:(NSArray<NSString *> *)images
                 currentIndex:(NSUInteger)index
                   authorName:(NSString *)authorName;

@end
