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
    ///有没有计划
    @objc dynamic var havePlan: Bool = false
    ///目标等级
    @objc dynamic var targetLevel: Int = -1
    ///目标时间
    @objc dynamic var targetDate: Date = Date()
    ///单词记忆量
    @objc dynamic var rememberWordsCount: Int = 0
}
