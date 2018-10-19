//
//  MMAlbum.m
//  Keep
//
//  Created by CharlesChen on 2016/12/27.
//  Copyright © 2016年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

#import "MMAlbum.h"


@implementation MMAlbum

@end


@implementation MMLocalAlbum

+ (instancetype)albumWithMediaTypes:(NSArray *)mediaTypes collection:(PHAssetCollection *)collection {
    if (![collection isKindOfClass:PHAssetCollection.class]) {
        return nil;
    }

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType IN %@", mediaTypes];

    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    [result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        if ([asset isKindOfClass:PHAsset.class]) {
            if (asset.location) {
                
            }
            [assets addObject:asset];
        }
    }];

    if (assets.count == 0) {
        return nil;
    }

    MMLocalAlbum *album = [[MMLocalAlbum alloc] init];
    album.title = collection.localizedTitle;
    album.identifier = collection.localIdentifier;
    album.assets = [assets copy];
    album.mediaType = PHAssetMediaTypeUnknown;
    if (mediaTypes.count == 1) {
        if ([mediaTypes.firstObject integerValue] == PHAssetMediaTypeImage) {
            album.mediaType = PHAssetMediaTypeImage;
        } else if ([mediaTypes.firstObject integerValue] == PHAssetMediaTypeVideo) {
            album.mediaType = PHAssetMediaTypeVideo;
        }
    }
    return album;
}

- (NSUInteger)count {
    return self.assets.count;
}

@end


@implementation MMURLAlbum

- (instancetype)copy {
    MMURLAlbum *album = [[MMURLAlbum alloc] init];
    album.title = [self.title copy];
    album.urls = [self.urls copy];
    return album;
}

- (NSUInteger)count {
    return self.urls.count;
}

@end


@implementation MMImageModel

@end



