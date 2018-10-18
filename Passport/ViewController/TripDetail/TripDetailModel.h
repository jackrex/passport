//
//  TripDetailModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <KEPIntlJSONModel/KEPBaseJSONModel.h>
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TripMetaDataType) {
    TripMetaDataTypeRunning,
    TripMetaDataTypeCycling,
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
@property(nonatomic, assign) NSTimeInterval date;
@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) NSArray *pictures;
@property(nonatomic, strong) NSArray <TripPointModel> *points;
@property(nonatomic, strong) NSArray <TripMetaData> *keepDatas;

@property(nonatomic, copy) NSString *dateText;


@end


NS_ASSUME_NONNULL_END
