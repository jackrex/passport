//
//  KEPHomeView.h
//  Keep
//
//  Created by Wenbo Cao on 13/04/2018.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

@import UIKit;

@class KEPHomeHeaderView;

@interface KEPHomeView : UIView

@property(nonatomic, strong, readonly) KEPHomeHeaderView *homeHeaderView;
@property(nonatomic, strong, readonly) UITableView *tableView;

@end
