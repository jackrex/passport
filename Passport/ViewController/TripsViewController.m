//
//  TripsViewController.m
//  Passport
//
//  Created by xiongshuangquan on 2018/10/18.
//  Copyright © 2018年 Passport. All rights reserved.
//

#import "TripsViewController.h"
#import "KEPHomeView.h"
#import "KEPHomeHeaderView.h"
#import "TripsRequester.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <KEPIntlNetwork/KEPNetwork.h>
#import "TripsModel.h"
#import "Passport-Swift.h"

@interface TripsViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) KEPHomeView *homeView;
@property(nonatomic, strong) TripsModel *trips;

@end

@implementation TripsViewController

- (void)loadView {
    self.view = self.homeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.homeView.tableView registerClass:[TripsClipCell class] forCellReuseIdentifier:NSStringFromClass([TripsClipCell class])];
    [self fetchTripsInfo];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.homeView.tableView kepclock_isRefreshing]) {
        [self.homeView.tableView kepclock_endRefreshing];
    }
}

- (BOOL)hideNavigationBar {
    return YES;
}

- (void)fetchTripsInfo {
    [TripsRequester fetchTripsInfoWithCallback:^(BOOL success, NSDictionary * _Nonnull dic) {
        self.trips = [dic objectForKey:kResultData];
        [self _kep_reloadTableView];
    }];
}

#pragma mark - property

- (KEPHomeView *)homeView {
    if (!_homeView) {
        _homeView = [[KEPHomeView alloc] init];
        _homeView.tableView.delegate = self;
        _homeView.tableView.dataSource = self;
//        @weakify(self);
//        [_homeView.tableView kepclock_addRefreshControlWithActionBlock:^{
//            @strongify(self);
//
//        } whiteMode:NO];
    }
    return _homeView;
}

#pragma mark - Private Methods

- (void)_kep_reloadTableView {
    [self.homeView.tableView reloadData];
    [self.homeView.tableView setNeedsLayout];
    [self.homeView.tableView layoutIfNeeded];
    CGFloat height = self.homeView.tableView.frame.size.height - self.homeView.tableView.contentSize.height + ([KEPHomeHeaderView viewHeight] - [KEPHomeHeaderView foldViewHeight]) - self.homeView.tableView.contentInset.bottom;
    if (height == 0 || (height < 0 && self.homeView.tableView.tableFooterView.height == 0)) {
        return;
    }
    self.homeView.tableView.tableFooterView = nil;
    [self.homeView.tableView setNeedsLayout];
    [self.homeView.tableView layoutIfNeeded];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MAX(0, self.homeView.tableView.frame.size.height - self.homeView.tableView.contentSize.height + ([KEPHomeHeaderView viewHeight] - [KEPHomeHeaderView foldViewHeight]) - self.homeView.tableView.contentInset.bottom))];
    self.homeView.tableView.tableFooterView = view;
    [self.homeView.homeHeaderView updateUIWithModel:self.trips];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 139;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.clips.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripsClipCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TripsClipCell class]) forIndexPath:indexPath];
    TripsClipModel *clip = [self.trips.clips objectAtIndex:indexPath.row];
    [cell updateUIWithTripsClip:clip];
    return cell;
}

@end
