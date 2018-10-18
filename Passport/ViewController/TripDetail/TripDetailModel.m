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

- (NSString *)dateText {
    if (!_dateText) {
        _dateText = [[NSDate dateWithTimeIntervalSince1970:self.date] formattedDateWithFormat:@"yyyy.MM.dd"];;
    }
    return _dateText;
}

- (BOOL)isGroupData {
    return NO;
}

@end

@implementation TripMetaData

- (TripMetaDataType)dataType {
    if ([self.type isEqualToString:@"running"]) {
        return TripMetaDataTypeRunning;
    } else if ([self.type isEqualToString:@"cycling"]) {
        return TripMetaDataTypeCycling;
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
