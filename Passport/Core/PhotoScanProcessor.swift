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
    
    public static let COMPARE_NUM = 5
    public static let DUP_INTERVAL = 0.7 //use time filter
    public static let GEOHASH_LENGTH = 100
    
    public static func getAuthorized(view :UIView) -> [(PhotoMeta)] {
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
            return photos
        }else {
            view.makeToast("Deny")
        }
        return []
        
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
            var meta = PhotoMeta.init(identifier: asset.localIdentifier, location: asset.location, time: asset.creationDate, type: asset.mediaType)
            meta.asset = asset
            gpsInfo.append(meta)
        }
        return gpsInfo
    }
    
    public static func handleDuplicatePhotos() -> [(PhotoMeta)]  {
        // use timestamp && location simliar
        let data = fetchAllPhotosGPSInfo()
        var dupIds: [String] = []
        for (index, meta) in data.enumerated() {
            let photoMeta = meta
            for i in 1..<COMPARE_NUM {
                if (index + i) >= data.count {
                    continue
                }
                let compareMeta = data[index + i]
                let timeInterval = Int((compareMeta.time?.timeIntervalSince1970)! * 1000.0 ) - Int((photoMeta.time?.timeIntervalSince1970)! * 1000.0)
                if timeInterval < Int(DUP_INTERVAL * 1000.0) {
                    dupIds.append(compareMeta.identifier)
                }
                
            }
        }
        
        var indenpentPhoto: [PhotoMeta] = []
        for meta in data {
            if !dupIds.contains(meta.identifier) {
                indenpentPhoto.append(meta)
                // print long,lat,date
//                print("\(String(describing: meta.location!.coordinate.longitude)),\(String(describing: meta.location!.coordinate.latitude)),\(String(describing: meta.asset!.creationDate!))")
            }
        }
        
        return indenpentPhoto
        
    }
    
    public static func getHashList() -> [(String)] {
        var geoHashList:[String] = []
        var hashDict: [String: PhotoHashData] = [:]
        let photos = handleDuplicatePhotos()
        for photo in photos {
            let hash = Geohash.encode(latitude: (photo.location?.coordinate.latitude)!, longitude: (photo.location?.coordinate.longitude)!, precision: Geohash.Precision.twentyKilometers)

            print("\(DateUtil.date2Str(date: photo.time!)),\(hash)")
            
            if hashDict[hash] == nil {
                let photoHashData = PhotoHashData()
                photoHashData.photosMeta.append(photo)
                photoHashData.geoHash = hash
                hashDict.updateValue(photoHashData, forKey: hash)
            }else {
                let photoHashData = hashDict[hash]
                photoHashData?.photosMeta.append(photo)
                hashDict.updateValue(photoHashData!, forKey: hash)
            }
            
            if !geoHashList.contains(hash) {
                geoHashList.append(hash)
            }
            
        }
        
        //TODO print data
        //geolist totalcount daystotalcount randomPicPos
//        for dict in hashDict {
//            print(dict.value.toString())
//        }

        return geoHashList
    }

}
