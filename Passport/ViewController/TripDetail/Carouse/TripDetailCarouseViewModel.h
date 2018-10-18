//
//  TripDetailCarouseViewModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "TripPenetrateBaseViewModel.h"
#import "TripDetailModel.h"
#import "TripDetailHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailCarouseViewModel : TripPenetrateBaseViewModel

@property (nonatomic, strong, nullable) NSArray <TripDetailModel *> *tripModels;
@property (nonatomic, strong, nullable) TripDetailModel *currentTripModel;
@property (nonatomic, assign, readonly) BOOL wrap;


@end

NS_ASSUME_NONNULL_END
