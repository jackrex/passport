//
//  POSTSecuritySign.m
//  Keep
//
//  Created by 孙英伦 on 2017/5/24.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "POSTSecuritySign.h"
#import <KEPIntlCommon/KEPCommon.h>

static NSString *const POSTSignKey = @"V1QiLCJhbGciOiJIUzI1NiJ9";


@implementation POSTSecuritySign

+ (NSString *)sign:(NSString *)url body:(NSDictionary *)dict {
    NSString *bodyFormat = [self formatBodyJSON:dict];
    NSString *paraFormat = [self formatParameter:[[NSURL URLWithString:[url encodeString]] queryDictionary]];
    NSString *pathFormat = [self formatURL:url];
    if (bodyFormat == nil) {
        bodyFormat = @"";
    }
    if (paraFormat == nil) {
        paraFormat = @"";
    }
    if (pathFormat == nil) {
        pathFormat = @"";
    }
    NSString *firstResult = [NSString stringWithFormat:@"%@%@%@%@", bodyFormat, paraFormat, pathFormat, POSTSignKey];
    NSString *md5 = [KEPFileHelper stringToMD5:firstResult];
    NSString *sign = [KEPIntlComonUtils stringOffsetSecurity:md5];
    return sign;
}

+ (NSString *)formatURL:(NSString *)string {
    NSURL *url = [NSURL URLWithString:[string encodeString]];
    if (url == nil || url.path.length == 0) {
        return @"";
    }
    NSString *path = url.path;
    if (![path hasPrefix:@"/"]) {
        path = [NSString stringWithFormat:@"/%@", path];
    }
    return path;
}

+ (NSString *)formatBodyJSON:(NSDictionary *)body {
    if (body == nil || body.count == 0) {
        return @"";
    }
    NSData *data = nil;
    @try {
        data = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    } @catch (NSException *exception) {
        
    }
    if (data == nil) {
        return @"";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)formatParameter:(NSDictionary *)dict {
    NSArray *result = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *_Nonnull obj1, NSString *_Nonnull obj2) {
        //降序
        return [obj1 compare:obj2];
    }];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            id value = dict[obj];
            NSString *string = nil;
            if ([value isKindOfClass:[NSArray class]]) {
                NSArray *valueArray = value;
                if (valueArray.count == 1) {
                    string = valueArray.firstObject;
                } else {
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
                    string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
            }
            if (string && string.length > 0) {
                string = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)(string), NULL, CFSTR(","), kCFStringEncodingUTF8)); //逗号强制转（比较坑）
                [array addObject:[NSString stringWithFormat:@"%@=%@", [obj lowercaseString], string]];
            }
        }
    }];
    if (array.count != 0) {
        NSString *dest = [array componentsJoinedByString:@"&"];
        return dest;
    }
    return nil;
}

+ (NSDictionary *)dictDes:(NSDictionary *)dict {
    if (dict && dict.count > 0) {
        NSMutableDictionary *newdic = [[NSMutableDictionary alloc] init];
        for (id key in dict) {
            NSObject *value = dict[key];
            if ([value isKindOfClass:[NSDictionary class]]) {
                NSDictionary *subdict = [self dictDes:(NSDictionary *)value];
                if (subdict) {
                    [newdic setObject:subdict forKey:key];
                } else {
                    [newdic setObject:@"no subdict" forKey:key];
                }
            } else {
                if (value.description) {
                    [newdic setObject:value.description forKey:key];
                } else {
                    [newdic setObject:@"no description" forKey:key];
                }
            }
        }
        return newdic;
    }
    return nil;
}

+ (NSString *)generateUID:(NSString *)token {
    NSDictionary *dict = [A0JWTDecoder payloadOfJWT:token error:nil];
    return dict[@"_id"];
}

@end
