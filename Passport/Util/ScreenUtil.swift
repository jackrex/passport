//
//  ScreenUtil.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

class ScreenUtil: NSObject {
    
    public static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
