//
//  TripDetailTableViewBaseDataSource.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

@import UIKit;
#import "TripDetailHeader.h"
#import "TripDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailTableViewBaseDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) KEPAthleticFieldSceneType sceneType;

@property (nonatomic, copy, nullable) void (^scrollToTopBlock)(void);
@property (nonatomic, copy, nullable) void (^scrollViewDidEndDraggingBlock)(UIScrollView *scrollView, BOOL directionUp);
@property (nonatomic, copy, nullable) void (^scrollViewDidEndDeceleratingBlock)(UIScrollView *scrollView);
@property (nonatomic, copy, nullable) void (^scrollViewDidScrollBlock)(UIScrollView *scrollView);

- (void)adjustTableViewContent;

- (void)addRoundCorner;

@end

NS_ASSUME_NONNULL_END
