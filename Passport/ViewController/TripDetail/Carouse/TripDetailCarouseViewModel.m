//
//  TripDetailCarouseViewModel.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "TripDetailCarouseViewModel.h"
#import "TripDetailModel.h"

@interface TripDetailCarouseViewModel ()

@property(nonatomic, assign) BOOL wrap;

@end

@implementation TripDetailCarouseViewModel

- (void)setTripModels:(NSArray<TripDetailModel *> *)tripModels {
    _tripModels = tripModels;
    self.wrap = tripModels.count > 2;
}
@end
