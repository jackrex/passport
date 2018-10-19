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
#import "TripDetailViewController.h"
#import "TripDetailViewModel.h"
#import "ForchTouchManager.h"

@interface TripsViewController () <UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

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
//    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.homeView.tableView registerClass:[TripsClipCell class] forCellReuseIdentifier:NSStringFromClass([TripsClipCell class])];
    [self fetchTripsInfo];
    [ForchTouchManager add3DTouch:self view:self.homeView.tableView];
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
        if (success) {
            self.trips = [dic objectForKey:kResultData];
            [self _kep_reloadTableView];
        } else {
            
        }
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
    [self.homeView.homeHeaderView updateUIWithModel:self.trips];
    CGFloat height = self.homeView.tableView.frame.size.height - self.homeView.tableView.contentSize.height + ([KEPHomeHeaderView viewHeight] - [KEPHomeHeaderView foldViewHeight]) - self.homeView.tableView.contentInset.bottom;
    if (height == 0 || (height < 0 && self.homeView.tableView.tableFooterView.height == 0)) {
        return;
    }
    self.homeView.tableView.tableFooterView = nil;
    [self.homeView.tableView setNeedsLayout];
    [self.homeView.tableView layoutIfNeeded];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MAX(0, self.homeView.tableView.frame.size.height - self.homeView.tableView.contentSize.height + ([KEPHomeHeaderView viewHeight] - [KEPHomeHeaderView foldViewHeight]) - self.homeView.tableView.contentInset.bottom))];
    self.homeView.tableView.tableFooterView = view;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 139;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trips.trips.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripsClipCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TripsClipCell class]) forIndexPath:indexPath];
    TripsClipModel *clip = [self.trips.trips objectAtIndex:indexPath.row];
    [cell updateUIWithTripsClip:clip];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self gotoTripDetail:indexPath];
}

- (void)gotoTripDetail:(NSIndexPath *)indexPath {
    TripsClipModel *trip = [self.trips.trips objectAtIndex:indexPath.row];
    TripDetailViewModel *vm = [[TripDetailViewModel alloc] init];
    vm.fromType = KEPAthleticFieldFromTypeTrip;
    vm.requetId = trip._id;
    TripDetailViewController *vc = [[TripDetailViewController alloc] initWithViewModel:vm];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UIViewControllerPreviewingDelegate

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    // previewingContext.sourceView: 触发Peek & Pop操作的视图
    // previewingContext.sourceRect: 设置触发操作的视图的不被虚化的区域
    
    NSIndexPath * indexPath =[self.homeView.tableView indexPathForRowAtPoint:location];
    
    UITableViewCell * cell = [self.homeView.tableView cellForRowAtIndexPath:indexPath];
    //以上得到你点击的哪一行的cell
    if (!cell) {
        return nil;
    }

    TripsClipModel *trip = [self.trips.trips objectAtIndex:indexPath.row];
    TripDetailViewModel *vm = [[TripDetailViewModel alloc] init];
    vm.fromType = KEPAthleticFieldFromTypeTrip;
    vm.requetId = trip._id;
    TripDetailViewController *vc = [[TripDetailViewController alloc] initWithViewModel:vm];
    vc.hidesBottomBarWhenPushed = YES;
    // 预览区域大小(可不设置)
    vc.preferredContentSize = CGSizeMake(0, 300);
    return vc;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
}

@end
