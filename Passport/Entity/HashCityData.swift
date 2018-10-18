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
    var city: String
    var country: String
    var cnCity: String
    var cnCountry: String
    var iso2: String
}

struct HashCity: Decodable {
    var data: [HashCityData]
}
