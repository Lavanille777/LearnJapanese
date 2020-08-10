//
//  LJCycleProgressView.swift
//  LearnJapanese
//  环形进度条
//  Created by 唐星宇 on 2020/7/27.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJCycleProgressView: UIView {
    
    var radious: CGFloat = 0
    var ringWidth : CGFloat = 0
    var trackColor : UIColor = .black
    var progressColor : UIColor = .white
    var progressStartColor : UIColor = .white
    var progressEndColor: UIColor = .black
    var progressStart : CGFloat = 0
    var progressEnd : CGFloat = 0
    var isGrandient: Bool = false
    private let progressLayer = CAShapeLayer()
    private let progressGradientLayer = CAGradientLayer()
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    init(withWidth width: CGFloat, radious: CGFloat, trackColor: UIColor, progressColor: UIColor) {
        super.init(frame: .zero)
        self.radious = radious
        self.ringWidth = width
        self.trackColor = trackColor
        self.progressColor = progressColor
    }
    
    init(withWidth width: CGFloat, radious: CGFloat, trackColor: UIColor, progressStartColor: UIColor, progressEndColor: UIColor) {
        super.init(frame: .zero)
        self.radious = radious
        self.isGrandient = true
        self.ringWidth = width
        self.trackColor = trackColor
        self.progressStartColor = progressStartColor
        self.progressEndColor = progressEndColor
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupUI()
    }
    
    func setupUI(){
        if let layers = layer.sublayers{
            for layer in layers{
                layer.removeFromSuperlayer()
            }
        }
        
        let bezierPath = UIBezierPath.init(arcCenter: CGPoint(x: radious, y: radious), radius: radious - ringWidth, startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        let path = bezierPath.cgPath
        let tracklayer = CAShapeLayer()
        tracklayer.frame = CGRect(x: 0, y: 0, width: radious * 2, height: radious * 2)
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = trackColor.cgColor
        tracklayer.lineWidth = ringWidth
        tracklayer.path = path
        tracklayer.shadowRadius = WidthScale(5)
        tracklayer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.5).cgColor
        tracklayer.shadowOffset = CGSize(width: WidthScale(3), height: WidthScale(3))
        tracklayer.shadowOpacity = 1.0
        layer.addSublayer(tracklayer)
        
        progressLayer.frame = CGRect(x: 0, y: 0, width: radious * 2, height: radious * 2)
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = ringWidth
        progressLayer.lineCap = .round
        progressLayer.path = path
        progressLayer.strokeStart = progressStart
        progressLayer.strokeEnd = progressEnd
        
        if isGrandient{
            progressGradientLayer.frame = CGRect(x: 0, y: 0, width: radious * 2, height: radious * 2)
            progressGradientLayer.colors = [progressStartColor.cgColor, progressEndColor.cgColor]
            progressGradientLayer.locations = [0,1]
            progressGradientLayer.startPoint = CGPoint(x: 1, y: 0)
            progressGradientLayer.endPoint = CGPoint(x: 0, y: 0)
            progressGradientLayer.mask = progressLayer
            layer.addSublayer(progressGradientLayer)
        }else{
            layer.addSublayer(progressLayer)
        }
    }

    func setProgress(progress:CGFloat,time:CFTimeInterval,animate:Bool){
        CATransaction.begin()
        CATransaction.setDisableActions(!animate)
        CATransaction.setAnimationDuration(time)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: .easeInEaseOut))
        progressLayer.strokeEnd = progress
        CATransaction.commit()
    }
    
}
