//
//  KEPWelcomeVideoView.h
//  Keep
//
//  Created by liwenxiu on 2017/4/20.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface KEPWelcomeVideoView : UIView

@property (nonatomic, strong, readonly) AVPlayerViewController *moviePlayer;
@property (nonatomic, strong, readonly) UIImageView *videoFinishedImageView;
@property (nonatomic, strong, readonly) id timeObserver;
@property (nonatomic, assign) BOOL hadShowWelcomeIntroView;

+ (instancetype)shareInstance;

- (void)play;
- (void)pause;

@end
