//
//  TripDetailModel.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "TripDetailModel.h"

@implementation TripDetailModel

+ (NSArray *)testModels {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        TripDetailModel *model = [[TripDetailModel alloc] init];
        model.dayIndex = i;
        model.cityName = [NSString stringWithFormat:@"city%ld", i];
        model.dateText = @"adasdads";
        model.text = @"aaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfaaaaasdasdasdasdasdasdasdasdasdadafasdasfsafasdfasfasfsafafsfa";
        [array addObject:model];
    }
    return [array copy];
}
@end
