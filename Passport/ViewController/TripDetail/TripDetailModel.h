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

@property(nonatomic, assign) NSInteger dayIndex;
@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, strong) NSString *dateText;

@property(nonatomic, strong) NSArray *pictures;
@property(nonatomic, copy) NSString *text;

+ (NSArray *)testModels;

@end

NS_ASSUME_NONNULL_END
