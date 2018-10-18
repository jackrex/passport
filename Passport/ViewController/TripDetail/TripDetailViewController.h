//
//  TripDetailViewController.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <KEPIntlCommonUI/BaseUIViewController.h>
@class TripDetailViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface TripDetailViewController : BaseUIViewController

- (instancetype)initWithViewModel:(TripDetailViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
