//
//  DateUtil.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

typealias TimeBlock = (_ time: String)->()

class DateUtil {

    public static func date2Str(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let ymd = dateFormatter.string(from: date)
        return ymd
    }
    
    public static func str2Date(string:String, dateFormat:String="yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    public static func increaseDate(_ date: String, _ block: @escaping TimeBlock){
        var birthStr = date
        birthStr.insert("-", at: String.Index.init(encodedOffset: 4))
        birthStr.insert("-", at: String.Index.init(encodedOffset: 7))
        birthStr = birthStr + " 00:00:00"
        let birth = stringConvertDate(string: birthStr)
        let now = birth.timeIntervalSinceNow
        let year =  -now / (365 * 24 * 60 * 60)
        let timeInterval = 0.0000001
        let yearStr = String(format:"%.7f", year)
        var trueYear = Double.init(yearStr)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            trueYear = trueYear! + timeInterval
            block(String(format:"%.7f", trueYear!))
        }
        return
    }
    
    static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    static func dateConvertString(date:Date, dateFormat:String="yyyy-MM-dd") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
}
