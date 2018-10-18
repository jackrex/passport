//
//  ResourceUtil.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

class ResourceUtil: NSObject {

    public static func loginSB() -> UIStoryboard {
        return UIStoryboard.init(name: "LoginView", bundle: nil)
    }
    
    public static func mainSB() -> UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
}
