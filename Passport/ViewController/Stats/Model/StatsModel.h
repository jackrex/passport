//
//  StatsModel.h
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KEPIntlJSONModel/KEPBaseJSONModel.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol StatsProfile

@end

@protocol StatsGazeWorld

@end


@protocol StatsPlace

@end

@protocol StatsPoetryDistance

@end

@protocol StatsFarthestWalkedDay

@end

@protocol StatsdDtaInsight

@end

@protocol StatsDestination

@end

@protocol StatsTomorrow

@end

@interface StatsProfile : KEPBaseJSONModel

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *birthday;

@end

@interface StatsGazeWorld : KEPBaseJSONModel

@property(nonatomic, assign) NSInteger countryCount;
@property(nonatomic, assign) double unlockRate;
@property(nonatomic, copy) NSArray<NSString *> *continents;

@end

@interface StatsPlace : KEPBaseJSONModel

@property(nonatomic, copy) NSString *cnCity;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, assign) long long distance;

@end

@interface StatsFarthestWalkedDay : KEPBaseJSONModel

@property(nonatomic, copy) NSString *day;
@property(nonatomic, assign) long long steps;

// custom
@property(nonatomic, strong, nullable) UIImage *cacheImage;

@end

@interface StatsPoetryDistance : KEPBaseJSONModel

@property(nonatomic, strong) StatsPlace *from;
@property(nonatomic, strong) StatsPlace *to;
@property(nonatomic, copy) NSString *day;
@property(nonatomic, assign) long long distance;
@property(nonatomic, strong) StatsFarthestWalkedDay *farthestWalkedDay;

// custom
@property(nonatomic, strong, nullable) UIImage *cacheImage;

@end

@interface StatsdDtaInsight : KEPBaseJSONModel

@property(nonatomic, assign) long long tripsCount;
@property(nonatomic, assign) long long beenToCity;
@property(nonatomic, assign) long long totalSteps;
@property(nonatomic, assign) long long totalDistance;

@end

@interface StatsDestination : KEPBaseJSONModel

@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *pic;

@end

@interface StatsTomorrow : KEPBaseJSONModel

@property(nonatomic, copy) NSString *lastTripDay;
@property(nonatomic, copy) NSArray<StatsDestination> *recommendedDestination;

@end

@interface StatsModel : KEPBaseJSONModel

@property(nonatomic, strong) StatsProfile *profile;
@property(nonatomic, strong) StatsGazeWorld *gazeWorld;
@property(nonatomic, strong) StatsPoetryDistance *poetryDistance;
@property(nonatomic, strong) StatsdDtaInsight *dataInsight;
@property(nonatomic, strong) StatsTomorrow *tomorrow;

@end

NS_ASSUME_NONNULL_END
