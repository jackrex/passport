//
//  TripDetailTableViewModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "TripPenetrateBaseViewModel.h"
#import "TripDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailTableViewModel : TripPenetrateBaseViewModel

@property(nonatomic, strong) TripDetailModel *tripModel;

@end

NS_ASSUME_NONNULL_END
