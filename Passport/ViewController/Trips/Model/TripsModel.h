//
//  TripsModel.h
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KEPIntlJSONModel/KEPBaseJSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TripsClipModel

@end

@interface TripsClipModel : KEPBaseJSONModel

@property(nonatomic, copy) NSString *_id;
@property(nonatomic, copy) NSString *cityTitle;
@property(nonatomic, copy) NSString *desc;

@end

@interface TripsModel : KEPBaseJSONModel

@property(nonatomic, assign) NSInteger dayCount;
@property(nonatomic, assign) NSInteger countryCount;
@property(nonatomic, assign) NSInteger longestTripDayCount;
@property(nonatomic, copy) NSString *beatRate;
@property(nonatomic, copy) NSArray<TripsClipModel> *clips;

@end

NS_ASSUME_NONNULL_END
