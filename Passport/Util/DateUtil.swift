//
//  DateUtil.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

class DateUtil {

    public static func date2Str(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let ymd = dateFormatter.string(from: date)
        return ymd
    }
    
}
