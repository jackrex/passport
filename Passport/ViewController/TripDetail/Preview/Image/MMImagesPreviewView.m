//
//  MMImagesPreviewView.m
//  Keep
//
//  Created by CharlesChen on 2017/5/21.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <KEPIntlCommon/KEPCommon.h>
#import "MMImagesPreviewView.h"
#import "MMImagePreviewView.h"
#import <Masonry/Masonry.h>


@interface MMImagePreviewCell : UICollectionViewCell

- (void)updateWithImage:(id)image zoomEnabled:(BOOL)zoomEnabled userNameForSave:(NSString *)userNameForSave imageContentMode:(UIViewContentMode)imageContentMode;

@end


@interface MMImagesPreviewView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) NSInteger scrollToIndex;

@end


@implementation MMImagesPreviewView

- (instancetype)init {
    if (self = [super init]) {
        self.zoomEnabled = YES;
        self.imageContentMode = UIViewContentModeScaleAspectFit;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0.f;
    layout.minimumInteritemSpacing = 0.f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:MMImagePreviewCell.class forCellWithReuseIdentifier:NSStringFromClass(MMImagePreviewCell.class)];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)updateWithImages:(NSArray *)images scrollToIndex:(NSUInteger)index {
    _images = images;
    self.scrollToIndex = self.index = (index < images.count) ? index : 0;

    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
    }];
    [self setNeedsLayout];
}

- (void)scrollToIndex:(NSUInteger)index {
    if (index >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.scrollToIndex >= 0) {
        [self scrollToIndex:self.scrollToIndex];
        self.scrollToIndex = -1;
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MMImagePreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MMImagePreviewCell.class) forIndexPath:indexPath];
    [cell updateWithImage:self.images[indexPath.item] zoomEnabled:self.zoomEnabled userNameForSave:self.userNameForSave imageContentMode:self.imageContentMode];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!CGSizeEqualToSize(self.cellSize, CGSizeZero)) {
        return self.cellSize;
    }
    
    return collectionView.bounds.size;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(previewView:didScroll:)]) {
        safeRetain(self);
        [self.delegate previewView:self didScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(previewView:didEndDecelerating:)]) {
        safeRetain(self);
        [self.delegate previewView:self didEndDecelerating:scrollView];
    }
}

@end


@interface MMImagePreviewCell ()

@property (nonatomic, strong) MMImagePreviewView *previewView;

@end


@implementation MMImagePreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.previewView = [[MMImagePreviewView alloc] init];
    [self.contentView addSubview:self.previewView];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)updateWithImage:(id)image zoomEnabled:(BOOL)zoomEnabled userNameForSave:(NSString *)userNameForSave imageContentMode:(UIViewContentMode)imageContentMode {
    [self.previewView updateWithImage:image zoomEnabled:zoomEnabled userNameForSave:userNameForSave imageContentMode:imageContentMode];
}

@end
