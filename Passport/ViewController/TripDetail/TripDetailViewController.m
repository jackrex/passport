//
//  TripDetailViewController.m
//  Passport
//
//  Created by Wenbo Cao on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

#import <KEPIntlCommon/KEPCommon.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <BlocksKit/BlocksKit.h>
#import <Masonry/Masonry.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <KEPIntlCommonUI/KEPIntlCommonUI.h>

#import <KEPSVProgressHUD/SVProgressHUD.h>
#import "KEPRTActivityToggle.h"
#import "TripDetailViewController.h"
#import "TripDetailViewModel.h"
#import "KEPOutdoorActivitySummaryMGLMapView.h"
#import "TripDetailMapViewModel.h"
#import "TripDetailModel.h"
#import "TripDetailCarouseView.h"
#import "TripDetailRequester.h"

static CGSize const ToggleSize = {36, 36};
static CGSize const IconSize = {24, 24};

@interface TripDetailViewController ()

@property(nonatomic, strong) TripDetailViewModel *viewModel;
@property(nonatomic, strong) KEPOutdoorActivitySummaryMGLMapView *mapView;
@property(nonatomic, strong) TripDetailMapViewModel *mapViewModel;
@property(nonatomic, strong) TripDetailCarouseView *carouselView;
@property (nonatomic, strong) UIView *grayMask;

@property (nonatomic, strong) KEPRTActivityToggle *backToggle;
@property (nonatomic, strong) KEPCustomNavBar *navBar;
@end

@implementation TripDetailViewController

- (instancetype)initWithViewModel:(TripDetailViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) {
        return nil;
    }
    _viewModel = viewModel;
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    NSAssert(NO, @"Please use the NS_DESIGNATED_INITIALIZER");
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(NO, @"Please use the NS_DESIGNATED_INITIALIZER");
    return nil;
}

- (instancetype)init {
    NSAssert(NO, @"Please use the NS_DESIGNATED_INITIALIZER");
    return nil;
}

#pragma mark - Life Cycle

- (BOOL)hideNavigationBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _kep_setupSubviews];
    [self _kep_bindViewModelToMap];
    [self _kep_setupKVO];
    [self _kep_fetchTripModels];
    

}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

- (__kindof MGLMapView *)mapView {
    if (!_mapView) {
        _mapView = [[KEPOutdoorActivitySummaryMGLMapView alloc] initWithFrame:self.view.bounds
                                                                     styleURL:[NSURL URLWithString:self.viewModel.fromType == KEPAthleticFieldFromTypeGroup ? kHeatMapStyle : kDetaultStyle]];

        @weakify(self);
        _mapView.mapViewMoveByUser = ^{
            @strongify(self);
            if (KEPAthleticFieldSceneTypeGlance == self.viewModel.sceneType || (self.viewModel.fromType == KEPAthleticFieldFromTypeTrip && self.viewModel.sceneType == KEPAthleticFieldSceneTypeRespective)) {
                return;
            }
            [self _kep_quitAthleticFieldScene];
        };
    }
    return _mapView;
}

- (KEPRTActivityToggle *)backToggle {
    if (!_backToggle) {
        _backToggle = [[KEPRTActivityToggle alloc] initWithSize:ToggleSize
                                           backgroundImageColor:[UIColor whiteColor]
                                                      iconImage:[UIImage imageNamed:@"ic_rt_map_back"]
                                                           text:nil];
        [_backToggle setupOnlyImageWithSize:IconSize borderEnabled:NO];
        @weakify(self);
        _backToggle.didClickToggleBlock = ^{
            @strongify(self);
            [self _kep_quitAthleticFieldScene];
        };
    }
    return _backToggle;
}


- (TripDetailMapViewModel *)mapViewModel {
    if (!_mapViewModel) {
        _mapViewModel = [[TripDetailMapViewModel alloc] init];
        _mapViewModel.fromType = self.viewModel.fromType;
        _mapViewModel.respectiveBottomPoint = CGRectGetHeight(self.view.bounds) - self.viewModel.tableViewMaxOriginY;
        _mapViewModel.specificBottomPoint = CGRectGetHeight(self.view.bounds) - self.viewModel.tableViewTopMargin;
        @weakify(self);
        _mapViewModel.didClickTripAction = ^(TripDetailModel * _Nonnull model) {
            @strongify(self);
            if (self.viewModel.fromType == KEPAthleticFieldFromTypeGroup) {
                NSArray *datas = @[model];
                self.viewModel.tripModels = datas;
                self.carouselView.viewModel.tripModels = datas;
                [self _kep_scrollTableViewVisible];
            } else {
                [self.carouselView scrollToPage:model.dayIndex animated:YES];
            }
        
        };
    }
    return _mapViewModel;
}

- (TripDetailCarouseView *)carouselView {
    if (!_carouselView) {
        TripDetailCarouseViewModel *viewModel = [[TripDetailCarouseViewModel alloc] init];
        viewModel.frame = self.view.bounds;
        viewModel.tableViewMaxOriginY = self.viewModel.tableViewMaxOriginY;
        viewModel.tableViewTopMargin = self.viewModel.tableViewTopMargin;
        viewModel.fromType = self.viewModel.fromType;
        viewModel.sceneType = self.viewModel.sceneType;
        @weakify(self);
        viewModel.scrollViewDidScrollBlock = ^(UIScrollView *scrollView) {
            @strongify(self);
            NSLog(@"__scroll did scroll offset=%@", NSStringFromCGPoint(scrollView.contentOffset));
            self.viewModel.willOutOfBounds = NO;
            if (scrollView.isDecelerating && self.viewModel.scrollingDetailPage) {
                CGFloat originY = [scrollView.panGestureRecognizer translationInView:scrollView.superview].y;
                NSLog(@"__scroll not overflow boundary");
                if (originY < 0 && (fabs(scrollView.contentOffset.y) < self.viewModel.tableViewTopMargin || scrollView.contentOffset.y > 0)) {
                    self.viewModel.willOutOfBounds = YES;
                    self.carouselView.currentTableView.contentOffset = CGPointMake(0, -self.viewModel.tableViewTopMargin);
                }
            }
            if (scrollView.contentOffset.y < 0) {
                if (-scrollView.contentOffset.y > self.viewModel.tableViewTopMargin) {
                    self.viewModel.scrollingDetailPage = YES;
                }
            }
        };
        viewModel.scrollViewDidEndDraggingBlock = ^(UIScrollView *scrollView, BOOL directionUp) {
            @strongify(self);
            CGFloat contentOffsetY = scrollView.contentOffset.y;
            NSLog(@"__scroll DidEndDraggingBlock offset=%f, directionUp=%@", scrollView.contentOffset.y, @(directionUp).stringValue);
            if (directionUp) {
                if (contentOffsetY > -self.carouselView.viewModel.tableViewMaxOriginY && self.viewModel.scrollingDetailPage) {
                    NSLog(@"__scroll to top DidEndDraggingBlock offset=%f, directionUp=%@", scrollView.contentOffset.y, @(directionUp).stringValue);
                    [self _kep_scrollToTopWithCompletion:^(BOOL finished) {
                        self.viewModel.scrollingDetailPage = NO;
                        [self _kep_disposeScrollViewOffset:scrollView.contentOffset];
                    }];
                }
            } else {
                if (-scrollView.contentOffset.y < self.carouselView.viewModel.tableViewMaxOriginY && self.viewModel.scrollingDetailPage) {
                    NSLog(@"__scroll to bottom DidEndDraggingBlock offset=%f, directionUp=%@", scrollView.contentOffset.y, @(directionUp).stringValue);
                    [self _kep_scrollToBottom];
                } else if (self.viewModel.sceneType == KEPAthleticFieldSceneTypeRespective && -scrollView.contentOffset.y >= self.carouselView.viewModel.tableViewMaxOriginY) {
                    if (self.viewModel.fromType == KEPAthleticFieldFromTypeGroup) {
                        [self _kep_transitToGlanceScene];
                    }
                } else if (-scrollView.contentOffset.y == self.carouselView.viewModel.tableViewMaxOriginY && self.viewModel.scrollingDetailPage) {
                    [self _kep_disposeScrollViewOffset:scrollView.contentOffset];
                }
            }
        };
        viewModel.scrollViewDidEndDeceleratingBlock = ^(UIScrollView *_Nonnull scrollView) {
            @strongify(self);
            if (scrollView.contentOffset.y > -self.carouselView.viewModel.tableViewMaxOriginY && self.viewModel.scrollingDetailPage) {
                NSLog(@"__scroll to top DidEndDeceleratingBlock offset=%f,", scrollView.contentOffset.y);
                [self _kep_scrollToTopWithCompletion:^(BOOL finished) {
                    self.viewModel.scrollingDetailPage = NO;
                    [self _kep_disposeScrollViewOffset:scrollView.contentOffset];
                }];
            }
        };
        viewModel.scrollToTopBlock = ^{
            @strongify(self);
            @weakify(self);
            self.viewModel.scrollingDetailPage = YES;
            [self _kep_scrollToTopWithCompletion:^(BOOL finished) {
                @strongify(self);
                [self _kep_disposeScrollViewOffset:self.carouselView.currentTableView.contentOffset];
                self.viewModel.scrollingDetailPage = NO;
            }];
        };
        _carouselView = [[TripDetailCarouseView alloc] initWithCarouselViewModel:viewModel];
    }
    return _carouselView;
}

- (UIView *)grayMask {
    if (!_grayMask) {
        _grayMask = [[UIView alloc] init];
        _grayMask.alpha = 0;
        _grayMask.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
        @weakify(self);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            @strongify(self);
            if (UIGestureRecognizerStateEnded == state) {
                [self _kep_scrollToBottom];
            }
        }];
        [_grayMask addGestureRecognizer:tapGesture];
    }
    return _grayMask;
}

- (KEPCustomNavBar *)navBar {
    if (!_navBar) {
        _navBar = [[KEPCustomNavBar alloc] init];
        _navBar.hidden = YES;
        @weakify(self);
        [_navBar addBackButtonWhenTapped:^{
            @strongify(self);
            [self _kep_quitAthleticFieldScene];
        }];
    }
    return _navBar;
}

#pragma mark - Private Methods

- (void)_kep_setupSubviews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.grayMask];
    [self.view addSubview:self.backToggle];
    [self.view addSubview:self.navBar];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.grayMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.backToggle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(ToggleSize);
        make.leading.mas_offset(14);
        make.top.mas_offset(32 + iPhoneXTopOffsetY);
    }];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_offset(0);
        make.height.mas_equalTo([KEPCustomNavBar barDefaultHeight]);
    }];
}


- (void)_kep_transitToGlanceScene {
    [self.mapViewModel _kep_setupDefaultZoomLevel:YES];
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.carouselView.frame = ({
                             CGRect frame;
                             frame.size = self.carouselView.frame.size;
                             frame.origin.x = self.carouselView.frame.origin.x;
                             frame.origin.y = self.view.bounds.size.height;
                             frame;
                         });
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         self.viewModel.sceneType =  KEPAthleticFieldSceneTypeGlance;
                         self.viewModel.tripModels = nil;
                         self.carouselView.viewModel.tripModels = nil;
                         [self.carouselView removeFromSuperview];
                     }];
    
}

- (void)_kep_bindViewModelToMap {
    [self.mapViewModel configureMapView:self.mapView];
}

- (void)_kep_fetchTripModels {
    if (self.viewModel.fromType == KEPAthleticFieldFromTypeTrip) {
        [SVProgressHUD show];
        @weakify(self);
        [TripDetailRequester fetchTripDetailWithId:self.viewModel.requetId callback:^(BOOL success, NSDictionary * _Nonnull dic) {
            @strongify(self);
            if (success) {
                [SVProgressHUD dismiss];
                NSArray <TripDetailModel *> *datas = dic[kResultData];
                self.viewModel.tripModels = datas;
                self.carouselView.viewModel.tripModels = datas;
                self.mapViewModel.tripModels = datas;
                self.mapViewModel.currentModel = datas.firstObject;
                [self _kep_scrollTableViewVisible];
            } else {
                [SVProgressHUD showInfoWithStatus:dic[kResultData]];
            }
        }];
    }
    
}


- (void)_kep_setupKVO {
    @weakify(self);
    [[RACObserve(self.carouselView, offset) skip:1] subscribeNext:^(NSValue *_Nullable newValue) {
        @strongify(self);
        CGPoint contentOffset = [newValue CGPointValue];
        if (self.viewModel.scrollingDetailPage || self.viewModel.willOutOfBounds) {
            return;
        }
        [self _kep_disposeScrollViewOffset:contentOffset];
    }];
    [[RACObserve(self.navBar, hidden) skip:1] subscribeNext:^(NSNumber *_Nullable newValue) {
        UIStatusBarStyle barStyle = [newValue boolValue] ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [[UIApplication sharedApplication] setStatusBarStyle:barStyle animated:NO];
    }];
    [[[RACObserve(self.viewModel, sceneType) skip:1] distinctUntilChanged] subscribeNext:^(NSNumber *_Nullable x) {
        @strongify(self);
        KEPAthleticFieldSceneType sceneType = [x integerValue];
        if (sceneType == KEPAthleticFieldSceneTypeSpecific) {
            self.viewModel.scrollingDetailPage = YES;
        }
        self.carouselView.viewModel.sceneType = sceneType;
        self.mapViewModel.sceneType = sceneType;
        
        CGAffineTransform transform;
        if (self.viewModel.fromType == KEPAthleticFieldFromTypeTrip) {
            transform = KEPAthleticFieldSceneTypeSpecific == sceneType ? CGAffineTransformMakeRotation(-M_PI_2) : CGAffineTransformIdentity;
        } else {
            transform = KEPAthleticFieldSceneTypeGlance == sceneType ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(-M_PI_2);
        }
        if (!CGAffineTransformEqualToTransform(self.backToggle.transform, transform)) {
            [UIView animateWithDuration:.25
                             animations:^{
                                 self.backToggle.transform = transform;
                             }];
        }
    }];
    
    [[RACObserve(self.carouselView.viewModel, currentTripModel) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        TripDetailModel *model = self.carouselView.viewModel.currentTripModel;
        self.mapViewModel.currentModel = model;
    }];


}


- (void)_kep_scrollTableViewVisible {
    TripDetailTableView *tableView = self.carouselView.currentTableView;
    tableView.contentInset = UIEdgeInsetsMake(self.carouselView.viewModel.tableViewMaxOriginY, 0, 0, 0);
    if (!self.carouselView.superview) {
        self.carouselView.frame = self.carouselView.viewModel.frame;
        [self.view addSubview:self.carouselView];
        [self.view insertSubview:self.carouselView aboveSubview:self.grayMask];
        [tableView setContentOffset:CGPointMake(0, -self.view.bounds.size.height)];
        [tableView reloadData];
        [UIView animateWithDuration:.5 animations:^{
            [tableView setContentOffset:CGPointMake(0, -self.carouselView.viewModel.tableViewMaxOriginY)];
        } completion:^(BOOL finished) {
            if (self.viewModel.sceneType != KEPAthleticFieldSceneTypeRespective) {
                self.viewModel.sceneType = KEPAthleticFieldSceneTypeRespective;
            }
        }];
    }

    [self.mapViewModel adjustMapForRespective];
    [self _kep_showTogglesForRespectiveScene];
}



- (void)_kep_dismissLoadingView {
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}


- (void)_kep_scrollToTopWithCompletion:(void (^__nullable)(BOOL finished))completion {
    CGFloat height = CGRectGetHeight(self.carouselView.bounds);
    CGFloat offset = MIN(-self.viewModel.tableViewTopMargin, -(height - self.carouselView.currentTableView.contentSize.height) + self.carouselView.currentTableView.contentInset.bottom);
    [self.carouselView.currentTableView adjustTableViewContent];
    [UIView animateWithDuration:.2
                     animations:^{
                         self.carouselView.currentTableView.contentOffset = CGPointMake(0, offset);
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion(finished);
                         }
                     }];
    
}

- (void)_kep_disposeScrollViewOffset:(CGPoint)offset {
    CGSize navBarSize = [_navBar sizeThatFits:CGSizeZero];
    if (-offset.y < navBarSize.height) {
        [self _kep_showNavBar];
    } else {
        [self _kep_hideNavBar];
    }

    if (offset.y > -self.carouselView.viewModel.tableViewMaxOriginY) {
        NSLog(@"__scroll will detail style");
        if (KEPAthleticFieldSceneTypeRespective == self.viewModel.sceneType) {
            NSLog(@"__scroll to detail style");
            [self _kep_showTogglesForSpecificScene];
            self.viewModel.sceneType = KEPAthleticFieldSceneTypeSpecific;
            [self.mapViewModel adjustMapForSpecific];
        }
    }
    else{
        if (KEPAthleticFieldSceneTypeSpecific == self.viewModel.sceneType) {
            NSLog(@"__scroll to Respective");
            [self _kep_showTogglesForRespectiveScene];
            self.viewModel.sceneType = KEPAthleticFieldSceneTypeRespective;
            [self.mapViewModel adjustMapForRespective];
        }
    }
}


- (void)_kep_scrollToBottom {
    NSLog(@"__scroll _kep_scrollToBottom");
    [UIView animateWithDuration:.5
                     animations:^{
                         self.carouselView.currentTableView.contentOffset = CGPointMake(0, -self.carouselView.viewModel.tableViewMaxOriginY);
                     }
                     completion:^(BOOL finished) {
                         [self _kep_disposeScrollViewOffset:self.carouselView.currentTableView.contentOffset];
                         self.viewModel.scrollingDetailPage = NO;
                     }];
}


- (void)_kep_quitAthleticFieldScene {
    if (KEPAthleticFieldSceneTypeGlance == self.viewModel.sceneType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (KEPAthleticFieldSceneTypeRespective == self.viewModel.sceneType) {
        if (self.viewModel.fromType == KEPAthleticFieldFromTypeGroup) {
            [self _kep_transitToGlanceScene];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (KEPAthleticFieldSceneTypeSpecific == self.viewModel.sceneType) {
        [self _kep_scrollToBottom];
    }
}

- (void)_kep_showTogglesForSpecificScene {
    if (self.grayMask.alpha < 1) {
        [self.grayMask kep_appearAlphaWithAnimation];
    }
}

- (void)_kep_showTogglesForRespectiveScene {
    if (self.grayMask.alpha > 0) {
        [self.grayMask kep_disappearAlphaWithAnimation];
    }
}

- (void)_kep_showNavBar {
    if (!self.navBar.hidden) {
        return;
    }
    [self.navBar kep_appearAlphaWithAnimation];
    [self.backToggle kep_disappearAlphaWithAnimation];
}

- (void)_kep_hideNavBar {
    if (self.navBar.hidden) {
        return;
    }
    [self.navBar kep_disappearAlphaWithAnimationCompletion:^{
        self.navBar.hidden = YES;
    }];
    [self.backToggle kep_appearAlphaWithAnimation];
}

@end
