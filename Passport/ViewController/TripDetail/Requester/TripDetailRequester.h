//
//  TripDetailRequester.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//
#import <KEPIntlNetwork/KEPNetwork.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailRequester : NSObject

+ (void)fetchTripDetailWithId:(NSString *)detailId callback:(void (^)(BOOL success, NSDictionary *dic))callback;

@end

NS_ASSUME_NONNULL_END
