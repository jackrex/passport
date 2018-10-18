//
//  TripDetailTableView.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <KEPIntlCommon/KEPCommon.h>

#import "TripDetailTableView.h"
#import "TripDetailModel.h"
#import "TripDetailTableViewDataSource.h"

@interface TripDetailTableView ()

@property(nonatomic, strong) TripDetailTableViewModel *viewModel;

@property(nonatomic, strong) TripDetailTableViewDataSource *tripDataSource;

@end

@implementation TripDetailTableView

- (instancetype)initWithViewModel:(TripDetailTableViewModel *)viewModel {
    self = [super initWithFrame:viewModel.frame style:UITableViewStyleGrouped];
    if (!self) {
        return nil;
    }
    self.viewModel = viewModel;
    self.delegate = self.tripDataSource;
    self.dataSource = self.tripDataSource;
    [self _kep_configure];
    [self _kep_setupKVO];
    return self;
}

#pragma mark - Override

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.y < 0) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}


- (void)adjustTableViewContent {
    TripDetailTableViewBaseDataSource *dataSource = (TripDetailTableViewBaseDataSource *)self.dataSource;
    [dataSource adjustTableViewContent];
}


- (TripDetailTableViewDataSource *)tripDataSource {
    if (!_tripDataSource) {
        _tripDataSource = [[TripDetailTableViewDataSource alloc] init];
        @weakify(self);
        _tripDataSource.scrollViewDidScrollBlock = ^(UIScrollView *scrollView) {
            @strongify(self);
            self.viewModel.scrollViewDidScrollBlock(scrollView);
        };
        _tripDataSource.scrollViewDidEndDraggingBlock = ^(UIScrollView *scrollView, BOOL directionUp) {
            @strongify(self);
            self.viewModel.scrollViewDidEndDraggingBlock(scrollView, directionUp);
        };
        _tripDataSource.scrollViewDidEndDeceleratingBlock = ^(UIScrollView *_Nonnull scrollView) {
            @strongify(self);
            self.viewModel.scrollViewDidEndDeceleratingBlock(scrollView);
        };
        _tripDataSource.scrollToTopBlock = ^{
            @strongify(self);
            if (self.viewModel.sceneType != KEPAthleticFieldSceneTypeRespective) {
                return;
            }
            self.viewModel.scrollToTopBlock();
        };
    }
    return _tripDataSource;
}


#pragma mark - Privete Methods

- (void)_kep_setupKVO {
    @weakify(self);
    [[RACObserve(self.viewModel, tripModel) skip:1] subscribeNext:^(TripDetailModel * _Nullable newROI) {
        @strongify(self);
//        KEPAthleticFieldROI *poi = (KEPAthleticFieldROI *)newROI;
        self.tripDataSource.sceneType = self.viewModel.sceneType;
        self.tripDataSource.tripModel = self.viewModel.tripModel;
        [self reloadData];
    }];
    [[RACObserve(self.viewModel, sceneType) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        TripDetailTableViewBaseDataSource *dataSource = (TripDetailTableViewBaseDataSource *)self.dataSource;
        dataSource.sceneType = self.viewModel.sceneType;
    }];
}


- (void)_kep_configure {
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self kep_registerCells:[TripDetailHeaderCell class], nil];
//    [self kep_registerCells:[KEPOutdoorActivityRouteTextTableCell class], [KEPOutdoorActivityRouteGalleryTableCell class],
//     [KEPOutdoorActivityRouteLandlordTableCell class], [TrainingDetailAvatarTableViewCell class], [KEPOutdoorActivityRouteAuthorTableCell class], [KEPOutdoorActivityTextTableCell class], [KEPOutdoorActivityRouteBillboardTableCell class], [UITableViewCell class], [KEPOutdoorActivitySeparatorTextTableCell class], [KEPRTRoutePopularizationTableCell class],[KEPRTActivityTypeOccupationRatioCell class],[KEPRTRouteDetailAltitudeCell class], nil];
//    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
//    [self registerClass:[KEPOutdoorActivityRouteBillboardHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([KEPOutdoorActivityRouteBillboardHeaderFooterView class])];
//    [self registerClass:[KEPOutdoorActivityRouteEntryHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([KEPOutdoorActivityRouteEntryHeaderView class])];
    self.showsVerticalScrollIndicator = NO;
    self.scrollsToTop = NO;
    self.bounces = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.clipsToBounds = NO;
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;

}



@end
