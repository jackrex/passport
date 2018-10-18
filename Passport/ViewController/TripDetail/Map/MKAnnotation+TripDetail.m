//
//  MKAnnotation+TripDetail.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/19.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <objc/runtime.h>

#import "MKAnnotation+TripDetail.h"


@implementation MKPointAnnotation (TripDetail)

static char kAssociatedObjectKey_tripFeature;

- (void)setTripFeature:(TripGroupFeature *)tripFeature {
      objc_setAssociatedObject(self, &kAssociatedObjectKey_tripFeature, tripFeature, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TripGroupFeature *)tripFeature {
    return (TripGroupFeature *)objc_getAssociatedObject(self, &kAssociatedObjectKey_tripFeature);
}


@end
