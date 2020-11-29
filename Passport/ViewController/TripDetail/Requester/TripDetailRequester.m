//
//  TripDetailRequester.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

#import "TripDetailRequester.h"

#import "TripDetailModel.h"
#import "Passport-Swift.h"

@implementation TripDetailRequester

+ (void)fetchTripDetailWithId:(NSString *)detailId callback:(void (^)(BOOL success,  NSDictionary*dic))callback {
    KEPRequest *request = [[KEPRequest alloc] init];
    request.requestMethod = KEPRequestMethodGET;
    request.requestUrl = @"http://api.pre.gotokeep.com/box/hackday/trips/detail";
    request.requestArgument = @{@"userId": @"" ?: @"",
                                @"tripId": detailId ?: @""
                                };
    [request startWithBlock:^(__kindof KEPRequest * _Nonnull request) {
        NSArray *data = [request.responseDictionary objectForKey:kResultData];
        NSError *error = nil;
        NSArray *models = [TripDetailModel arrayOfModelsFromDictionaries:data error:&error];
        [models enumerateObjectsUsingBlock:^(TripDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.dayIndex = idx;
            TripPointModel *model = obj.points.firstObject;
            NSArray <PHAsset *>* localImages = nil;
            if (model) {
                localImages = [PhotoScanProcessor getPicFromDate:obj.timeDate :[[CLLocation alloc] initWithLatitude:model.latitude longitude:model.longitude]];;
            }
         
            if (model && obj.pictures.count == 0 && localImages.count > 0) {
                obj.pictures = localImages;
            }
            

            if (localImages.count > 0) {
                obj.points = [[[localImages rac_sequence] map:^id _Nullable(PHAsset * _Nullable value) {
                    TripPointModel *model = [[TripPointModel alloc] init];
                    model.latitude = value.location.coordinate.latitude;
                    model.longitude = value.location.coordinate.longitude;
                    return value.location ? model : nil;
                }] array];
            }
            
            
        }];
        NSDictionary *dict = models ? @{kResultData:models} : nil;
        callback(YES, dict);
    } failure:^(__kindof KEPRequest * _Nonnull request) {
        callback(NO, request.responseDictionary);
    }];
}
@end
