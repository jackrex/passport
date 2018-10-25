//
//  HttpApi.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit
import Alamofire



class HttpApi: NSObject {

    public static let HOST = "http://api.pre.gotokeep.com"
    public static let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    public static func login(_ phone: String, _ pwd: String, _ completion: @escaping (Data) -> ()) -> Void {
        
        let parms = ["mobile": phone, "password": pwd]
        Alamofire.request(HOST + "/box/hackday/login", method: .post, parameters: parms, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData { (response) in
            switch response.result {
            case .success:
                print(String.init(data: response.result.value!, encoding: String.Encoding.utf8)!)
                completion(response.result.value!)
                break
            case .failure(let error):
                print(error)
                SVProgressHUD.showInfo(withStatus: "登录出错,检查密码")
                break
                
            }
        }
    }
    
}
