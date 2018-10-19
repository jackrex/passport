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

typealias ClosureBlock = ()->()
typealias ImageBlock = (_ image: UIImage?) -> ()

@objc class PhotoScanProcessor: NSObject {
    
    public static let COMPARE_NUM = 5
    public static let DUP_INTERVAL = 0.7 //use time filter
    public static let GEOHASH_LENGTH = 100
    
    public static var allPhotos:[(PhotoMeta)] = []
    
    public static func getAuthorized(view :UIView, _ block: @escaping ClosureBlock) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.authorized {
                    block()
                }else if status == PHAuthorizationStatus.denied {
                    view.makeToast("Deny and Can not Use")
                }
            }
        }else if authStatus == PHAuthorizationStatus.authorized {
                 block()
        }else {
            view.makeToast("Deny and Can not Use")
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
        let screenShotWidths = [200, 272, 312,320, 640, 750, 1242, 1536, 2048, 1668, 768, 826, 1125, 1242]

        for i in 0..<result.count {
            let asset: PHAsset = result.object(at: i)
            if asset.location == nil {
                continue
            }
            
            //filter screenshots
            if asset.mediaSubtypes == .photoScreenshot {
                continue
            }
            
            // remove litte pixel
            if asset.pixelWidth < 200 {
                continue
            }
            
            // remove screenshots
            if screenShotWidths.contains(asset.pixelWidth){
                continue
            }
            
            var meta = PhotoMeta.init(identifier: asset.localIdentifier, location: asset.location, time: asset.creationDate, type: asset.mediaType)
            meta.asset = asset
            gpsInfo.append(meta)
        }
        return gpsInfo
    }
    
    public static func handleDuplicatePhotos() -> [(PhotoMeta)]  {
        
        guard allPhotos.count <= 0 else {
            return allPhotos
        }
        
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
                
                // filter dup pic
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
        
        
        // speed remove
        var index = 0
        dupIds.removeAll()
        var standMeta: PhotoMeta = indenpentPhoto[0]
        for photo in indenpentPhoto {
            if (index + 1 < data.count) {
                let nextPhotoMeta = data[index + 1]
                let interval = nextPhotoMeta.time?.timeIntervalSince(standMeta.time!)
                let distance = nextPhotoMeta.location?.distance(from: standMeta.location!)
                let speed = distance! / interval!
                if speed > 200{
                    dupIds.append(nextPhotoMeta.identifier)
                }else {
                    standMeta = photo
                }
            }
            index = index + 1
        }
        
        
        var resultPhoto: [PhotoMeta] = []
        for meta in indenpentPhoto {
            if !dupIds.contains(meta.identifier) {
                resultPhoto.append(meta)
            }
        }
        
        return resultPhoto
        
    }
    
    public static func getHashList() -> [(String)] {
        var geoHashList:[String] = []
        var hashDict: [String: PhotoHashData] = [:]
        let photos = handleDuplicatePhotos()
        for photo in photos {
            let hash = Geohash.encode(latitude: (photo.location?.coordinate.latitude)!, longitude: (photo.location?.coordinate.longitude)!, precision: Geohash.Precision.twentyKilometers)

            //print("\(DateUtil.date2Str(date: photo.time!)),\(hash)")
            
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

    public static func getDatePhotos() -> [String: [PhotoMeta]] {
        let photos = handleDuplicatePhotos()
        var dateDict: [String: [PhotoMeta]] = [:]
        for photo in photos {
            let key: String = DateUtil.date2Str(date: photo.time!)
            if dateDict[key] == nil {
                var metas:[PhotoMeta] = []
                metas.append(photo)
                dateDict.updateValue(metas, forKey: key)
            }else {
                var metas:[PhotoMeta] = dateDict[key]!
                metas.append(photo)
                dateDict.updateValue(metas, forKey: key)
            }
        }
        return dateDict
    }
    
    @objc public static func getPicFromDate (_ date: Date, _ location: CLLocation) -> [PHAsset]? {
        let dict = getDatePhotos()
        let metas = dict[DateUtil.date2Str(date: date)]
        var assets:[PHAsset] = []
        
        var hashArray:[String] = []
        
        for meta in metas ?? [] {
            if let metaLocation = meta.location {
                if metaLocation.distance(from: location) < 30 * 1000 {
                    let hash = meta.asset?.location?.coordinate.geohash(precision:  Geohash.Precision.twentyFourHundredMeters)
                    if hashArray.contains(hash!) == false {
                        assets.append(meta.asset!)
                        hashArray.append(hash!)
                    }
                }
            }
            
        }
        return assets
        
    }
    
    public static func getRandomPhoto(_ date: Date, block: @escaping ImageBlock) {
        let dict = getDatePhotos()
        let metas = dict[DateUtil.date2Str(date: date)]
        
        if metas == nil {
            block(nil)
            return
        }
        
        if (metas?.count)! <= 0 {
            //TODO fix that
            block(nil)
            return
        }
        
        let asset = metas![Int.random(in: 0..<metas!.count)].asset
        
        let scale = UIScreen.main.scale
        let dimension = CGFloat(200.0)
        let size = CGSize(width: dimension * scale, height: dimension * scale)
        
        
        MMAssetService.shared()?.requestImage(with: asset!, maxSize: size, handler: { (code, image, model) in
            block(image!)
            }, progress: { (aa, err,c, a) in
                
        })
        

    }
    
    @objc public static func generateJSON() -> NSDictionary? {
        let datePhotos = getDatePhotos()
        var uploadList:[UploadData] = []
        var upload: Upload = Upload.init(0, uploadList)
        for (date, metas) in datePhotos {
            var hashList: [String] = []
            var hashDateList: [Double: String] = [:]
            for meta in metas {
                let hash = Geohash.encode(latitude: (meta.location?.coordinate.latitude)!, longitude: (meta.location?.coordinate.longitude)!, precision: Geohash.Precision.twentyKilometers)
                
                if !hashList.contains(hash) {
                    hashList.append(hash)
                    hashDateList.updateValue(hash, forKey: meta.time!.timeIntervalSince1970)
                }
            }
            
            let keys = hashDateList.keys
            let result = keys.sorted()
            hashList.removeAll()
            for timestamp in result {
                hashList.append(hashDateList[timestamp]!)
            }
            let uploadData = UploadData.init(date, hashList)
            uploadList.append(uploadData)
            
        }
        upload.data = uploadList
        let encoder = JSONEncoder()
        let encodedUserData = try? encoder.encode(upload)
        let userDict = try? JSONSerialization.jsonObject(with: encodedUserData!, options: .mutableContainers) as! NSDictionary
        return userDict
    }
    
    
    static func exifInfo(_ asset: PHAsset) -> Void {
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true //download asset metadata from iCloud if needed
        asset.requestContentEditingInput(with: options) { (contentEditingInput: PHContentEditingInput?, _) -> Void in
            let fullImage = CIImage(contentsOf: contentEditingInput!.fullSizeImageURL!)
            print(fullImage!.properties)
        }
    }
}
