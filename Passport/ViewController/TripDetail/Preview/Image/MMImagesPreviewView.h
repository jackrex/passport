//
//  MMImagesPreviewView.h
//  Keep
//
//  Created by CharlesChen on 2017/5/21.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//


@import UIKit;
@class MMImagesPreviewView;

@protocol MMImagesPreviewViewDelegate <NSObject>

@optional
- (void)previewView:(MMImagesPreviewView *)previewView didScroll:(UIScrollView *)scrollView;
- (void)previewView:(MMImagesPreviewView *)previewView didEndDecelerating:(UIScrollView *)scrollView;

@end


@interface MMImagesPreviewView : UIView

@property (nonatomic, readonly) NSArray *images;
@property (nonatomic, weak) id<MMImagesPreviewViewDelegate> delegate;
@property (nonatomic, assign) BOOL zoomEnabled;
@property (nonatomic, assign) UIViewContentMode imageContentMode;
@property (nonatomic, copy) NSString *userNameForSave;
@property (nonatomic, assign) CGSize cellSize;


- (void)updateWithImages:(NSArray *)images scrollToIndex:(NSUInteger)index;

@end
