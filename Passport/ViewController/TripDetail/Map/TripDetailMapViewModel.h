//
//  TripDetailMapViewModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

@import UIKit;
#import <Mapbox/Mapbox.h>
#import "TripDetailHeader.h"
#import "TripDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailMapViewModel : NSObject

@property (nonatomic, assign) KEPAthleticFieldSceneType sceneType;
@property(nonatomic, assign) KEPAthleticFieldFromType fromType;

@property (nonatomic, strong, nullable) NSArray <TripDetailModel *> *tripModels;

@property(nonatomic, strong) TripDetailModel *currentModel;

@property(nonatomic, copy) void (^didClickTripAction)(TripDetailModel *model);

@property (nonatomic, assign) CGFloat specificBottomPoint;
@property (nonatomic, assign) CGFloat respectiveBottomPoint;

- (void)adjustMapForSpecific;
- (void)adjustMapForRespective;

- (void)configureMapView:(nonnull __kindof UIView *)mapView;

- (void)_kep_setupDefaultZoomLevel:(BOOL)animation;

@end


@interface MBXAnnotationView : MGLAnnotationView

@property (nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *backgroundImageView;

@end

@interface MBXClusterView : MGLAnnotationView

@property(nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
