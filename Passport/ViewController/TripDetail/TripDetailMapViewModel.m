//
//  TripDetailMapViewModel.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <Mapbox/Mapbox.h>

#import <ReactiveObjC/ReactiveObjC.h>

#import "TripDetailMapViewModel.h"

@interface TripDetailMapViewModel () <MGLMapViewDelegate>

@property (nonatomic, weak, nullable) MGLMapView *mapView;

@end

@implementation TripDetailMapViewModel

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}



- (void)configureMapView:(nonnull __kindof UIView *)mapView {
    self.mapView = mapView;
    self.mapView.delegate = self;
    self.mapView.attributionButton.hidden = YES;
    self.mapView.compassView.hidden = YES;
    self.mapView.displayHeadingCalibration = NO;
    self.mapView.rotateEnabled = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.pitchEnabled = NO;
    self.mapView.logoView.hidden = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.userTrackingMode = MGLUserTrackingModeFollow;
//    self.mapView.minimumZoomLevel = TripDetailDefaultMinLevel;
    [self _kep_setupDefaultZoomLevel:NO];
}


- (void)_kep_setupDefaultZoomLevel:(BOOL)animation {
//    [self.mapView setZoomLevel:TripDetailDefaultLevel animated:animation];
}

@end
