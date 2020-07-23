//
//  SQLManager.swift
//  LearnJapanese
//  数据库管理对象
//  Created by 唐星宇 on 2020/7/23.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import SQLite

class SQLManager: NSObject {
    enum DataAccessError: Swift.Error {
        case datastoreConnectionError
        case insertError
        case deleteError
        case searchError
        case nilInData
        case nomoreData
    }
    
    static let data = Expression<String>("data")
    static let data2 = Expression<String>("data2")
    static let data3 = Expression<String>("data3")
    
    private static var _sharedInstance: SQLManager?
    let db: Connection?
    ///单词表
    let jcTable: Table = Table("jccard")
    
    /// 单例
    ///
    /// - Returns: 单例对象
    class func shared() -> SQLManager {
        guard let instance = _sharedInstance else {
            _sharedInstance = SQLManager()
            return _sharedInstance!
        }
        return instance
    }
    
    private override init() {
        guard let dir: String = Bundle.main.path(forResource: "db", ofType: "sqlite") else {
            db = nil
            return
        }
        print("The DB Path:", dir)
        
        do {
            db = try Connection.init(dir)
            db?.busyTimeout = 5
            db?.busyHandler({ tries in
                if tries >= 3 {
                    return false
                }
                return true
            })
        }catch _ {
            db = nil
        }
    } // 私有化init方法
    
    // MARK: 表操作
    
    // MARK: 单词表相关操作
    
    ///查询所有的单词
    static func queryAllWords() -> [wordModel]? {
        var wordArray: [wordModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().jcTable){
                for item in items {
                    let model: wordModel = wordModel()
                    model.japanese = item[data]
                    model.pronunciation = item[data2]
                    model.chinese = item[data3]
                    wordArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return wordArray
    }
    
    ///插入单词
    static func insertWord(_ model: wordModel) -> Int64 {
        do {
            let db = SQLManager.shared().db
            let insert = SQLManager.shared().jcTable.insert(data <- model.japanese, data2 <- model.pronunciation, data3 <- model.chinese)
            let rowId = try db?.run(insert) ?? -1
            return Int64(rowId)
        } catch _ {
            Dprint("数据库查询失败")
        }
        return -1
    }
    
    ///单词模糊查询
    static func queryWordsByString(_ str: String) -> [wordModel]? {
        var wordArray: [wordModel] = []
        let patternStr: String = "%\(str)%"
        do {
            let db = SQLManager.shared().db
            let query = SQLManager.shared().jcTable.filter(data.like(patternStr) || data2.like(patternStr) || data3.like(patternStr))
            if let items = try db?.prepare(query){
                for item in items {
                    let model: wordModel = wordModel()
                    model.japanese = item[data]
                    model.pronunciation = item[data2]
                    model.chinese = item[data3]
                    wordArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return wordArray
    }
    
    
}
