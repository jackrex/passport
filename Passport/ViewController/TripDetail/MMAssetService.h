//
//  MMAssetService.h
//  Keep
//
//  Created by CharlesChen on 2016/12/27.
//  Copyright © 2016年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "MMAlbum.h"

@interface MMAssetExtraInfoModel : NSObject

@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL isDegraded;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSNumber *requestId;

@end

typedef NS_ENUM(NSUInteger, MMAssetErrorCode) {
    MMAssetErrorCode_NoError,
    MMAssetErrorCode_AuthDenied,
    MMAssetErrorCode_NoAlbum,
    MMAssetErrorCode_ParamError,
    MMAssetErrorCode_RequestImageFailed,
    MMAssetErrorCode_RequestVideoFailed,
    MMAssetErrorCode_MergeVideoFailed,
    MMAssetErrorCode_CropVideoFailed,
    MMAssetErrorCode_ExportVideoFailed,
};

typedef void (^MMAssetrogressHandler)(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info);

@interface MMAssetService : NSObject

// service 和 shared 构造同样的单例，问题主要在于swift会将service转义为初始化方法
+ (instancetype)service NS_SWIFT_NAME(shared());

- (void)requestAuthorization:(void (^)(MMAssetErrorCode errorCode))handler;
- (BOOL)checkPhotoLibraryAuthrizationStatusAuthorized;
- (void)fetchAlbumsWithMediaTypes:(NSArray *)mediaTypes albumTypes:(NSArray *)albumTypes subtype:(PHAssetCollectionSubtype)subtype handler:(void (^)(MMAssetErrorCode errorCode, NSArray<MMLocalAlbum *> *albums))handler;

- (void)requestThumbnailWithAsset:(PHAsset *)asset size:(CGSize)size mode:(PHImageContentMode)mode handler:(void (^)(MMAssetErrorCode errorCode, UIImage *image))handler;

- (void)requestImageWithAsset:(PHAsset *)asset
                      maxSize:(CGSize)size
                      handler:(void (^)(MMAssetErrorCode errorCode, UIImage *image, MMAssetExtraInfoModel *extraInfoModel))handler
                     progress:(MMAssetrogressHandler)progressHandler;

- (void)requestImageWithAsset:(PHAsset *)asset
                      handler:(void (^)(MMAssetErrorCode errorCode, UIImage *image, MMAssetExtraInfoModel *extraInfoModel))handler
                     progress:(MMAssetrogressHandler)progressHandler;
- (void)requestURLWithAsset:(PHAsset *)asset
                    handler:(void (^)(MMAssetErrorCode errorCode, NSURL *url))handler
                   progress:(MMAssetrogressHandler)progressHandler;
- (void)requestVideoAssetWithAsset:(PHAsset *)asset
                           handler:(void (^)(MMAssetErrorCode errorCode, AVURLAsset *urlAsset, MMAssetExtraInfoModel *extraInfoModel))handler
                          progress:(MMAssetrogressHandler)progressHandler;

- (UIImage *)generateThumbnailWithAVAsset:(AVAsset *)asset;
- (NSTimeInterval)readDurationWithAVAsset:(AVAsset *)asset;

+ (BOOL)checkHEVCCodecTypeOfAsset:(AVAsset *)asset;

@end
