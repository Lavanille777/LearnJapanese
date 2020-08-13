//
//  UserModel.swift
//  LearnJapanese
//  用户模型
//  Created by 唐星宇 on 2020/7/24.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    ///用户Id
    @objc dynamic var id: Int = 0
    ///用户名
    @objc dynamic var userName: String = ""
    ///用户头像
    @objc dynamic var avatarURL: String = ""
    ///有没有计划
    @objc dynamic var havePlan: Bool = false
    ///目标等级
    @objc dynamic var targetLevel: Int = -1
    ///目标时间
    @objc dynamic var targetDate: Date = Date()
    ///确定目标日期
    @objc dynamic var ensureTargetDate: Date = Date()
    ///单词记忆量
    @objc dynamic var rememberWordsCount: Int = 0
    ///登录日期
    @objc dynamic var loginDate: Date = Date()
    ///今日单词记忆量
    @objc dynamic var todayWordsCount: Int = 0
    ///单词总量
    var wordsCount: Int{
        get{
            return (8 - targetLevel) * 1000
        }
    }
    ///平均每日单词记忆量
    var averageWordsCount: Int{
        get{
            return (wordsCount / Int((targetDate.timeIntervalSince1970 - ensureTargetDate.timeIntervalSince1970) / 86400))
        }
    }
}
