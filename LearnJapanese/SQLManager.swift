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
    
    private static var _sharedInstance: SQLManager?
    let db: Connection?
    
    ///单词表
    let jcTable: Table = Table("jccard")
    ///单词表参数
    static let data = Expression<String>("data")
    static let data2 = Expression<String>("data2")
    static let data3 = Expression<String>("data3")
    
    ///用户表
    let userTable: Table = Table("users")
    ///用户表参数
    ///用户Id
    static let id = Expression<Int>("id")
    ///用户名
    static let userName = Expression<String>("userName")
    ///有没有计划
    static let havePlan = Expression<Bool>("havePlan")
    ///目标等级
    static let targetLevel = Expression<Int>("targetLevel")
    ///目标时间
    static let targetDate = Expression<Date>("targetDate")
    ///单词记忆量
    static let rememberWordsCount = Expression<Int>("rememberWordsCount")
    
    /// 单例
    ///
    /// - Returns: 单例对象
    class func shared() -> SQLManager {
        guard let instance = _sharedInstance else {
            _sharedInstance = SQLManager()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return _sharedInstance!
        }
        return instance
    }
    
    private override init() {
        guard let docPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last, let bundleSqlPath = Bundle.main.path(forResource: "db", ofType: ".sqlite") else {
            db = nil
            return
        }
        
        print("The DB Path:", docPath)
        let dir = docPath + "/db.sqlite"
        
        if !FileManager.default.fileExists(atPath: dir){
            try? FileManager.default.copyItem(atPath: bundleSqlPath, toPath: dir)
        }
        
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
    static func queryAllWords() -> [WordModel]? {
        var wordArray: [WordModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().jcTable){
                for item in items {
                    let model: WordModel = WordModel()
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
    static func insertWord(_ model: WordModel) -> Int64 {
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
    static func queryWordsByString(_ str: String) -> [WordModel]? {
        var wordArray: [WordModel] = []
        let patternStr: String = "%\(str)%"
        do {
            let db = SQLManager.shared().db
            let query = SQLManager.shared().jcTable.filter(data.like(patternStr) || data2.like(patternStr) || data3.like(patternStr))
            if let items = try db?.prepare(query){
                for item in items {
                    let model: WordModel = WordModel()
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
    
    // MARK: 用户表相关操作
    static func queryAllUsers() -> [UserModel]? {
        var userArray: [UserModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().userTable){
                for item in items {
                    let model: UserModel = UserModel()
                    model.id = item[id]
                    model.userName = item[userName]
                    model.havePlan = item[havePlan]
                    model.targetLevel = item[targetLevel]
                    model.targetDate = item[targetDate]
                    model.rememberWordsCount = item[rememberWordsCount]
                    userArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return userArray
    }
    
    static func updateUser(_ model: UserModel) -> Bool {
        do {
            let db = SQLManager.shared().db
            let update = SQLManager.shared().userTable.filter(id == model.id).update(userName <- model.userName, havePlan <- model.havePlan, targetLevel <- model.targetLevel, targetDate <- model.targetDate, rememberWordsCount <- model.rememberWordsCount)
            if let rowId = try db?.run(update){
                return rowId > 0
            }
        } catch _ {
            Dprint("数据库更新失败")
        }
        return false
    }
    
    static func queryUserById(_ userId: Int) -> UserModel? {
        var userArray: [UserModel] = []
        do {
            let db = SQLManager.shared().db
            let query = SQLManager.shared().userTable.filter(id == userId)
            if let items =  try db?.prepare(query){
                for item in items {
                    let model: UserModel = UserModel()
                    model.id = item[id]
                    model.userName = item[userName]
                    model.havePlan = item[havePlan]
                    model.targetLevel = item[targetLevel]
                    model.targetDate = item[targetDate]
                    model.rememberWordsCount = item[rememberWordsCount]
                    userArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库更新失败")
        }
        return userArray.first
    }
    
    
    
}