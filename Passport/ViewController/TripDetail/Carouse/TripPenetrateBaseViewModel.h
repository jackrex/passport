//
//  TripPenetrateBaseViewModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

@import UIKit;
#import "TripDetailHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripPenetrateBaseViewModel : NSObject


@property (nonatomic, assign) CGRect frame;

@property (nonatomic, assign) CGFloat tableViewTopMargin;
@property (nonatomic, assign) CGFloat tableViewMaxOriginY;
@property(nonatomic, assign) KEPAthleticFieldFromType fromType;
@property (nonatomic, assign) KEPAthleticFieldSceneType sceneType;

@property (nonatomic, copy, nullable) void (^scrollViewDidScrollBlock)(UIScrollView *scrollView);

@property (nonatomic, copy, nullable) void (^scrollToTopBlock)(void);
@property (nonatomic, copy, nullable) void (^scrollViewDidEndDraggingBlock)(UIScrollView *scrollView, BOOL directionUp);
@property (nonatomic, copy, nullable) void (^scrollViewDidEndDeceleratingBlock)(UIScrollView *scrollView);
@property (nonatomic, copy, nullable) void (^didClickFeedbackBlock)(NSString *routeIdentifier);

@end

NS_ASSUME_NONNULL_END
