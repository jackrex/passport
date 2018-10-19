//
//  MMTimelineImagesPreviewVC.m
//  Keep
//
//  Created by CharlesChen on 2017/5/23.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "MMTimelineImagesPreviewVC.h"
#import "MMImagesPreviewView.h"

@implementation MMTimelineImagesPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cancelButton.hidden = YES;
    self.deleteButton.hidden = YES;

    if (self.images.count <= 1) {
        self.titleLabel.hidden = YES;
    }

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (self.closeHandler) {
        self.closeHandler();
    }
}

#pragma mark - UIPanGestureRecognizer

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.view == self.view) {
        switch (panGesture.state) {
            case UIGestureRecognizerStateBegan: {
                CGPoint translation = [panGesture translationInView:self.view];
                if (fabs(translation.x) > fabs(translation.y)) {
                    panGesture.enabled = NO;
                    return;
                }
            } break;
            case UIGestureRecognizerStateChanged: {
                CGPoint translation = [panGesture translationInView:self.view];
                CGPoint center = self.previewView.center;
                center.y = MAX(self.view.bounds.size.height / 2, center.y + translation.y);
                self.previewView.center = center;
                [panGesture setTranslation:CGPointZero inView:self.view];
            } break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed: {
                CGFloat offset = self.view.bounds.size.height / 2;
                if (self.previewView.center.y - offset >= 100.f) {
                    offset = self.view.bounds.size.height + self.previewView.bounds.size.height / 2;
                }
                CGPoint center = self.previewView.center;
                center.y = offset;
                [UIView animateWithDuration:0.25f animations:^{
                    self.previewView.center = center;
                } completion:^(BOOL finished) {
                    if (self.previewView.frame.origin.y == self.view.bounds.size.height) {
                        if (self.closeHandler) {
                            self.closeHandler();
                        }
                    }
                }];
                panGesture.enabled = YES;
            } break;
            default:
                break;
        }
    }
}


@end
