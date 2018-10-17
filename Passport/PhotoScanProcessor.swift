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
    
    
    public static func getAuthorized(view :UIView) -> Void {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.authorized {
                    
                }else if status == PHAuthorizationStatus.denied {
                    view.makeToast("Deny")
                }
            }
        }else if authStatus == PHAuthorizationStatus.authorized {
            
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
    
    public static func fetchAllPhotosGPSInfo() -> [(String)] {
        
        
        return []
    }
    

}
