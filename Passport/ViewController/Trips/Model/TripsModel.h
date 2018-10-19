//
//  TripsModel.h
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KEPIntlJSONModel/KEPBaseJSONModel.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TripsClipModel

@end

@interface TripsClipModel : KEPBaseJSONModel

@property(nonatomic, copy) NSString *_id;
@property(nonatomic, copy) NSString *cnCity;
@property(nonatomic, copy) NSString *cnCountry;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, assign) NSInteger dayCount;
@property(nonatomic, copy) NSString *pic;
@property(nonatomic, copy) NSString *beginDate;
@property(nonatomic, copy) NSString *endDate;

// custom
@property(nonatomic, strong, nullable) UIImage *cacheImage;

@end

@interface TripsModel : KEPBaseJSONModel

@property(nonatomic, assign) NSInteger dayCount;
@property(nonatomic, assign) NSInteger countryCount;
@property(nonatomic, assign) NSInteger longestTripDayCount;
@property(nonatomic, assign) NSInteger beatRate;
@property(nonatomic, copy) NSArray<TripsClipModel> *trips;

@end

NS_ASSUME_NONNULL_END
