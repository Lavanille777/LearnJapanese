//
//  CoordinatePointModel.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/12/1.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class CoordinatePointModel: NSObject {
    
    var xVal: String = ""
    
    var yVal: CGFloat = 0.0
    
    private override init() {
        super.init()
    }
    
    init(withXVal xVal: String) {
        super.init()
        self.xVal = xVal
    }
}
