//
//  MMImagesPreviewVC.h
//  Keep
//
//  Created by CharlesChen on 2017/5/20.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "BaseUIViewController.h"

@class MMImagesPreviewView;
@class MMImagesPreviewVC;

@protocol MMImagesPreviewVCDelegate <NSObject>

- (void)previewVC:(MMImagesPreviewVC *)previewVC didDeleteImageAtIndex:(NSUInteger)index;

@end


@interface MMImagesPreviewVC : BaseUIViewController

@property (nonatomic, copy) NSString *userNameForSave;
@property (nonatomic, readonly) NSMutableArray<UIImage *> *images;
@property (nonatomic, weak) id<MMImagesPreviewVCDelegate> delegate;

@property (nonatomic, readonly) MMImagesPreviewView *previewView;
@property (nonatomic, readonly) UIButton *cancelButton;
@property (nonatomic, readonly) UIButton *deleteButton;
@property (nonatomic, readonly) UILabel *titleLabel;


- (instancetype)initWithImages:(NSArray *)images scrollToIndex:(NSUInteger)index;

@end
