//
//  TripDetailMapViewModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

@import UIKit;
#import "TripDetailHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailMapViewModel : NSObject

@property (nonatomic, assign) KEPAthleticFieldSceneType sceneType;
@property(nonatomic, assign) KEPAthleticFieldFromType fromType;

- (void)configureMapView:(nonnull __kindof UIView *)mapView;

@end

NS_ASSUME_NONNULL_END
