//
//  wordModel.swift
//  LearnJapanese
//  单词模型
//  Created by 唐星宇 on 2020/7/23.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class wordModel: NSObject {
    ///日语单词
    @objc dynamic var japanese: String = ""
    ///罗马音
    @objc dynamic var pronunciation: String = ""
    ///中文释义
    @objc dynamic var chinese: String = ""
    
}
