//
//  LJCoordinatePointModel.swift
//  LJCoordinate
//
//  Created by 唐星宇 on 2020/12/1.
//

import UIKit

class LJCoordinatePointModel: NSObject {

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
