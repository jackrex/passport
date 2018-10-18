//
//  KEPHomeView.m
//  Keep
//
//  Created by Wenbo Cao on 13/04/2018.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "KEPHomeView.h"
#import "KEPHomeHeaderView.h"

@interface KEPHomeView ()


@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) KEPHomeHeaderView *homeHeaderView;
@property(nonatomic, strong) UIView *topWhiteView;

@end

@implementation KEPHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self _kep_setupSubviews];
    [self _kep_setupKVO];
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
   
    return [super hitTest:point withEvent:event];
}

- (void)_kep_setupSubviews {
    [self.tableView addSubview:self.topWhiteView];
    self.backgroundColor = [KColorManager tableViewBackgroundColor];
    [self addSubview:self.tableView];
    [self.tableView addSubview:self.homeHeaderView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)_kep_setupKVO {
    @weakify(self);
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        CGFloat contentOffsetY = self.tableView.contentOffset.y;
        if (contentOffsetY <= 0) {
            self.homeHeaderView.top = 0;
            [self.homeHeaderView updateFrameWithProgress:0];
        } else if (contentOffsetY > 0 && contentOffsetY < [KEPHomeHeaderView viewHeight] - [KEPHomeHeaderView foldViewHeight]) {
            self.homeHeaderView.top = contentOffsetY;
            CGFloat progress = contentOffsetY / ([KEPHomeHeaderView viewHeight] - [KEPHomeHeaderView foldViewHeight]);
            [self.homeHeaderView updateFrameWithProgress:progress];
        } else {
            self.homeHeaderView.top = contentOffsetY;
            [self.homeHeaderView updateFrameWithProgress:1];
        }
       
    }];
}



#pragma mark - Properties


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.alwaysBounceVertical = YES;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 19, 0);
        _tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, [KEPHomeHeaderView viewHeight])];
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        _tableView.tableFooterView = nil;
    }
    return _tableView;
}

- (KEPHomeHeaderView *)homeHeaderView {
    if (!_homeHeaderView) {
        _homeHeaderView = [[KEPHomeHeaderView alloc] init];
    }
    return _homeHeaderView;
}



- (UIView *)topWhiteView {
    if (!_topWhiteView) {
        _topWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREENHEIGHT, SCREENHEIGHT, SCREENHEIGHT)];
        _topWhiteView.backgroundColor = [UIColor whiteColor];
    }
    return _topWhiteView;
}


@end
