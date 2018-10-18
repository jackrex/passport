//
//  MKAnnotation+TripDetail.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/19.
//  Copyright © 2018 Passport. All rights reserved.
//

@import MapKit;
#import "TripDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKPointAnnotation (TripDetail)

@property(nonatomic, strong) TripGroupFeature *tripFeature;

@end

NS_ASSUME_NONNULL_END
