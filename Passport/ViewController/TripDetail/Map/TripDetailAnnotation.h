//
//  TripDetailAnnotation.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/19.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import "TripDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailAnnotation : MGLPointAnnotation

@property(nonatomic, strong) TripDetailModel *currentModel;

@end

@interface TripDetailAnnotationView : MGLAnnotationView

@property(nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) TripDetailModel *currentModel;

@end

NS_ASSUME_NONNULL_END
