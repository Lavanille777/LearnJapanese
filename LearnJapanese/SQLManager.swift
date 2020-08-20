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
    
    ///用户表
    let userTable: Table = Table("users")
    ///用户表参数
    ///用户Id
    static let id = Expression<Int>("id")
    ///用户名
    static let userName = Expression<String>("userName")
    ///用户头像
    static let avatarURL = Expression<String>("avatarURL")
    ///有没有计划
    static let havePlan = Expression<Bool>("havePlan")
    ///目标等级
    static let targetLevel = Expression<Int>("targetLevel")
    ///目标时间
    static let targetDate = Expression<Date>("targetDate")
    ///确定目标日期
    static let ensureTargetDate = Expression<Date>("ensureTargetDate")
    ///单词记忆量
    static let rememberWordsCount = Expression<Int>("rememberWordsCount")
    ///登录时间
    static let loginDate = Expression<Date>("loginDate")
    ///单词记忆量
    static let todayWordsCount = Expression<Int>("todayWordsCount")
    ///假名表
    let pronunciation: Table = Table("pronunciation")
    
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
                    let model: WordModel = WordModel.getData(fromRow: item)
                    wordArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return wordArray
    }
    ///查询未记词
    static func queryAllUnrememberedWord() -> [WordModel]? {
        var wordArray: [WordModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().jcTable.filter(!WordModel.isRemembered)){
                for item in items {
                    let model: WordModel = WordModel.getData(fromRow: item)
                    wordArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return wordArray
    }
    ///查询已记词
    static func queryAllRememberedWord() -> [WordModel]? {
        var wordArray: [WordModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().jcTable.filter(WordModel.isRemembered)){
                for item in items {
                    let model: WordModel = WordModel.getData(fromRow: item)
                    wordArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return wordArray
    }
    
    ///查询收藏夹词汇
    static func queryBookMarkWord() -> [WordModel]? {
        var wordArray: [WordModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().jcTable.filter(WordModel.bookmark)){
                for item in items {
                    let model: WordModel = WordModel.getData(fromRow: item)
                    wordArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return wordArray
    }
    
    ///查询错词本词汇
    static func queryWrongMarkWord() -> [WordModel]? {
        var wordArray: [WordModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().jcTable.filter(WordModel.wrongmark)){
                for item in items {
                    let model: WordModel = WordModel.getData(fromRow: item)
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
            let insert = SQLManager.shared().jcTable.insert(WordModel.data <- model.japanese, WordModel.data2 <- model.pronunciation, WordModel.data3 <- model.chinese)
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
            let query = SQLManager.shared().jcTable.filter(WordModel.data.like(patternStr) || WordModel.data2.like(patternStr) || WordModel.data3.like(patternStr))
            if let items = try db?.prepare(query){
                for item in items {
                    let model: WordModel = WordModel.getData(fromRow: item)
                    wordArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return wordArray
    }
    
    ///更新单词
    static func updateWord(_ model: WordModel) -> Bool {
        do {
            let db = SQLManager.shared().db
            let update = SQLManager.shared().jcTable.filter(id == model.id).update(WordModel.data <- model.japanese, WordModel.data2 <- model.pronunciation, WordModel.data3 <- model.chinese, WordModel.isRemembered <- model.isRemembered,  WordModel.bookmark <- model.bookMark, WordModel.wrongmark <- model.wrongMark)
            if let rowId = try db?.run(update){
                return rowId > 0
            }
        } catch _ {
            Dprint("数据库更新失败")
        }
        return false
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
                    model.avatarURL = item[avatarURL]
                    model.havePlan = item[havePlan]
                    model.targetLevel = item[targetLevel]
                    model.targetDate = item[targetDate]
                    model.rememberWordsCount = item[rememberWordsCount]
                    model.todayWordsCount = item[todayWordsCount]
                    model.loginDate = item[loginDate]
                    model.ensureTargetDate = item[ensureTargetDate]
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
            let update = SQLManager.shared().userTable.filter(id == model.id).update(userName <- model.userName, havePlan <- model.havePlan, targetLevel <- model.targetLevel, targetDate <- model.targetDate, rememberWordsCount <- model.rememberWordsCount, loginDate <- model.loginDate, todayWordsCount <- model.todayWordsCount, ensureTargetDate <- model.ensureTargetDate, avatarURL <- model.avatarURL)
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
                    model.avatarURL = item[avatarURL]
                    model.havePlan = item[havePlan]
                    model.targetLevel = item[targetLevel]
                    model.targetDate = item[targetDate]
                    model.rememberWordsCount = item[rememberWordsCount]
                    model.loginDate = item[loginDate]
                    model.todayWordsCount = item[todayWordsCount]
                    model.ensureTargetDate = item[ensureTargetDate]
                    userArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库更新失败")
        }
        return userArray.first
    }
    
    //MARK: 假名表相关操作
    static func queryPronunciation(byCategory category: Int) -> [PronunciationModel]? {
        var pronunciationArray: [PronunciationModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().pronunciation.filter(PronunciationModel.category == category && PronunciationModel.type != 0)){
                for item in items {
                    let model: PronunciationModel = PronunciationModel.getData(fromRow: item)
                    pronunciationArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return pronunciationArray
    }
    
    static func queryPronunciationColumn(byCategory category: Int) -> [PronunciationModel]? {
        var pronunciationArray: [PronunciationModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().pronunciation.filter(PronunciationModel.category == category && PronunciationModel.type == 0)){
                for item in items {
                    let model: PronunciationModel = PronunciationModel.getData(fromRow: item)
                    model.isEmpty = true
                    pronunciationArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return pronunciationArray
    }
    
    
    
}
