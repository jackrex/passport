//
//  TripDetailModel.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//
#import <DateTools/DateTools.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "TripDetailModel.h"

@implementation TripDetailModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"_id": @"id",
                                                                  @"cityName": @"city"
                                                                  }];
}

- (NSDate *)timeDate {
    if (!_timeDate) {
        _timeDate =  [NSDate dateWithString:self.date formatString:@"yyyyMMdd"];
    }
    return _timeDate;
}

- (NSString *)dateText {
    if (!_dateText) {
        _dateText = [self.timeDate formattedDateWithFormat:@"yyyy.MM.dd"];
    }
    return _dateText;
}

- (BOOL)isGroupData {
    return NO;
}

- (NSArray<TripMetaData *> *)keepDatas {
    if (!_keepDatas) {
        NSMutableArray *datas = [NSMutableArray array];
        if (self.run > 0) {
            TripMetaData *data = [[TripMetaData alloc] init];
            data.type = @"running";
            data.text = [NSString stringWithFormat:@"你完成了%.1f的跑步",self.run];
            [datas addObject:data];
        }
        
        if (self.cycling > 0) {
            TripMetaData *data = [[TripMetaData alloc] init];
            data.type = @"cycling";
            data.text = [NSString stringWithFormat:@"你完成了%.1f的骑行",self.cycling];
            [datas addObject:data];
        }
        
        if (self.hiking > 0) {
            TripMetaData *data = [[TripMetaData alloc] init];
            data.type = @"hiking";
            data.text = [NSString stringWithFormat:@"你完成了%.1f的行走",self.run];
            [datas addObject:data];
        }
        
        if (self.steps > 0) {
            TripMetaData *data = [[TripMetaData alloc] init];
            data.type = @"steps";
            data.text = [NSString stringWithFormat:@"你走了%ld步",self.steps];
            [datas addObject:data];
        }
        _keepDatas = [datas copy];
    }
    return _keepDatas;
}

@end

@implementation TripMetaData

- (TripMetaDataType)dataType {
    if ([self.type isEqualToString:@"running"]) {
        return TripMetaDataTypeRunning;
    } else if ([self.type isEqualToString:@"cycling"]) {
        return TripMetaDataTypeCycling;
    } else if ([self.type isEqualToString:@"hiking"]) {
        return TripMetaDataTypeHiking;
    }
    return TripMetaDataTypeStep;
}
@end


@implementation TripPointModel


@end

@implementation TripGroupPoint

- (CLLocationDegrees)latitude {
    return [self.coordinates[1] doubleValue];
}

- (CLLocationDegrees)longitude {
    return [self.coordinates[0] doubleValue];
}

@end

@implementation TripGroupPointPropeties


+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"_hash": @"hash"}];
}

@end

@implementation TripGroupFeature


+ (NSArray <TripGroupFeature *> *)defaultFeatures {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"group" ofType:@"plist"];
    NSArray *datas = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSError *error = nil;
    NSArray *features = [TripGroupFeature arrayOfModelsFromDictionaries:datas error:&error];
    return features;
}

- (BOOL)isGroupData {
    return YES;
}

@end
