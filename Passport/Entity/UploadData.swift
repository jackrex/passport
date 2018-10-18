//
//  UploadData.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import Foundation

struct UploadData: Codable {
    
    var date: String
    var hashList: [String]
    
    init(_ date: String, _ hashList: [String]) {
        self.date = date
        self.hashList = hashList
    }

}

struct Upload: Codable {
    var errorCode: Int
    var data: [UploadData]
    
    init(_ errorCode: Int, _ data: [UploadData]) {
        self.errorCode = errorCode
        self.data = data
    }
}
