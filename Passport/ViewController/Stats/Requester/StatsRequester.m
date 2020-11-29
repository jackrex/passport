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
#import "Passport-Swift.h"

@implementation StatsRequester

+ (void)fetchStatsInfoWithCallback:(void (^)(BOOL success, NSDictionary *dic))callback {
    KEPRequest *request = [[KEPRequest alloc] init];
    request.requestMethod = KEPRequestMethodPOST;
    request.requestUrl = @"http://api.pre.gotokeep.com/box/hackday/stats";
//    request.requestUrl = @"https://kapi.sre.gotokeep.com/mock/125/box/hackday/stats";
    NSString *userId = @"";
    if (userId.length == 0) {
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"userId":userId}];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [dict addEntriesFromDictionary:[PhotoScanProcessor generateJSON]];
        dispatch_async(dispatch_get_main_queue(), ^{
            request.requestArgument = dict;
            [request startWithBlock:^(__kindof KEPRequest * _Nonnull request) {
                NSDictionary *data = [request.responseDictionary objectForKey:kResultData];
                if ([data isKindOfClass:[NSDictionary class]]) {
                    StatsModel *stats = [[StatsModel alloc] initWithDictionary:data error:nil];
                    NSDictionary *dict = stats ? @{kResultData:stats} : nil;
                    callback(YES, dict);
                } else {
                    callback(NO,nil);
                }
            } failure:^(__kindof KEPRequest * _Nonnull request) {
                callback(NO, request.responseDictionary);
            }];
            
        });
        
    });
}

@end
