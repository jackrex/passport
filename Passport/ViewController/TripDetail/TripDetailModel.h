//
//  TripDetailModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <KEPIntlJSONModel/KEPBaseJSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailModel : KEPBaseJSONModel

@property(nonatomic, assign) NSInteger index;

+ (NSArray *)testModels;

@end

NS_ASSUME_NONNULL_END
