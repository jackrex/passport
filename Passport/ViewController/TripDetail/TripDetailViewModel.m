//
//  TripDetailViewModel.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import "TripDetailViewModel.h"

static CGFloat const TableViewTopMargin = 188;
static CGFloat const TableViewMinBottomHeight = 147;

@implementation TripDetailViewModel

- (CGFloat)tableViewTopMargin {
    return TableViewTopMargin;
}

- (CGFloat)tableViewMaxOriginY {
    return CGRectGetHeight([[UIScreen mainScreen] bounds]) - TableViewMinBottomHeight;
}

- (CGFloat)tableViewMinBottomHeight {
    return TableViewMinBottomHeight;
}


@end
