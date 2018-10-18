//
//  TripDetailRequester.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "TripDetailRequester.h"

#import "TripDetailModel.h"

@implementation TripDetailRequester

+ (void)fetchTripDetailWithId:(NSString *)detailId callback:(void (^)(BOOL success,  NSDictionary*dic))callback {
    KEPRequest *request = [[KEPRequest alloc] init];
    request.requestMethod = KEPRequestMethodGET;
    request.requestUrl = [NSString stringWithFormat:@"https://kapi.sre.gotokeep.com/mock/125/trip/v1/detail/%@", detailId ?: @""];
    [request startWithBlock:^(__kindof KEPRequest * _Nonnull request) {
        NSArray *data = [request.responseDictionary objectForKey:kResultData];
        NSError *error = nil;
        NSArray *models = [TripDetailModel arrayOfModelsFromDictionaries:data error:&error];
        NSDictionary *dict = models ? @{kResultData:models} : nil;
        callback(YES, dict);
    } failure:^(__kindof KEPRequest * _Nonnull request) {
        callback(NO, request.responseDictionary);
    }];
}
@end
