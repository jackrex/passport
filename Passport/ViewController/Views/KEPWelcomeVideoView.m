//
//  KEPWelcomeVideoView.m
//  Keep
//
//  Created by liwenxiu on 2017/4/20.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "KEPWelcomeVideoView.h"

@interface KEPWelcomeVideoView ()

@property (nonatomic, strong) AVPlayerViewController *moviePlayer;
@property (nonatomic, strong) UIImageView *videoFinishedImageView;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) id timeObserver;

@end


@implementation KEPWelcomeVideoView

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id _shareInstance = nil;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    return _shareInstance;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupMoviePlayer];
        [self setupVideoFinishedImageView];
    }
    return self;
}

- (void)removeObserve {
    @try {
        [self.moviePlayer.player removeTimeObserver:self.timeObserver];
    } @catch (NSException *exception) {
    }

    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self.moviePlayer.player];
    } @catch (NSException *exception) {
    }
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } @catch (NSException *exception) {
    }
}

- (void)setupVideoFinishedImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = self.bounds;
    self.videoFinishedImageView = imageView;
    [self addSubview:imageView];
}

- (void)setupMoviePlayer {
    NSString *videoUrl = [[NSBundle mainBundle] pathForResource:@"Earth" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:videoUrl];
    self.videoUrl = url;

    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:item];

    self.moviePlayer = [[AVPlayerViewController alloc] init];
    self.moviePlayer.showsPlaybackControls = NO;
    self.moviePlayer.player = player;
    [self addSubview:self.moviePlayer.view];
    self.moviePlayer.view.frame = self.bounds;
    self.moviePlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:self.moviePlayer.player.currentItem];

    __weak __typeof(self) weakSelf = self;
    self.timeObserver = [self.moviePlayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // do nothings
    }];
    [self.moviePlayer.player play];
}

- (void)repeatPlay {
    [self.moviePlayer.player seekToTime:kCMTimeZero];
    [self.moviePlayer.player play];
}

- (void)play {
    [self.moviePlayer.player play];
}

- (void)pause {
    [self.moviePlayer.player pause];
}

@end
