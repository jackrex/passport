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
    KEPEntryCellResuseMaskNoPhotos = 1 << 2,
    KEPEntryCellResuseMaskMeta = 1 << 3,
    KEPEntryCellResuseMaskText = 1 << 4,
    KEPEntryCellResuseMaskNoText = 1 << 5,
    
    KEPEntryCellResuseMaskALL = 0b1111111
};



@interface KEPTimelineEntryCell ()

@property(nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) KEPEntryHeaderView *headerView;
@property (nonatomic, strong) KEPEntryTextView *textView;
@property (nonatomic, strong) KEPEntryPhotoAndVideoView *photoVideoView;
@property (nonatomic, strong) KEPEntryMultiPhotosView *photosView;
@property (nonatomic, strong) KEPEntryMetaAndCardView *metaAndCardView;
@property(nonatomic, strong) UIImageView *noPhotoView;
@property(nonatomic, strong) UIImageView *noTextView;

@property (nonatomic) CGFloat cellHeight;
@end

@implementation KEPTimelineEntryCell

- (void)adjustTableViewContent {
    [super adjustTableViewContent];
    self.containerView.layer.masksToBounds = NO;
}

- (void)addRoundCorner {
    [super addRoundCorner];
    self.containerView.layer.masksToBounds = YES;
}

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
    
     {
         if (self.containerView.superview == nil) {
             self.containerView = [[UIView alloc] init];
             self.containerView.layer.masksToBounds = YES;
             [self.contentView addSubview:self.containerView];
             [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.edges.mas_equalTo(self.contentView);
             }];
         }
    }
    
    // Header view
    {
        if (self.headerView.superview == nil) {
            [self.containerView addSubview:self.headerView];
        }
        if (self.updateHeightOnly == NO) {
            [self.headerView updateData:model];
        }
        SetFrameByHeight(self.headerView, 0, 0, [KEPEntryHeaderView viewHeight]);
        bottomSpacing = NO;
        
        if (model.isGroupData) {
            self.cellHeight = originY;
            CGRect rect = self.frame;
            rect.size.height = self.cellHeight;
            self.frame = rect;
            return;
        }
    }
    
    
    if ([KEPEntryPhotoAndVideoView shouldDisplayForData:model]) {
        if (self.photoVideoView.superview == nil) {
            [self.containerView addSubview:self.photoVideoView];
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
            [self.containerView addSubview:self.photosView];
        }
        if (self.updateHeightOnly == NO) {
            [self.photosView updateData:model];
        }
        SetFrameByHeight(self.photosView, 0, 0, [KEPTimelineEntryCellHelper photoHeight:model]);
        bottomSpacing = NO;
    } else {
        if (self.noPhotoView.superview == nil) {
            self.noPhotoView = [UIImageView kep_createImageView];
            self.noPhotoView.image = [UIImage imageNamed:@"no_photo"];
            self.noPhotoView.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:self.noPhotoView];
            [self.noPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.width.mas_equalTo(316);
                make.height.mas_equalTo(178);
                make.top.mas_offset(originY);
            }];
        }
        SetFrameByHeight(self.noPhotoView, 0, 14, 178);
        bottomSpacing = YES;
    }
    
    if ([KEPEntryMetaAndCardView shouldDisplayForData:model]) {
        if (self.metaAndCardView.superview == nil) {
            [self.containerView addSubview:self.metaAndCardView];
        }
        [self.metaAndCardView updateData:model];
        SetViewFrame(self.metaAndCardView, bottomSpacing? 12 : 0, 16);
        bottomSpacing = YES;
    }
    
    if (model.text.length > 0) {
        if (self.textView.superview == nil) {
            [self.containerView addSubview:self.textView];
        }
        [self.textView updateData:model];
        SetViewFrame(self.textView, bottomSpacing ? 12 : 0, 0);
        bottomSpacing = YES;
    } else {
        if (self.noTextView.superview == nil) {
            self.noTextView = [UIImageView kep_createImageView];
            self.noTextView.image = [UIImage imageNamed:@"no_text"];
            self.noTextView.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:self.noTextView];
            [self.noTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_offset(12);
                make.width.mas_equalTo(283);
                make.height.mas_equalTo(38);
                make.top.mas_offset(originY + (bottomSpacing ? 24 : 12));
            }];
        } else {
            [self.noTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(originY + (bottomSpacing ? 24 : 12));
            }];
        }
        SetFrameByHeight(self.noTextView, bottomSpacing ? 24 : 0, 30, 38);
        bottomSpacing = NO;
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
    } else {
        mask = mask | KEPEntryCellResuseMaskNoPhotos;
    }
    if ([KEPEntryMetaAndCardView shouldDisplayForData:model]) {
        mask = mask | KEPEntryCellResuseMaskMeta;
    }
    if (model.text.length > 0) {
        mask = mask | KEPEntryCellResuseMaskText;
    } else {
        mask = mask | KEPEntryCellResuseMaskNoText;
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
    [self.noPhotoView removeFromSuperview];
    [self.noTextView removeFromSuperview];
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

