//
//  KEPEntryMetaAndCardView.h
//  Keep
//
//  Created by Wenbo Cao on 2018/7/19.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import UIKit;
@class TripDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface KEPEntryMetaAndCardView : UIView

+ (CGFloat)viewHeight;
+ (BOOL)shouldDisplayForData:(TripDetailModel *)model;

- (void)updateData:(TripDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
