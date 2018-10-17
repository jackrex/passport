//
//  PhotoScanProcessor.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit
import Photos
import Toast_Swift

class PhotoScanProcessor {
    
    public static let COMPARE_NUM = 10
    
    public static func getAuthorized(view :UIView) -> Void {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.authorized {
                     fetchAllPhotosGPSInfo()
                }else if status == PHAuthorizationStatus.denied {
                    view.makeToast("Deny")
                }
            }
        }else if authStatus == PHAuthorizationStatus.authorized {
            let photos = handleDuplicatePhotos()
            print(photos)
        }else {
            view.makeToast("Deny")
        }
        
    }
    
    public static func fetchAlbumsCollections() ->  PHFetchResult<PHAssetCollection> {
        let userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        return userCollections
        
    }
    
    public static func fetchAllPhotos() -> PHFetchResult<PHAsset>{
        let fetchOptions = PHFetchOptions.init()
        fetchOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let allPhotos = PHAsset.fetchAssets(with: fetchOptions)
        return allPhotos
    }
    
    public static func fetchAllPhotosGPSInfo() -> [(PhotoMeta)] {
        let result = fetchAllPhotos()
        var gpsInfo: [PhotoMeta] = []
        for i in 0..<result.count {
            let asset: PHAsset = result.object(at: i)
            if asset.location == nil {
                continue
            }
            let meta = PhotoMeta.init(identifier: asset.localIdentifier, location: asset.location, time: asset.creationDate, type: asset.mediaType)
            gpsInfo.append(meta)
        }
        return gpsInfo
    }
    
    public static func handleDuplicatePhotos() -> [(PhotoMeta)]  {
        // use timestamp && location simliar
        let data = fetchAllPhotosGPSInfo()
        for (index, meta) in data.enumerated() {
            let photoMeta = meta
            for i in 1..<COMPARE_NUM {
                if (index + i) >= data.count {
                    continue
                }
                var compareMeta = data[index + i]
                let timeInterval = Int((compareMeta.time?.timeIntervalSince1970)! * 1000.0 ) - Int((photoMeta.time?.timeIntervalSince1970)! * 1000.0)
                if timeInterval < 5 * 1000 {
                    compareMeta.isSimilar = true
                }
                
            }
        }
        
        var indenpentPhoto: [PhotoMeta] = []
        for meta in data {
            if meta.isSimilar {
                continue
            }
            indenpentPhoto.append(meta)
        }
        
        return indenpentPhoto
        
    }

}
