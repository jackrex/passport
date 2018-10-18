//
//  KEPTimelineEntryCell.m
//  Keep
//
//  Created by jianjun on 2018-04-01.
//  Copyright © 2018 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <BlocksKit/BlocksKit.h>
#import <KEPIntlCommon/KEPCommon.h>
#import <BlocksKit/UIControl+BlocksKit.h>
#import <BlocksKit/UIView+BlocksKit.h>

#import "KEPTimelineEntryCell.h"

#import "TripDetailModel.h"

#import "KEPEntryHeaderView.h"
#import "KEPEntryTextView.h"
#import "KEPEntryPhotoAndVideoView.h"
#import "KEPEntryMultiPhotosView.h"
#import "KEPEntryMetaAndCardView.h"

#import "KEPTimelineEntryCellHelper.h"

#define SetViewFrame(view, offsetY, inset) \
CGSize size = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]; \
view.frame = CGRectMake((inset), originY + (offsetY), self.contentView.frame.size.width - 2 * (inset), size.height); \
originY = CGRectGetMaxY(view.frame);\
view.autoresizingMask = UIViewAutoresizingNone;


#define SetFrameByHeight(view, offsetY, inset, height) \
view.frame = CGRectMake((inset), originY + (offsetY), self.contentView.frame.size.width - 2 * (inset), (height)); \
originY += (offsetY) + (height);\
view.autoresizingMask = UIViewAutoresizingNone;


typedef NS_OPTIONS(NSUInteger, KEPEntryCellResuseMask) {
    KEPEntryCellResuseMaskNone = 0,
    KEPEntryCellResuseMaskPhoto = 1 << 0,
    KEPEntryCellResuseMaskPhotos = 1 << 1,
    KEPEntryCellResuseMaskMeta = 1 << 2,
    KEPEntryCellResuseMaskText = 1 << 3,
    
    KEPEntryCellResuseMaskALL = 0b11111
};



@interface KEPTimelineEntryCell ()

@property (nonatomic, strong) KEPEntryHeaderView *headerView;
@property (nonatomic, strong) KEPEntryTextView *textView;
@property (nonatomic, strong) KEPEntryPhotoAndVideoView *photoVideoView;
@property (nonatomic, strong) KEPEntryMultiPhotosView *photosView;
@property (nonatomic, strong) KEPEntryMetaAndCardView *metaAndCardView;
@property (nonatomic, strong) UIView *contentBackgroundView;
@property (nonatomic) CGFloat cellHeight;
@end

@implementation KEPTimelineEntryCell

- (void)updateData:(TripDetailModel *)model
{
    if (self.TripDetailModel == model && self.updateHeightOnly == NO) {
        return;
    }
    self.TripDetailModel = model;
    [self createViewsIfNeededByModel:model];
    self.contentView.frame = CGRectMake(0, 0, ScreenSize.width, 0);
    CGFloat originY = 0;
    BOOL bottomSpacing = NO; // 组件是否顶部自带空白
    // Header view
    {
        if (self.headerView.superview == nil) {
            [self.contentView addSubview:self.headerView];
        }
        if (self.updateHeightOnly == NO) {
            [self.headerView updateData:model];
        }
        SetFrameByHeight(self.headerView, 0, 0, [KEPEntryHeaderView viewHeight]);
        bottomSpacing = NO;
    }
    
    if ([KEPEntryPhotoAndVideoView shouldDisplayForData:model]) {
        if (self.photoVideoView.superview == nil) {
            [self.contentView addSubview:self.photoVideoView];
        }
        if (self.updateHeightOnly == NO) {
            [self.photoVideoView updateData:model];
        }
        SetFrameByHeight(self.photoVideoView, 0, 0, [KEPTimelineEntryCellHelper photoHeight:model]);
        if (IPAD_DEVICE) {
            CGRect frame = self.photoVideoView.frame;
            frame.origin.x = [KEPTimelineEntryCellHelper photoLeadingMargin];
            frame.size.width -= ([KEPTimelineEntryCellHelper photoLeadingMargin] + [KEPTimelineEntryCellHelper photoTailingMargin]);
            self.photoVideoView.frame = frame;
        }
        bottomSpacing = YES;
    } else if ([KEPEntryMultiPhotosView shouldDisplayForData:model]) {
        if (self.photosView.superview == nil) {
            [self.contentView addSubview:self.photosView];
        }
        if (self.updateHeightOnly == NO) {
            [self.photosView updateData:model];
        }
        SetFrameByHeight(self.photosView, 0, 0, [KEPTimelineEntryCellHelper photoHeight:model]);
        bottomSpacing = NO;
    }
    
    if (model.text.length > 0) {
        if (self.textView.superview == nil) {
            [self.contentView addSubview:self.textView];
        }
        [self.textView updateData:model];
        SetViewFrame(self.textView, bottomSpacing ? 12 : 0, 0);
        bottomSpacing = YES;
    }
    
    
    if ([KEPEntryMetaAndCardView shouldDisplayForData:model]) {
        if (self.metaAndCardView.superview == nil) {
            [self.contentView addSubview:self.metaAndCardView];
        }
        if (self.updateHeightOnly == NO) {
            [self.metaAndCardView updateData:model];
        }
        SetFrameByHeight(self.metaAndCardView, bottomSpacing? 12 : 0, 16, [KEPEntryMetaAndCardView viewHeight]);
        bottomSpacing = YES;
    }

    if (self.updateHeightOnly == NO) {
        if (self.contentBackgroundView.superview == nil) {
            [self.contentView insertSubview:self.contentBackgroundView atIndex:0];
        }
        [self.contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }

    CGFloat bottomSpaceViewHeight = 12;
    self.cellHeight = originY + bottomSpaceViewHeight;
    CGRect rect = self.frame;
    rect.size.height = self.cellHeight;
    self.frame = rect;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(ScreenSize.width, self.cellHeight);
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize
{
    return CGSizeMake(ScreenSize.width, self.cellHeight);
}

- (void)updateDataForHeight:(TripDetailModel *)model
{
    CGFloat height = [KEPTimelineEntryCellHelper cellHeightOfModel:model];
    self.cellHeight = height;
}

+ (NSString *)reuseIdentifierByModel:(TripDetailModel *)model
{
    KEPEntryCellResuseMask mask = KEPEntryCellResuseMaskNone;
    if ([KEPEntryPhotoAndVideoView shouldDisplayForData:model]) {
        mask = mask | KEPEntryCellResuseMaskPhoto;
    } else if ([KEPEntryMultiPhotosView shouldDisplayForData:model]) {
        mask = mask | KEPEntryCellResuseMaskPhotos;
    }
    if ([KEPEntryMetaAndCardView shouldDisplayForData:model]) {
        mask = mask | KEPEntryCellResuseMaskMeta;
    }
    if (model.text.length > 0) {
        mask = mask | KEPEntryCellResuseMaskText;
    }
    return [self reuseIDByMask:mask];
}

+ (void)registerInTableView:(UITableView *)tableView
{
    for (int i = 0; i <= KEPEntryCellResuseMaskALL; ++i) {
        [tableView registerClass:self forCellReuseIdentifier:[self reuseIDByMask:i]];
    }
}

+ (NSString *)reuseIDByMask:(KEPEntryCellResuseMask)mask
{
    if (mask > KEPEntryCellResuseMaskALL) {
        mask = 0UL;
    }
    return [NSString stringWithFormat:@"entrycell_type_%lu", (unsigned long)mask];
}

- (void)createViewsIfNeededByModel:(TripDetailModel *)model
{
    if (self.contentBackgroundView == nil && self.updateHeightOnly == NO) {
        self.contentBackgroundView = [[UIView alloc] init];
        self.contentBackgroundView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [KColorManager tableViewBackgroundColor];
    }
    if (self.headerView == nil) {
        self.headerView = [[KEPEntryHeaderView alloc] init];
        [self observeHeaderView];
    }
    
    if (model.text.length > 0) {
        if (self.textView == nil) {
            self.textView = [[KEPEntryTextView alloc] init];
        }
        [self.textView setTextNumberOfLines: 0];
    } else if (self.updateHeightOnly == NO) {
        [self.textView removeFromSuperview];
    }
    
    
    if ([KEPEntryPhotoAndVideoView shouldDisplayForData:model]) {
        if (self.photoVideoView == nil) {
            self.photoVideoView = [[KEPEntryPhotoAndVideoView alloc] init];
        }
    } else if (self.updateHeightOnly == NO) {
        [self.photoVideoView removeFromSuperview];
    }
    if ([KEPEntryMultiPhotosView shouldDisplayForData:model]) {
        if (self.photosView == nil) {
            self.photosView = [[KEPEntryMultiPhotosView alloc] init];
        }
    } else if (self.updateHeightOnly == NO) {
        [self.photosView removeFromSuperview];
    }
    if ([KEPEntryMetaAndCardView shouldDisplayForData:model]) {
        if (self.metaAndCardView == nil) {
            self.metaAndCardView = [[KEPEntryMetaAndCardView alloc] init];
            @weakify(self);
            [self.metaAndCardView bk_whenTapped:^{
                @strongify(self);
//                !self.didClickMetaDataAction ?: self.didClickMetaDataAction(self.TripDetailModel);
            }];
        }
    } else if (self.updateHeightOnly == NO) {
        [self.metaAndCardView removeFromSuperview];
    }

}

#pragma mark - Delegate and actions
- (void)observeHeaderView {
    @weakify(self);
//    self.headerView.avatarTouchCallBack = ^(NSString *_id) {
//        @strongify(self);
////        !self.avatarTouchCallBack ?: self.avatarTouchCallBack(_id);
//    };
}






@end

