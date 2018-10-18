//
//  LoginData.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

struct LoginData: Decodable {

    var id: String
    var username: String
    var avatar: String
    var birthday: CLongLong
    var cityCode: String
    var gender: String
}

struct Login: Decodable {
    var errorCode: Int
    var text: String
    var data: LoginData
}
