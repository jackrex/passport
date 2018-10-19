//
//  TripDetailMapViewModel.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

@import MapKit;
@import CoreMotion;

#import <Mapbox/Mapbox.h>

#import <ReactiveObjC/ReactiveObjC.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <Masonry/Masonry.h>

#import "TripDetailMapViewModel.h"
#import "ClusterKit.h"
#import "MGLMapView+ClusterKit.h"
#import "MKAnnotation+TripDetail.h"
#import "TripDetailAnnotation.h"

static NSTimeInterval const FlyCameraDuration = .35;
static CGFloat const Inset = 60;

@interface TripDetailMapViewModel () <MGLMapViewDelegate>

@property (nonatomic, weak, nullable) MGLMapView *mapView;

@property(nonatomic, strong) CMMotionManager *manager;

@property(nonatomic, assign) MGLCoordinateBounds tripBounds;

@property(nonatomic, assign) BOOL loadingFininsh;

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
        [self _kep_setupDefaultZoomLevel:NO];
    } else {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.9087, 116.3975) animated:NO];
        [self.mapView setZoomLevel:3];
        [self _kep_setClusterManager];
    }
    
}

- (void)setTripModels:(NSArray<TripDetailModel *> *)tripModels {
    _tripModels = tripModels;

    NSMutableArray *annotations = [NSMutableArray array];
    [tripModels enumerateObjectsUsingBlock:^(TripDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.points enumerateObjectsUsingBlock:^(TripPointModel * _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
            if (annotations.count == 0) {
                self.tripBounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(point.latitude, point.longitude), CLLocationCoordinate2DMake(point.latitude, point.longitude));
            } else {
                self.tripBounds =  MGLCoordinateIncludingCoordinate(self.tripBounds, CLLocationCoordinate2DMake(point.latitude, point.longitude));
            }
            TripDetailAnnotation *annotation = [[TripDetailAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
            annotation.currentModel = obj;
            [annotations addObject:annotation];
        }];
    }];
    [self.mapView addAnnotations:annotations];
    [self _kep_addShapeSource];
 
}

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    self.loadingFininsh = YES;
    [self _kep_addShapeSource];
}

- (void)_kep_addShapeSource {
    
    if (self.mapView.annotations.count == 0 || self.fromType != KEPAthleticFieldFromTypeTrip || !self.loadingFininsh) {
        return;
    }
    
    KEPMethodLockReturn();
    NSArray *annotations = self.mapView.annotations;
    
    NSInteger count = annotations.count;
    CLLocationCoordinate2D routeCoords[count];
    for (NSInteger i = 0; i < count; i++) {
        MGLPointAnnotation *annotation = annotations[i];
        routeCoords[i] = annotation.coordinate;
    }
    MGLPolylineFeature *polyline = nil;
    @try {
        //这里保护下 mapbox 会有crash
        polyline = [MGLPolylineFeature polylineWithCoordinates:routeCoords count:count];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"aaa"
                                                               features:@[polyline]
                                                                options:nil];
    [self.mapView.style addSource:source];
    source.shape = polyline;
    MGLLineStyleLayer *layer = [self _kep_styleLayerWithIdentifier:@"aaaa"
                                                        isSelected:YES
                                                            source:source];
    [self.mapView.style addLayer:layer];
}

- (MGLLineStyleLayer *)_kep_styleLayerWithIdentifier:(NSString *)identifier
                                          isSelected:(BOOL)isSelected
                                              source:(MGLSource *)source {
    MGLLineStyleLayer *layer = [[MGLLineStyleLayer alloc] initWithIdentifier:identifier source:source];
    layer.lineJoin = [NSExpression expressionForConstantValue:[NSValue valueWithMGLLineJoin:MGLLineJoinRound]];
    layer.lineCap = [NSExpression expressionForConstantValue:[NSValue valueWithMGLLineCap:MGLLineCapRound]];
    layer.lineColor = [NSExpression expressionForConstantValue:[KColorManager buttonGreenTitleColor]];
    layer.lineWidth = [NSExpression expressionForConstantValue:@4];
    layer.lineOpacity = [NSExpression expressionForConstantValue:@1];
    layer.lineDashPattern = [NSExpression expressionForConstantValue:@[@0, @1.5]];
    return layer;
}

- (void)setCurrentModel:(TripDetailModel *)currentModel {
    _currentModel = currentModel;
    if (self.fromType == KEPAthleticFieldFromTypeTrip) {
        [self.mapView.annotations enumerateObjectsUsingBlock:^(TripDetailAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.currentModel.selected = obj.currentModel.dayIndex == currentModel.dayIndex;
        }];
    }
}

- (void)adjustMapForSpecific {
    if (self.fromType == KEPAthleticFieldFromTypeTrip) {
        MGLMapCamera *camera = [self _kep_cameraForType:KEPAthleticFieldSceneTypeSpecific];
        [self.mapView flyToCamera:camera
                     withDuration:FlyCameraDuration
                completionHandler:^{
                }];
    }
    
}

- (void)adjustMapForRespective {
    if (self.fromType == KEPAthleticFieldFromTypeTrip) {
        MGLMapCamera *camera = [self _kep_cameraForType:KEPAthleticFieldSceneTypeRespective];
        [self.mapView flyToCamera:camera
                     withDuration:FlyCameraDuration
                completionHandler:^{
                }];
    }
    
}

- (MGLMapCamera *)_kep_cameraForType:(KEPAthleticFieldSceneType)type {
    MGLMapCamera *camera = nil;

    if (KEPAthleticFieldSceneTypeSpecific == type) {
        camera = [self.mapView cameraThatFitsCoordinateBounds:self.tripBounds
                                                  edgePadding:UIEdgeInsetsMake(Inset, Inset, _specificBottomPoint + Inset / 2, Inset)];
        camera.pitch = 0;
        camera.heading = 0;
        return camera;
        
    }
    else if (KEPAthleticFieldSceneTypeRespective == type) {
        camera = [self.mapView cameraThatFitsCoordinateBounds:self.tripBounds
                                                  edgePadding:UIEdgeInsetsMake(Inset, Inset, _respectiveBottomPoint + Inset / 2, Inset)];
        camera.pitch = 0;
        camera.heading = 0;
        return camera;
    }
    return camera;
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
    if (self.fromType == KEPAthleticFieldFromTypeGroup) {
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
    else if (self.fromType == KEPAthleticFieldFromTypeTrip) {
        TripDetailAnnotation *a = (TripDetailAnnotation *)annotation;
        TripDetailAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXMapViewDefaultClusterAnnotationViewReuseIdentifier];
        if (!view) {
            view = [[TripDetailAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MBXMapViewDefaultClusterAnnotationViewReuseIdentifier];
        }
        view.currentModel = a.currentModel;
        view.label.text = [NSString stringWithFormat:@"%ld", a.currentModel.dayIndex + 1];
        return view;
    }
    
    return nil;
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    return NO;
}

#pragma mark - How To Update Clusters

- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.fromType == KEPAthleticFieldFromTypeGroup) {
        [mapView.clusterManager updateClustersIfNeeded];
    }
}


#pragma mark - How To Handle Selection/Deselection


- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation {
    if (self.fromType == KEPAthleticFieldFromTypeGroup) {
        CKCluster *cluster = (CKCluster *)annotation;
        UIEdgeInsets edgePadding = UIEdgeInsetsMake(2 * Inset + iPhoneXTopOffsetY, Inset, _respectiveBottomPoint + Inset, Inset);
        MGLMapCamera *camera = [mapView cameraThatFitsCluster:cluster edgePadding:edgePadding];
        if (cluster.count > 1) {
            [mapView setCamera:camera animated:YES];
        } else {
            MKPointAnnotation *pointAnnotation = (MKPointAnnotation *)cluster.firstAnnotation;
            !self.didClickTripAction ?: self.didClickTripAction(pointAnnotation.tripFeature);
            [mapView flyToCamera:camera withDuration:.35 completionHandler:^{
                
            }];
        }
    }
    else if (self.fromType == KEPAthleticFieldFromTypeTrip) {
        TripDetailAnnotation *a = (TripDetailAnnotation *)annotation;
        !self.didClickTripAction ?: self.didClickTripAction(a.currentModel);
    }
    [mapView deselectAnnotation:annotation animated:NO];
}

- (void)mapView:(MGLMapView *)mapView didDeselectAnnotation:(id<MGLAnnotation>)annotation {
    if (self.fromType == KEPAthleticFieldFromTypeGroup) {
        CKCluster *cluster = (CKCluster *)annotation;
        [mapView.clusterManager deselectAnnotation:cluster.firstAnnotation animated:NO];
    }
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
        self.centerOffset = CGVectorMake(0, -CGRectGetHeight(self.frame)/2);
        
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
        
        self.centerOffset = CGVectorMake(0, -CGRectGetHeight(self.frame)/2);
        
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

