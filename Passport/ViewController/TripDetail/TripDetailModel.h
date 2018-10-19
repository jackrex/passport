//
//  TripDetailModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <KEPIntlJSONModel/KEPBaseJSONModel.h>
@import CoreLocation;
@import Photos;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TripMetaDataType) {
    TripMetaDataTypeRunning,
    TripMetaDataTypeCycling,
    TripMetaDataTypeHiking,
    TripMetaDataTypeStep
};


KEPJSONMODELPROTOCOL(TripPointModel)
@interface TripPointModel : KEPBaseJSONModel

@property(nonatomic, assign) CLLocationDegrees latitude;
@property(nonatomic, assign) CLLocationDegrees longitude;

@end

KEPJSONMODELPROTOCOL(TripMetaData)
@interface TripMetaData : KEPBaseJSONModel

@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *text;

- (TripMetaDataType)dataType;

@end

@interface TripDetailModel : KEPBaseJSONModel

@property(nonatomic, copy) NSString *_id;
@property(nonatomic, assign) NSInteger dayIndex;
@property(nonatomic, copy) NSString *cityName;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, copy) NSString *date;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) NSArray *pictures;
@property(nonatomic, strong) NSArray <TripPointModel> *points;
@property(nonatomic, assign) CGFloat run;
@property(nonatomic, assign) CGFloat cycling;
@property(nonatomic, assign) CGFloat hiking;
@property(nonatomic, assign) NSInteger steps;

@property(nonatomic, strong) NSArray <TripMetaData *> *keepDatas;

@property(nonatomic, strong) NSDate *timeDate;
@property(nonatomic, copy) NSString *dateText;

@property(nonatomic, assign) BOOL selected;

- (BOOL)isGroupData;


@end


@interface TripGroupPoint: KEPBaseJSONModel

@property(nonatomic, assign) CLLocationDegrees latitude;
@property(nonatomic, assign) CLLocationDegrees longitude;

@property(nonatomic, strong) NSArray <NSNumber *>*coordinates;

@end

@interface TripGroupPointPropeties: KEPBaseJSONModel

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *_hash;
@property(nonatomic, copy) NSString *country;
@property(nonatomic, copy) NSString *nationCode;
@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *cityCode;

@end

@interface TripGroupFeature: TripDetailModel

@property(nonatomic, strong) TripGroupPoint *geometry;
@property(nonatomic, strong) TripGroupPointPropeties *properties;

+ (NSArray <TripGroupFeature *> *)defaultFeatures;

@end

NS_ASSUME_NONNULL_END
