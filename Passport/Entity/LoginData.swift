//
//  LoginData.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

struct LoginData: Decodable {

//    var id: String?
//    var username: String
//    var avatar: String
//    var birthday: CLongLong
//    var cityCode: String?
    var level: Int
    var goal: Int
    var gender: String
    var token: String?
}

struct Login: Decodable {
    var errorCode: String
    var data: LoginData
}
