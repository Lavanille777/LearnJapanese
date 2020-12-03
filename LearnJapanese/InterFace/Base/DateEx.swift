//
//  DateEx.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/11/27.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

extension Date {
    
    static func correctToDay() -> Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        guard let newDate = dateFormatter.date(from: dateFormatter.string(from: date)) else { return date }
        return newDate
    }
    
    func getCorrectDay() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        guard let newDate = dateFormatter.date(from: dateFormatter.string(from: self)) else { return self }
        return newDate
    }
    
}

