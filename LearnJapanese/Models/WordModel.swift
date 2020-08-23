//
//  wordModel.swift
//  LearnJapanese
//  单词模型
//  Created by 唐星宇 on 2020/7/23.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import SQLite

class WordModel: NSObject {
    ///单词id
    @objc dynamic var id: Int = 0
    ///日语单词
    @objc dynamic var japanese: String = ""
    ///假名
    @objc dynamic var pronunciation: String = ""
    ///罗马音
    @objc dynamic var rome: String = ""
    ///中文释义
    @objc dynamic var chinese: String = ""
    ///是否记住
    @objc dynamic var isRemembered: Bool = false
    ///书签
    @objc dynamic var bookMark: Bool = false
    ///错误标签
    @objc dynamic var wrongMark: Bool = false
    
    ///单词表参数
    static let id = Expression<Int>("id")
    static let data = Expression<String>("data")
    static let data2 = Expression<String>("data2")
    static let data3 = Expression<String>("data3")
    static let rome = Expression<String>("rome")
    static let isRemembered = Expression<Bool>("isRemembered")
    static let bookmark = Expression<Bool>("bookmark")
    static let wrongmark = Expression<Bool>("wrongmark")
    
    class func getData(fromRow row: Row) -> WordModel{
        let model = WordModel()
        model.id = row[id]
        model.japanese = row[data]
        model.pronunciation = row[data2]
        model.chinese = row[data3]
        model.isRemembered = row[isRemembered]
        model.bookMark = row[bookmark]
        model.wrongMark = row[wrongmark]
//        if row[rome] == "1" {
//            var str = ""
//            for (index, c) in model.pronunciation.enumerated(){
//                str.append((SQLManager.queryRome(byKana: String(c)) ?? ""))
//            }
//            model.rome = str
//            SQLManager.updateWord(model)
//        }else{
            model.rome = row[rome]
//        }
        return model
    }
}
