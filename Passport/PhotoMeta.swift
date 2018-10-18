//
//  PhotoMeta.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

struct PhotoMeta {
    public var identifier: String
    public var location: CLLocation?
    public var time: Date?
    public var type: PHAssetMediaType
    public var isSimilar: Bool
    public var asset: PHAsset?
 
    init(identifier: String, location: CLLocation?, time: Date?, type: PHAssetMediaType) {
        self.identifier = identifier
        self.location = location
        self.time = time
        self.type = type
        isSimilar = false
    }
    
    
}
