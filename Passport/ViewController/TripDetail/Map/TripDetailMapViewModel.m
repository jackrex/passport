//
//  TripDetailMapViewModel.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

@import MapKit;
#import <Mapbox/Mapbox.h>

#import <ReactiveObjC/ReactiveObjC.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <Masonry/Masonry.h>

#import "TripDetailMapViewModel.h"
#import "TripDetailModel.h"
#import "ClusterKit.h"
#import "MGLMapView+ClusterKit.h"
#import "MKAnnotation+TripDetail.h"

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
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.pitchEnabled = NO;
    self.mapView.logoView.hidden = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.showsUserLocation = NO;
    [self.mapView setUserTrackingMode:MGLUserTrackingModeNone];
    if (self.fromType == KEPAthleticFieldFromTypeTrip) {
        self.mapView.minimumZoomLevel = 8;
        [self _kep_setupDefaultZoomLevel:NO];
    } else {
        self.mapView.minimumZoomLevel = TripDetailDefaultMinLevel;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.9087, 116.3975) animated:YES];
        [self _kep_setClusterManager];
    }

}

- (void)_kep_setClusterManager {
    CKNonHierarchicalDistanceBasedAlgorithm *algorithm = [[CKNonHierarchicalDistanceBasedAlgorithm alloc] init];;
    algorithm.cellSize = 200;
    
    self.mapView.clusterManager.algorithm = algorithm;
    self.mapView.clusterManager.marginFactor = 1;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *features = [TripGroupFeature defaultFeatures];
        NSArray *annoatations = [[[features rac_sequence] map:^id _Nullable(TripGroupFeature * _Nullable value) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(value.geometry.latitude, value.geometry.longitude);
            annotation.tripFeature = value;
            return annotation;
        }] array];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mapView.clusterManager.annotations = annoatations;
        });
    });
}


- (void)_kep_setupDefaultZoomLevel:(BOOL)animation {
    [self.mapView setZoomLevel:TripDetailDefaultLevel animated:animation];
}


#pragma mark <MGLMapViewDelegate>

- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
 
}


NSString * const MBXMapViewDefaultAnnotationViewReuseIdentifier = @"annotation";
NSString * const MBXMapViewDefaultClusterAnnotationViewReuseIdentifier = @"cluster";


- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation {
    CKCluster *cluster = (CKCluster *)annotation;
    
    if (cluster.count > 1) {
        MBXClusterView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXMapViewDefaultClusterAnnotationViewReuseIdentifier];
        if (!view) {
            view = [[MBXClusterView alloc] initWithAnnotation:cluster reuseIdentifier:MBXMapViewDefaultClusterAnnotationViewReuseIdentifier];
        }
        view.label.text = [NSString stringWithFormat:@"%ld", cluster.count];
        return view;
    }
    
    
    MKPointAnnotation *pointAnnotation = (MKPointAnnotation *)cluster.firstAnnotation;
    MBXAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXMapViewDefaultAnnotationViewReuseIdentifier];
    if (!view) {
        view = [[MBXAnnotationView alloc] initWithAnnotation:cluster reuseIdentifier:MBXMapViewDefaultAnnotationViewReuseIdentifier];
    }
    [view.imageView sd_setImageWithURL:[NSURL URLWithString:pointAnnotation.tripFeature.properties.avatar]
                      placeholderImage:[UIImage imageNamed:@"defaul_mount"]];
    
    return view;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return NO;
}

#pragma mark - How To Update Clusters

- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [mapView.clusterManager updateClustersIfNeeded];
}


#pragma mark - How To Handle Selection/Deselection
- (void)mapView:(MGLMapView *)mapView didSelectAnnotationView:(MGLAnnotationView *)annotationView {
    
}

- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation {
    CKCluster *cluster = (CKCluster *)annotation;
    if (cluster.count == 1) {
       
    }
}

- (void)mapView:(MGLMapView *)mapView didDeselectAnnotation:(id<MGLAnnotation>)annotation {
    CKCluster *cluster = (CKCluster *)annotation;
    [mapView.clusterManager deselectAnnotation:cluster.firstAnnotation animated:NO];
}




@end

@implementation MBXAnnotationView

- (instancetype)initWithAnnotation:(id<MGLAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"tripDefault"];
        self.backgroundImageView = [[UIImageView alloc] initWithImage:image];
        self.frame = CGRectMake(0, 0, 44, 50);
        self.backgroundImageView.frame = self.frame;
        [self addSubview:self.backgroundImageView];
        self.centerOffset = CGVectorMake(0.5, 1);
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        self.imageView.frame = CGRectMake(0, 0, 40, 40);
        self.imageView.layer.cornerRadius = 20;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.center = CGPointMake(22, 22);
    }
    return self;
}



@end

@implementation MBXClusterView

- (instancetype)initWithAnnotation:(id<MGLAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *image = [UIImage imageNamed:@"green_point"];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.frame = CGRectMake(0, 0, 44, 44);
        self.frame = self.imageView.frame;
        [self addSubview:self.imageView];
        self.frame = self.imageView.frame;
        
        self.centerOffset = CGVectorMake(0.5, 1);
        
        self.label = [UILabel kep_createLabel];
        self.label.font = [UIFont kep_systemBoldSize:13];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        self.label.preferredMaxLayoutWidth = 40;
        self.label.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

@end

