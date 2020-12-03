//
//  RecordModel.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/11/27.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import SQLite

class RecordModel: NSObject {
    ///id
    @objc dynamic var id: Int = 1
    ///记忆量
    @objc dynamic var recordNum: Int = 0
    ///日期
    @objc dynamic var date: Date = Date.correctToDay()
    
    ///记忆量表参数
    static let id = Expression<Int>("id")
    static let recordNum = Expression<Int>("recordNum")
    static let date = Expression<Date>("date")
    
    class func getData(fromRow row: Row) -> RecordModel{
        let model = RecordModel()
        model.id = row[id]
        model.recordNum = row[recordNum]
        model.date = row[date]
        return model
    }
}
