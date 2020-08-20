//
//  PronunciationModel.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/19.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import SQLite

class PronunciationModel: NSObject {
    ///单词id
    @objc dynamic var id: Int = 0
    ///平假名
    @objc dynamic var hiragana: String = ""
    ///片假名
    @objc dynamic var katakana: String = ""
    ///罗马音
    @objc dynamic var rome: String = ""
    ///类别 -1 清音 -2 浊音 -3 拗音
    @objc dynamic var category: Int = 0
    
    var isEmpty: Bool = false

    ///单词表参数
    static let id = Expression<Int>("id")
    static let hiragana = Expression<String>("hiragana")
    static let katakana = Expression<String>("katakana")
    static let rome = Expression<String>("rome")
    static let category = Expression<Int>("category")
    static let type = Expression<Int>("type")
    
    class func getData(fromRow row: Row) -> PronunciationModel{
        let model = PronunciationModel()
        
        model.id = row[id]
        model.hiragana = row[hiragana]
        model.katakana = row[katakana]
        model.rome = row[rome]
        model.category = row[category]
        
        return model
    }
}
