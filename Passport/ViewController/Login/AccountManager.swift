//
//  AccountManager.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/19.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation

class AccountManager: NSObject {
    @objc public static func saveUserId(_ userId: String?) {
        if let _ = userId {
            UserDefaults.standard.set(userId, forKey: "userid")
        }
    }
    
    @objc public static func getUserId() -> String? {
        return UserDefaults.standard.object(forKey: "userid") as? String
    }
    
    @objc public static func logout() {
        UserDefaults.standard.removeObject(forKey: "userid")
    }
}
