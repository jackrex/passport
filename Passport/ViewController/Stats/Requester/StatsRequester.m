//
//  StatsRequester.m
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import "StatsRequester.h"
#import <KEPIntlNetwork/KEPNetwork.h>
#import "StatsModel.h"

@implementation StatsRequester

+ (void)fetchStatsInfoWithCallback:(void (^)(BOOL success, NSDictionary *dic))callback {
    KEPRequest *request = [[KEPRequest alloc] init];
    request.requestMethod = KEPRequestMethodGET;
    request.requestUrl = @"https://kapi.sre.gotokeep.com/mock/125/stats/v1/home";
    [request startWithBlock:^(__kindof KEPRequest * _Nonnull request) {
        NSDictionary *data = [request.responseDictionary objectForKey:kResultData];
        StatsModel *stats = [[StatsModel alloc] initWithDictionary:data error:nil];
        NSDictionary *dict = stats ? @{kResultData:stats} : nil;
        callback(YES, dict);
    } failure:^(__kindof KEPRequest * _Nonnull request) {
        callback(NO, request.responseDictionary);
    }];
}

@end