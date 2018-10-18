//
//  KEPEntryPhotoAndVideoView.h
//  Keep
//
//  Created by caowenbo on 2018-07-18.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import UIKit;

#import "TripDetailModel.h"

@interface KEPEntryPhotoAndVideoView : UIView

@property (nonatomic, copy) void (^didTouchVideoHandler)();

- (void)updateData:(TripDetailModel *)model;
+ (BOOL)shouldDisplayForData:(TripDetailModel *)model;

@end
