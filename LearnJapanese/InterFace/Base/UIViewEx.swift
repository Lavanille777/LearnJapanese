//
//  UIViewEx.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/7.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

extension UIView {

    /// 添加渐变层
    ///
    /// - Parameters:
    ///   - colors: 渐变色值
    ///   - locations: 颜色所在位置(默认开始结束处)
    ///   - isHor: 是否是横向渐变(默认竖向)
    /// - Returns: 渐变层
    @discardableResult func addGradientLayer(colors: [CGColor], locations: [NSNumber] = [0.0, 1.0], isHor: Bool = false) -> CAGradientLayer {
        let graLayer = CAGradientLayer()
        graLayer.frame = self.bounds
        graLayer.backgroundColor = UIColor.clear.cgColor
        graLayer.colors = colors //设置渐变色
        graLayer.locations = locations
        if isHor{ //设置横向渐变
            graLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)  //默认.5,0
            graLayer.endPoint = CGPoint.init(x: 1.0, y: 0.0)  //默认.5,1
        }
        self.layer.insertSublayer(graLayer, at: 0)
        return graLayer
    }

}
