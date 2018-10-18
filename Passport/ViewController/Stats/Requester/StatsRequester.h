//
//  StatsRequester.h
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatsRequester : NSObject

+ (void)fetchStatsInfoWithCallback:(void (^)(BOOL success, NSDictionary *dic))callback;

@end

NS_ASSUME_NONNULL_END
