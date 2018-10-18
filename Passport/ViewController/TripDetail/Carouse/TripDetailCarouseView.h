//
//  TripDetailCarouseView.h
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <iCarousel/iCarousel.h>
#import "TripDetailCarouseViewModel.h"
#import "TripDetailTableView.h"


NS_ASSUME_NONNULL_BEGIN

@interface TripDetailCarouseView : iCarousel

@property(nonatomic, strong, readonly) TripDetailCarouseViewModel *viewModel;
@property (nonatomic, assign) CGPoint offset;

- (instancetype)initWithCarouselViewModel:(TripDetailCarouseViewModel *)viewModel NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;


- (TripDetailTableView *)currentTableView;

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

- (void)reloadCurrentTableView;


@end

NS_ASSUME_NONNULL_END
