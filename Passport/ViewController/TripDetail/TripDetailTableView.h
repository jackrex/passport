//
//  TripDetailTableView.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripDetailTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailTableView : UITableView

@property (nonatomic, strong, readonly) TripDetailTableViewModel *viewModel;

- (instancetype)initWithViewModel:(TripDetailTableViewModel *)viewModel;

- (void)adjustTableViewContent;

@end

NS_ASSUME_NONNULL_END
