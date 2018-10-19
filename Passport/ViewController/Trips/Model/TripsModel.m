//
//  TripsModel.m
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import "TripsModel.h"

@implementation TripsClipModel

+ (JSONKeyMapper *)keyMapper {
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{ @"_id": @"id" }];
    return mapper;
}

@end

@implementation TripsModel

@end
