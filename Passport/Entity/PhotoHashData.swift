//
//  PhotoHashData.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

class PhotoHashData: NSObject {
    
    public var geoHash: String?
    public var photosMeta: [PhotoMeta] = []
    
    override init() {
        
    }
    
    func toString() -> String {
        return "\(String(describing: geoHash!)), \(photosMeta.count), \(getDateCount()), \(randomLocation().coordinate.longitude), \(randomLocation().coordinate.latitude)"
    }
    
    func getDateCount() -> Int {
        var dateList:[String] = []
        for photoMeta in photosMeta {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let ymd = dateFormatter.string(from: photoMeta.time!)
            if !dateList.contains(ymd) {
                dateList.append(ymd)
            }
        }
        return dateList.count
    }
    
    func randomLocation() -> CLLocation {
        let random = Int.random(in: 0..<photosMeta.count)
        let photoMeta = photosMeta[random]
        return photoMeta.location!
    }
}
