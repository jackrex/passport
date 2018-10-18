//
//  TripDetailViewModel.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripDetailMapViewModel.h"
#import "TripDetailModel.h"
#import "TripDetailHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailViewModel : NSObject

@property(nonatomic, assign) KEPAthleticFieldSceneType sceneType;
@property(nonatomic, assign) KEPAthleticFieldFromType fromType;
@property(nonatomic, copy) NSString *requetId;

@property (nonatomic, strong, nullable) NSArray <TripDetailModel *> *tripModels;

@property (nonatomic, assign) BOOL scrollingDetailPage;
@property (nonatomic, assign) BOOL willOutOfBounds;

- (CGFloat)tableViewTopMargin;
- (CGFloat)tableViewMaxOriginY;
- (CGFloat)tableViewMinBottomHeight;

@end

NS_ASSUME_NONNULL_END
