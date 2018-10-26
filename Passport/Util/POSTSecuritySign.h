//
//  POSTSecuritySign.h
//  Keep
//
//  Created by 孙英伦 on 2017/5/24.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface POSTSecuritySign : NSObject

+ (NSString *)sign:(NSString *)url body:(NSDictionary *)dict;
+ (NSString *)generateUID:(NSString *)token;

@end
