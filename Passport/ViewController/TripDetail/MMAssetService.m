//
//  MMAssetService.m
//  Keep
//
//  Created by CharlesChen on 2016/12/27.
//  Copyright © 2016年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "MMAssetService.h"
#import <KEPIntlCommon/KDefine.h>

#define kMaxWidth (iPhone4 ? 1000.f : iPhone5 ? 1500.f : 2000.f)
#define kMaxHeight kMaxWidth

@implementation MMAssetExtraInfoModel

@end

@interface MMAssetService ()
@property (nonatomic, strong) dispatch_queue_t assetQueue;
@end


@implementation MMAssetService

+ (instancetype)service {
    static MMAssetService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[MMAssetService alloc] init];
    });
    return service;
}

#pragma mark - Authorization

- (void)requestAuthorization:(void (^)(MMAssetErrorCode errorCode))handler {
    if (!handler) {
        return;
    }
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            handler(status == PHAuthorizationStatusAuthorized ? MMAssetErrorCode_NoError : MMAssetErrorCode_AuthDenied);
        }];
        return;
    }
    handler(photoAuthStatus == PHAuthorizationStatusAuthorized ? MMAssetErrorCode_NoError : MMAssetErrorCode_AuthDenied);
}

- (BOOL)checkPhotoLibraryAuthrizationStatusAuthorized
{
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    return photoAuthStatus == PHAuthorizationStatusAuthorized;
}

#pragma mark - Album

- (void)fetchAlbumsWithMediaTypes:(NSArray *)mediaTypes albumTypes:(NSArray *)albumTypes subtype:(PHAssetCollectionSubtype)subtype handler:(void (^)(MMAssetErrorCode errorCode, NSArray<MMLocalAlbum *> *albums))handler {
    if (!handler) {
        return;
    }
    dispatch_async(self.assetQueue, ^{
        [self requestAuthorization:^(MMAssetErrorCode errorCode) {
            if (errorCode != MMAssetErrorCode_NoError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(errorCode, nil);
                });
                return;
            }

            NSMutableArray *albums = [NSMutableArray array];
            for (NSNumber *albumType in albumTypes) {
                PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:albumType.integerValue subtype:subtype options:nil];
                [result enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger index, BOOL *stop) {
                    MMLocalAlbum *album = [MMLocalAlbum albumWithMediaTypes:mediaTypes collection:collection];
                    if (album) {
                        [albums addObject:album];
                    }
                }];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                if (albums.count == 0) {
                    handler(MMAssetErrorCode_NoAlbum, nil);
                } else {
                    handler(MMAssetErrorCode_NoError, [albums copy]);
                }
            });
        }];
    });
}

#pragma mark - Image

- (void)requestThumbnailWithAsset:(PHAsset *)asset size:(CGSize)size mode:(PHImageContentMode)mode handler:(void (^)(MMAssetErrorCode errorCode, UIImage *image))handler {
    if (!handler) {
        return;
    }
    dispatch_async(self.assetQueue, ^{
        CGSize imageSize = CGSizeMake(size.width, size.height);
        if (![asset isKindOfClass:PHAsset.class] || imageSize.width <= 0 || imageSize.height <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(MMAssetErrorCode_ParamError, nil);
            });
            return;
        }

        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.networkAccessAllowed = YES;
        CGFloat scale = [UIScreen mainScreen].scale;
        imageSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);
        [self _requestImageAssetWithAsset:asset targetSize:size mode:mode options:options handler:^(MMAssetErrorCode errorCode, UIImage *image, MMAssetExtraInfoModel *extraInfoModel) {
            handler(errorCode, image);
        }];
    });
}

- (void)requestImageWithAsset:(PHAsset *)asset
                      maxSize:(CGSize)size
                      handler:(void (^)(MMAssetErrorCode errorCode, UIImage *image, MMAssetExtraInfoModel *extraInfoModel))handler
                     progress:(MMAssetrogressHandler)progressHandler {
    if (!handler) {
        return;
    }
    dispatch_async(self.assetQueue, ^{
        if (![asset isKindOfClass:PHAsset.class]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(MMAssetErrorCode_ParamError, nil, nil);
            });
            return;
        }
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize imageSize = CGSizeMake(asset.pixelWidth * scale, asset.pixelHeight * scale);
        if (imageSize.width > size.width || imageSize.height > size.height) {
            CGFloat imageScale = MIN(size.width / imageSize.width, size.height / imageSize.height);
            imageSize.width *= imageScale;
            imageSize.height *= imageScale;
        }
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;
        options.progressHandler = progressHandler;
        options.synchronous = YES;
        [self _requestImageAssetWithAsset:asset targetSize:imageSize mode:PHImageContentModeDefault options:options handler:handler];
    });
}

- (void)requestImageWithAsset:(PHAsset *)asset
                      handler:(void (^)(MMAssetErrorCode errorCode, UIImage *image, MMAssetExtraInfoModel *extraInfoModel))handler
                     progress:(MMAssetrogressHandler)progressHandler {
    [self requestImageWithAsset:asset maxSize:CGSizeMake(kMaxWidth, kMaxHeight) handler:handler progress:progressHandler];
}

#pragma mark - AVURLAsset

- (void)requestURLWithAsset:(PHAsset *)asset
                    handler:(void (^)(MMAssetErrorCode errorCode, NSURL *url))handler
                   progress:(MMAssetrogressHandler)progressHandler {
    if (!handler) {
        return;
    }
    dispatch_async(self.assetQueue, ^{
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (contentEditingInput.fullSizeImageURL) {
                        handler(MMAssetErrorCode_NoError, contentEditingInput.fullSizeImageURL);
                    } else {
                        handler(MMAssetErrorCode_RequestImageFailed, nil);
                    }
                });
            }];
        } else if (asset.mediaType == PHAssetMediaTypeVideo) {
            [self _requestVideoAssetWithAsset:asset handler:^(MMAssetErrorCode errorCode, AVURLAsset *urlAsset, MMAssetExtraInfoModel *extraInfoModel) {
                handler(errorCode, urlAsset.URL);
            } progress:progressHandler];
        }
    });
}

- (void)requestVideoAssetWithAsset:(PHAsset *)asset
                           handler:(void (^)(MMAssetErrorCode errorCode, AVURLAsset *urlAsset, MMAssetExtraInfoModel *extraInfoModel))handler
                          progress:(MMAssetrogressHandler)progressHandler {
    if (!handler) {
        return;
    }
    dispatch_async(self.assetQueue, ^{
        if (asset.mediaType != PHAssetMediaTypeVideo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(MMAssetErrorCode_ParamError, nil, nil);
            });
            return;
        }
        [self _requestVideoAssetWithAsset:asset handler:^(MMAssetErrorCode errorCode, AVURLAsset *urlAsset, MMAssetExtraInfoModel *extraInfoModel) {
            handler(errorCode, urlAsset, extraInfoModel);
        } progress:progressHandler];
    });
}

#pragma mark - reqeset asset method
- (void)_requestVideoAssetWithAsset:(PHAsset *)asset
                            handler:(void (^)(MMAssetErrorCode errorCode, AVURLAsset *urlAsset, MMAssetExtraInfoModel *extraInfoModel))handler
                           progress:(MMAssetrogressHandler)progressHandler {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.progressHandler = progressHandler;
    options.networkAccessAllowed = YES;
    options.version = PHVideoRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([avAsset isKindOfClass:AVURLAsset.class]) {
                MMAssetExtraInfoModel *extraInfoModel = [[MMAssetExtraInfoModel alloc] init];
                extraInfoModel.isCanceled = [[info objectForKey:PHImageCancelledKey] boolValue];
                extraInfoModel.isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                extraInfoModel.requestId = [info objectForKey:PHImageResultRequestIDKey];
                extraInfoModel.error = [info objectForKey:PHImageErrorKey];
                handler(MMAssetErrorCode_NoError, ((AVURLAsset *)avAsset), extraInfoModel);
            } else {
                handler(MMAssetErrorCode_RequestVideoFailed, nil, nil);
            }
        });
    }];
}

- (void)_requestImageAssetWithAsset:(PHAsset *)asset
                         targetSize:(CGSize)targetSize
                               mode:(PHImageContentMode)mode
                            options:(PHImageRequestOptions *)options
                            handler:(void (^)(MMAssetErrorCode errorCode, UIImage *image, MMAssetExtraInfoModel *extraInfoModel))handler {
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:targetSize
                                              contentMode:mode
                                                  options:options
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if (result) {
                                                        MMAssetExtraInfoModel *extraInfoModel = [[MMAssetExtraInfoModel alloc] init];
                                                        extraInfoModel.isCanceled = [[info objectForKey:PHImageCancelledKey] boolValue];
                                                        extraInfoModel.isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                                                        extraInfoModel.requestId = [info objectForKey:PHImageResultRequestIDKey];
                                                        extraInfoModel.error = [info objectForKey:PHImageErrorKey];
                                                        handler(MMAssetErrorCode_NoError, result, extraInfoModel);
                                                    } else {
                                                        handler(MMAssetErrorCode_RequestImageFailed, nil, nil);
                                                    }
                                                });
                                            }];
}

#pragma mark - Video Thumbnail

- (UIImage *)generateThumbnailWithAVAsset:(AVAsset *)asset {
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    generator.requestedTimeToleranceBefore = kCMTimeZero;

    CMTime time = CMTimeMakeWithSeconds(0.f, 600);
    CGImageRef imageRef = [generator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *image = nil;
    if (imageRef != NULL) {
        image = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    return image;
}

- (NSTimeInterval)readDurationWithAVAsset:(AVAsset *)asset {
    return CMTimeGetSeconds(asset.duration);
}

+ (BOOL)checkHEVCCodecTypeOfAsset:(AVAsset *)asset
{
    AVAssetTrack *assetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    for (id formatDescription in assetTrack.formatDescriptions) {
        CMFormatDescriptionRef desc = (__bridge CMFormatDescriptionRef)formatDescription;
        CMVideoCodecType codec = CMFormatDescriptionGetMediaSubType(desc);
        CGSize natrualSize = [assetTrack naturalSize];
        if (codec == kCMVideoCodecType_HEVC && natrualSize.width >= 2160) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - Setter & Getter

- (dispatch_queue_t)assetQueue {
    return _assetQueue = _assetQueue ?: dispatch_queue_create("com.keep.writeVideoQueue", DISPATCH_QUEUE_SERIAL);
}

@end
