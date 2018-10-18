//
//  TripDetailHeader.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#ifndef TripDetailHeader_h
#define TripDetailHeader_h

#import "UIView+KEP_OutdoorActivity.h"

static NSInteger const TripDetailDefaultLevel = 13;
static NSInteger const TripDetailDefaultMinLevel = 3;

static NSString * const kDetaultStyle = @"mapbox://styles/keepintl/cjl4lpr8uasrw2sqnayhda480";
static NSString * const kHeatMapStyle = @"mapbox://styles/keepintl/cjnejt5c92kbo2rlfkt2lwjw3";

static CGFloat const kDefautMargin = 14;

typedef NS_ENUM(NSInteger, KEPAthleticFieldSceneType) {
    KEPAthleticFieldSceneTypeGlance = 0,
    KEPAthleticFieldSceneTypeRespective,
    KEPAthleticFieldSceneTypeSpecific
};

typedef NS_ENUM(NSInteger, KEPAthleticFieldFromType) {
    KEPAthleticFieldFromTypeTrip = 0,
    KEPAthleticFieldFromTypeGroup
};


#endif /* TripDetailHeader_h */
