//
//  HashCityData.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import Foundation

struct HashCityData: Decodable {
    
    var hash: String
    var flag: String
}

struct HashCity: Decodable {
    var data: [HashCityData]
}
