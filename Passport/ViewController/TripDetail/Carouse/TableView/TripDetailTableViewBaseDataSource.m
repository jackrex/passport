//
//  TripDetailTableViewBaseDataSource.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "TripDetailTableViewBaseDataSource.h"

@implementation TripDetailTableViewBaseDataSource

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    @weakify(self);
    [[RACObserve(self, sceneType) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.sceneType == KEPAthleticFieldSceneTypeSpecific) {
            [self adjustTableViewContent];
        } else {
            [self addRoundCorner];
        }
    }];
    return self;
}


- (void)addRoundCorner {
    
}

- (void)adjustTableViewContent {
    
}


#pragma mark - UITableView DataSource && Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:nil];
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(scrollView);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.scrollViewDidEndDraggingBlock) {
        return;
    }
    CGFloat originY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
    NSLog(@"__scroll=%s", __FUNCTION__);
    
    
    if (originY < 0) {
        self.scrollViewDidEndDraggingBlock(scrollView, YES);
    } else if (originY > 0) {
        self.scrollViewDidEndDraggingBlock(scrollView, NO);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollViewDidEndDeceleratingBlock) {
        self.scrollViewDidEndDeceleratingBlock(scrollView);
    }
}



@end
