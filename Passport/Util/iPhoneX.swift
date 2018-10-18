//
//  UIDevice+iPhoneX.swift
//  Keep
//
//  Created by 廖雷 on 2017/11/2.
//  Copyright © 2017年 Beijing Calorie Technology Co., Ltd. All rights reserved.
//

import UIKit

extension UIDevice {
    public var isX: Bool {
        return isIPhoneXSeries()
    }
}

struct SafeArea {
    static var iPhoneXInsets = UIEdgeInsets.init(top: 44, left: 0, bottom: 34, right: 0)
    
    struct prefered {
        static var bottom: CGFloat {
            return UIDevice.current.isX ? SafeArea.iPhoneXInsets.bottom : 0
        }
        static var top: CGFloat {
            return UIDevice.current.isX ? SafeArea.iPhoneXInsets.top : 0
        }
        static var topToStatusBar: CGFloat {
            return UIDevice.current.isX ? (SafeArea.iPhoneXInsets.top - 20) : 0
        }
    }
}
