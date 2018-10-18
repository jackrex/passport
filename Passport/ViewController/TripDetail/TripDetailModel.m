//
//  TripDetailModel.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//
#import <DateTools/DateTools.h>
#import "TripDetailModel.h"

@implementation TripDetailModel

- (NSString *)dateText {
    if (!_dateText) {
        _dateText = [[NSDate dateWithTimeIntervalSince1970:self.date] formattedDateWithFormat:@"yyyy.MM.dd"];;
    }
    return _dateText;
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
