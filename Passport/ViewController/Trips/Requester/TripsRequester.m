//
//  TripsRequester.m
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import "TripsRequester.h"
#import <KEPIntlNetwork/KEPNetwork.h>
#import "TripsModel.h"
#import "Passport-Swift.h"

@implementation TripsRequester

+ (void)fetchTripsInfoWithCallback:(void (^)(BOOL success, NSDictionary *dic))callback {
    KEPRequest *request = [[KEPRequest alloc] init];
    request.requestMethod = KEPRequestMethodGET;
    request.requestUrl = @"http://api.pre.gotokeep.com/box/hackday/trips";
//    request.requestUrl = @"https://kapi.sre.gotokeep.com/mock/125/box/hackday/trips";
    NSString *userId = @"";
    if (userId.length == 0) {
        return;
    }
    request.requestArgument = @{@"userId":userId};
    [request startWithBlock:^(__kindof KEPRequest * _Nonnull request) {
        NSDictionary *data = [request.responseDictionary objectForKey:kResultData];
        TripsModel *trips = [[TripsModel alloc] initWithDictionary:data error:nil];
        NSDictionary *dict = trips ? @{kResultData:trips} : nil;
        callback(YES, dict);
    } failure:^(__kindof KEPRequest * _Nonnull request) {
        callback(NO, request.responseDictionary);
    }];
}

@end
