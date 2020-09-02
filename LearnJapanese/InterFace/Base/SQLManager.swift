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
    
    private static var _sharedInstance: SQLManager?
    let db: Connection?
    
    ///单词表
    let jcTable: Table = Table("jccard")
    ///用户表
    let userTable: Table = Table("users")
    ///文章表
    let articleTable: Table = Table("article")
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
    
    static func refreshWordTable(){
        guard let docPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else {
            return
        }
        
        print("The DB Path:", docPath)
        let dir = docPath + "/db.sqlite"
        do {
            try FileManager.default.removeItem(atPath: dir)
        }catch let err{
            print(err)
        }
        
        _sharedInstance = SQLManager()
        
        SQLManager.updateUser(userInfo)
    }
    
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
    
    ///查询已记的汉字词汇
    static func queryAllRememberedKanjiWord() -> [WordModel]? {
        var wordArray: [WordModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().jcTable.filter(WordModel.isRemembered || WordModel.data != WordModel.data2)){
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
            let query = SQLManager.shared().jcTable.filter(WordModel.data.like(patternStr) || WordModel.data2.like(patternStr) || WordModel.data3.like(patternStr) || WordModel.rome.like(patternStr)).limit(50).order(WordModel.rome.length)
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
            let update = SQLManager.shared().jcTable.filter(WordModel.id == model.id).update(WordModel.data <- model.japanese, WordModel.data2 <- model.pronunciation, WordModel.data3 <- model.chinese, WordModel.isRemembered <- model.isRemembered,  WordModel.bookmark <- model.bookMark, WordModel.wrongmark <- model.wrongMark, WordModel.rome <- model.rome)
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
                    let model: UserModel = UserModel.getData(fromRow: item)
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
            let update = SQLManager.shared().userTable.filter(UserModel.id == model.id).update(UserModel.userName <- model.userName, UserModel.havePlan <- model.havePlan, UserModel.targetLevel <- model.targetLevel, UserModel.targetDate <- model.targetDate, UserModel.rememberWordsCount <- model.rememberWordsCount, UserModel.loginDate <- model.loginDate, UserModel.todayWordsCount <- model.todayWordsCount, UserModel.ensureTargetDate <- model.ensureTargetDate, UserModel.avatarURL <- model.avatarURL)
            if let rowId = try db?.run(update){
                return rowId > 0
            }
        } catch let err {
            Dprint("\(err)数据库更新失败")
        }
        return false
    }
    
    static func queryUserById(_ userId: Int) -> UserModel? {
        var userArray: [UserModel] = []
        do {
            let db = SQLManager.shared().db
            let query = SQLManager.shared().userTable.filter(UserModel.id == userId)
            if let items =  try db?.prepare(query){
                for item in items {
                    let model: UserModel = UserModel.getData(fromRow: item)
                    userArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库更新失败")
        }
        return userArray.first
    }
    
    //MARK: 假名表相关操作
    static func queryRome(byKana kana: String) -> String? {
        var pronunciationArray: [PronunciationModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().pronunciation.filter(PronunciationModel.hiragana == kana || PronunciationModel.katakana == kana)){
                for item in items {
                    let model: PronunciationModel = PronunciationModel.getData(fromRow: item)
                    pronunciationArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return pronunciationArray.first?.rome
    }
    
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
    
    //MARK: 文章表
    
    static func queryAllArticals() -> [ArticleModel]? {
        var articleArray: [ArticleModel] = []
        do {
            let db = SQLManager.shared().db
            if let items = try db?.prepare(SQLManager.shared().articleTable){
                for item in items {
                    let model: ArticleModel = ArticleModel.getData(fromRow: item)
                    articleArray.append(model)
                }
            }
        } catch _ {
            Dprint("数据库查询失败")
        }
        return articleArray
    }
    
    
}
