//
//  TripDetailCarouseView.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

#import "TripDetailCarouseView.h"

static CGFloat const CardMargin = 10;
static CGFloat const CardScreenMargin = 24;

@interface TripDetailCarouseView () <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) TripDetailCarouseViewModel *viewModel;
@property (nonatomic, strong) RACSignal *offsetSingnal;

@end

@implementation TripDetailCarouseView

- (instancetype)initWithCarouselViewModel:(TripDetailCarouseViewModel *)viewModel {
    self = [super initWithFrame:viewModel.frame];
    if (!self) {
        return nil;
    }
    self.viewModel = viewModel;
    self.dataSource = self;
    self.delegate = self;
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    [self _kep_setupKVO];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE {
    NSAssert(NO, @"please use initWithCarouselViewModel");
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE {
    NSAssert(NO, @"please use initWithCarouselViewModel");
    return nil;
}

#pragma mark - Override
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint cPoint = [self convertPoint:point toView:self.currentItemView];
    if (self.decelerating) {
        return nil;
    }
    if ([self.currentItemView hitTest:cPoint withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}

#pragma mark - Public Metghods
- (TripDetailTableView *)currentTableView {
    return (TripDetailTableView *)self.currentItemView;
}


- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    if (page >= 0 && page < self.viewModel.tripModels.count) {
        [self scrollToItemAtIndex:page animated:animated];
    }
}

- (void)reloadCurrentTableView {
    NSInteger currentItemIndex = self.currentItemIndex;
    if (currentItemIndex >= 0 && currentItemIndex < self.viewModel.tripModels.count) {
        [self currentTableView].viewModel.tripModel = self.viewModel.tripModels[currentItemIndex];
    }
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel {
    return self.viewModel.tripModels.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    //create new view if no view is available for recycling
    TripDetailTableView *tableView = (TripDetailTableView *)view;
    if (tableView == nil) {
        tableView = [self _kep_createTableView];
    }
    tableView.viewModel.tableViewTopMargin = self.viewModel.tableViewTopMargin;
    tableView.viewModel.tripModel = self.viewModel.tripModels[index];
    return tableView;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
            case iCarouselOptionWrap:
            return self.viewModel.wrap;
            case iCarouselOptionSpacing:
            return value * (1 + (CardMargin / (self.viewModel.frame.size.width - 2 * CardScreenMargin)));
        default:
            return value;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.superview) {
        return;
    }
    if (scrollView.contentOffset.y > -self.viewModel.tableViewMaxOriginY) {
        self.scrollEnabled = NO;
        CGFloat originY = scrollView.frame.origin.y;
        CGFloat height = CGRectGetHeight(self.frame);
        CGFloat originX = MAX(CardScreenMargin - self.viewModel.tableViewMaxOriginY - scrollView.contentOffset.y, 0);
        scrollView.superview.frame = CGRectMake(originX, originY, CGRectGetWidth(self.bounds) - 2 * originX, height);
        scrollView.frame = scrollView.superview.bounds;
        if (self.currentItemIndex < self.viewModel.tripModels.count - 1 || self.viewModel.wrap) {
            UIView *nextView = nil;
            if (self.currentItemIndex < self.viewModel.tripModels.count - 1) {
                nextView = [self itemViewAtIndex:self.currentItemIndex + 1];
            } else if (self.viewModel.wrap) {
                nextView = [self itemViewAtIndex:0];
            }
            CGFloat height = CGRectGetHeight(self.frame);
            nextView.frame = CGRectMake(CardScreenMargin - originX, 0, nextView.frame.size.width, height);
        }
        if (self.currentItemIndex - 1 >= 0 || self.viewModel.wrap) {
            UIView *beforeView = nil;
            if (self.currentItemIndex - 1 >= 0) {
                beforeView = [self itemViewAtIndex:self.currentItemIndex - 1];
            } else if (self.viewModel.wrap) {
                beforeView = [self itemViewAtIndex:self.viewModel.tripModels.count - 1];
            }
            CGFloat height = CGRectGetHeight(self.frame);
            CGFloat originY = scrollView.frame.origin.y;
            beforeView.superview.frame = CGRectMake(originX, originY, beforeView.frame.size.width - (CardScreenMargin - originX), height);
        }
        
    } else {
        self.scrollEnabled = YES;
        CGFloat originY = scrollView.frame.origin.y;
        CGFloat height = CGRectGetHeight(self.frame);
        CGFloat originX = CardScreenMargin;
        scrollView.superview.frame = CGRectMake(originX, originY, CGRectGetWidth(self.frame) - 2 * originX, height);
        scrollView.frame = scrollView.superview.bounds;
        if (self.currentItemIndex < self.viewModel.tripModels.count - 1 || self.viewModel.wrap) {
            UIView *nextView = nil;
            if (self.currentItemIndex < self.viewModel.tripModels.count - 1) {
                nextView = [self itemViewAtIndex:self.currentItemIndex + 1];
            } else if (self.viewModel.wrap) {
                nextView = [self itemViewAtIndex:0];
            }
            CGFloat height = CGRectGetHeight(self.frame);
            nextView.frame = CGRectMake(CardScreenMargin - originX, 0, nextView.frame.size.width, height);
        }
        if (self.currentItemIndex - 1 >= 0 || self.viewModel.wrap) {
            UIView *beforeView = nil;
            if (self.currentItemIndex - 1 >= 0) {
                beforeView = [self itemViewAtIndex:self.currentItemIndex - 1];
            } else if (self.viewModel.wrap) {
                beforeView = [self itemViewAtIndex:self.viewModel.tripModels.count - 1];
            }
            CGFloat height = CGRectGetHeight(self.frame);
            CGFloat originY = scrollView.frame.origin.y;
            CGFloat originX = CardScreenMargin;
            beforeView.superview.frame = CGRectMake(originX, originY, beforeView.frame.size.width - (CardScreenMargin - originX), height);
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {
    [self _kep_setContentOffSetKVO];
    NSInteger currentItemIndex = carousel.currentItemIndex;
    if (currentItemIndex >= 0 && currentItemIndex < self.viewModel.tripModels.count) {
        self.viewModel.currentTripModel = self.viewModel.tripModels[currentItemIndex];
    }
}


#pragma mark - Private Methods

- (void)_kep_setupKVO {
    @weakify(self);
    [[RACObserve(self.viewModel, tripModels) skip:1] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        if (self.viewModel.tripModels.count == 0) {
            self.offsetSingnal = nil;
            [self reloadData];
            [self scrollToItemAtIndex:0 animated:NO];
        } else {
            [self reloadData];
            [self layoutIfNeeded];
            [self _kep_setContentOffSetKVO];
        }
    }];
    [[[RACObserve(self.viewModel, sceneType) skip:1] distinctUntilChanged] subscribeNext:^(id _Nullable x) {
        @strongify(self);
        TripDetailTableView *tableView = self.currentTableView;
        if (KEPAthleticFieldSceneTypeRespective == self.viewModel.sceneType) {
            tableView.clipsToBounds = NO;
            [tableView kep_loadSummaryCardStyle];
        } else if (KEPAthleticFieldSceneTypeSpecific == self.viewModel.sceneType) {
            tableView.clipsToBounds = YES;
            tableView.layer.cornerRadius = 0;
        }
        tableView.viewModel.sceneType = self.viewModel.sceneType;
    }];
}

- (void)_kep_setContentOffSetKVO {
    self.offsetSingnal = RACObserve([self currentTableView], contentOffset);
    @weakify(self);
    [self.offsetSingnal subscribeNext:^(id _Nullable x) {
        @strongify(self);
        if ([self currentTableView]) {
            self.offset = [[self currentTableView] contentOffset];
        }
    }];
}


- (TripDetailTableView *)_kep_createTableView {
    TripDetailTableViewModel *viewModel = [[TripDetailTableViewModel alloc] init];
    viewModel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 2 * CardScreenMargin, CGRectGetHeight(self.bounds));
    viewModel.fromType = self.viewModel.fromType;
    @weakify(self);
    viewModel.scrollViewDidScrollBlock = ^(UIScrollView *_Nonnull scrollView) {
        @strongify(self);
        self.viewModel.scrollViewDidScrollBlock(scrollView);
        [self scrollViewDidScroll:scrollView];
    };
    viewModel.scrollViewDidEndDraggingBlock = ^(UIScrollView *_Nonnull scrollView, BOOL directionUp) {
        @strongify(self);
        self.viewModel.scrollViewDidEndDraggingBlock(scrollView, directionUp);
    };
    viewModel.scrollViewDidEndDeceleratingBlock = ^(UIScrollView *_Nonnull scrollView) {
        @strongify(self);
        self.viewModel.scrollViewDidEndDeceleratingBlock(scrollView);
    };
    viewModel.scrollToTopBlock = ^{
        @strongify(self);
        self.viewModel.scrollToTopBlock();
    };
    viewModel.didClickFeedbackBlock = ^(NSString *_Nonnull routeIdentifier) {
        @strongify(self);
        self.viewModel.didClickFeedbackBlock(routeIdentifier);
    };
    TripDetailTableView *tableView = [[TripDetailTableView alloc] initWithViewModel:viewModel];
    tableView.contentInset = UIEdgeInsetsMake(self.viewModel.tableViewMaxOriginY, 0, 0, 0);
    [tableView kep_loadSummaryCardStyle];
    
    return tableView;
}



@end
