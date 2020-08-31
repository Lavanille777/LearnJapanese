//
//  ArticalModel.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/31.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import SQLite

class ArticleModel: NSObject {
    ///文章id
    @objc dynamic var id: Int = 0
    ///标题
    @objc dynamic var title: String = ""
    ///图片
    @objc dynamic var img1: String = ""
    ///文本1
    @objc dynamic var text1: String = ""
    ///图片2
    @objc dynamic var img2: String = ""
    ///文本2
    @objc dynamic var text2: String = ""
    
    ///单词表参数
    static let id = Expression<Int>("id")
    static let title = Expression<String>("title")
    static let img1 = Expression<String>("img1")
    static let text1 = Expression<String>("text1")
    static let img2 = Expression<String>("img2")
    static let text2 = Expression<String>("text2")
    
    class func getData(fromRow row: Row) -> ArticleModel{
        let model = ArticleModel()
        model.id = row[id]
        model.title = row[title]
        model.img1 = row[img1]
        model.text1 = row[text1]
        model.img2 = row[img2]
        model.text2 = row[text2]

        return model
    }
}
