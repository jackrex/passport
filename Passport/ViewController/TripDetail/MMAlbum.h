//
//  MMAlbum.h
//  Keep
//
//  Created by CharlesChen on 2016/12/27.
//  Copyright © 2016年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


@interface MMAlbum : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) PHAssetMediaType mediaType;
@property (nonatomic, readonly) NSUInteger count;

@end


@interface MMLocalAlbum : MMAlbum

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSArray<PHAsset *> *assets;

+ (instancetype)albumWithMediaTypes:(NSArray *)mediaTypes collection:(PHAssetCollection *)collection;

@end


@interface MMURLAlbum : MMAlbum

@property (nonatomic, strong) NSArray<NSURL *> *urls;

@end



@interface MMImageModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) BOOL needRequest;

@end
