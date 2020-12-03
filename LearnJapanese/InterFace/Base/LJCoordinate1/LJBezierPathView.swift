//
//  LJBezierPathView.swift
//  LJCoordinate
//
//  Created by 唐星宇 on 2020/12/1.
//

import UIKit

class LJBezierPathView: UIView {
    
    ///点数据源
    var pointFrameArr:[CGPoint] = []{
        didSet{
            drawPath()
        }
    }
    
    ///线颜色
    var lineColor: CGColor = HEXCOLOR(h: 0x00BFFF, alpha: 1.0).cgColor
    
    ///线宽度
    var lineWidth: CGFloat = 1.0
    
    ///动画展示时间
    var duration: TimeInterval = 1
    
    ///是否动画展示
    var isAnimated: Bool = true
    
    ///是否是折线图
    var isSmooth: Bool = false{
        didSet{
            self.granularity = isSmooth ? 20 : 1
        }
    }
    
    private var bezierPath = UIBezierPath()
    
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    private var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    private var maskAnimateView: UIView = UIView()
    
    private var colors: [CGColor] = [UIColor.clear.cgColor, UIColor.clear.cgColor]
    
    private var location: [NSNumber] = [0, 1]
    
    private var isHor: Bool = false
    
    private var granularity: Int = 1
    
    //    @available(*, unavailable, message: "please use init(withPionts: andFrame:)")
    convenience init(){
        self.init(frame: .zero)
        setupUI()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withPoints ponits: [CGPoint], frame: CGRect = .zero, isAnimated: Bool = false, isSmooth: Bool = false) {
        super.init(frame: frame)
        self.isAnimated = isAnimated
        self.granularity = isSmooth ? 20 : 1
        setupUI()
        pointFrameArr = ponits
    }
    
    func setBackgroudColor(grandientColor: [CGColor], location: [NSNumber] = [0, 1], isHor: Bool = false){
        self.colors = grandientColor
        self.location = location
        self.isHor = isHor
    }
    
    func setBackgroudColor(color: CGColor){
        self.colors = [color, color]
    }
    
    func drawPath() {
        if let sublayers = layer.sublayers{
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.mask = maskAnimateView
        maskAnimateView.backgroundColor = .black
        
        gradientLayer = self.addGradientLayer(colors: colors, locations: location, isHor: isHor)
        
        bezierPath = bezierPath.smoothedPathWithGranularity(granularity: granularity, points: pointFrameArr, frame: self.frame)
        
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.masksToBounds = false
        layer.addSublayer(shapeLayer)
        
        let masklayer = CAShapeLayer()
        masklayer.path = bezierPath.smoothedPathWithGranularity(granularity: granularity, points: pointFrameArr, frame: self.frame, onlyDrawLine: false).cgPath
        gradientLayer.mask = masklayer
        
        if isAnimated{
            playAnimation()
        }else{
            self.maskAnimateView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }
    }
    
    private func setupUI(){
        self.mask = maskAnimateView
        self.layer.masksToBounds = false
        maskAnimateView.layer.masksToBounds = false
        maskAnimateView.backgroundColor = .black
    }

    private func playAnimation(){
        //        shapeLayer.strokeEnd = 0
        //        CATransaction.begin()
        //        CATransaction.setDisableActions(false)
        //        CATransaction.setAnimationDuration(3)
        //        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: .linear))
        //        shapeLayer.strokeEnd = 1
        //        CATransaction.commit()
        self.maskAnimateView.frame = CGRect(x: 0, y: 0, width: 0, height: self.frame.height)
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
            self.maskAnimateView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        } completion: { (completed) in
            
        }
    }
    
}

extension UIBezierPath{
    
    ///CRS拟合曲线
    func smoothedPathWithGranularity(granularity: Int, points: [CGPoint], frame: CGRect = .zero, onlyDrawLine: Bool = true) -> UIBezierPath{
        
        var points = points
        
        if (points.count < 4) {
            return self
        }
        
        points.insert(CGPoint(x: 0, y: frame.height), at: 0)
        points.append(CGPoint(x: points.last!.x, y: frame.height))
        
        let smoothedPath = self
        smoothedPath.removeAllPoints()
        smoothedPath.move(to: points[0])
        
        if granularity <= 1{
            for index in 1 ..< (onlyDrawLine ? (points.count - 1) : points.count) {
                smoothedPath.addLine(to: points[index])
            }
        }else{
            for index in 1 ..< points.count - 2 {
                let p0 = points[index - 1]
                let p1 = points[index]
                let p2 = points[index + 1]
                let p3 = points[index + 2]
                
                for i in 1 ..< granularity{
                    
                    let t = CGFloat(i) * (1.0 / CGFloat(granularity))
                    let tt = t * t
                    let ttt = tt * t
                    
                    // 中间点
                    var pi = CGPoint(x: 0, y: 0)
                    
                    let x1 = 2 * p1.x + (p2.x - p0.x) * t
                    let x2 = (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * tt
                    let x3 = (3 * p1.x - p0.x - 3 * p2.x + p3.x) * ttt
                    pi.x = 0.5 * (x1 + x2 + x3)
                    
                    let y1 = 2 * p1.y + (p2.y - p0.y) * t
                    let y2 = (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * tt
                    let y3 = (3 * p1.y - p0.y - 3 * p2.y + p3.y) * ttt
                    pi.y = 0.5 * (y1 + y2 + y3)
                    smoothedPath.addLine(to: pi)
                }
                
                smoothedPath.addLine(to: p2)
            }
            smoothedPath.addLine(to: points[onlyDrawLine ? points.count - 2 : points.count - 1])
        }
        
        return smoothedPath
    }
    
}

