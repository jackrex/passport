//
//  TripDetailTableViewDataSource.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "TripDetailTableViewBaseDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailTableViewDataSource : TripDetailTableViewBaseDataSource

@property(nonatomic, strong) TripDetailModel *tripModel;

@end

NS_ASSUME_NONNULL_END
