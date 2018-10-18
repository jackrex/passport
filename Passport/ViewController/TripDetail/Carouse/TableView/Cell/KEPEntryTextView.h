//
//  KEPEntryTextView.h
//  Keep
//
//  Created by jianjun on 2018-04-01.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TripDetailModel;

@interface KEPEntryTextView : UIView

- (void)updateData:(TripDetailModel *)model;
- (void)setTextNumberOfLines:(NSInteger)lines;

@end
