//
//  LJCoordinateView.swift
//  LJCoordinate
//
//  Created by 唐星宇 on 2020/12/1.
//

import UIKit

class LJCoordinateView: UIView {
    //MARK: ----公有成员-----
    ///坐标系上的点
    var pointsArr: [LJCoordinatePointModel] = []
    
    var yDivdeNum: Int = 7
    
    ///是否显示参考线
    var isShowReferLine: Bool = false
    var fontSize: CGFloat = WidthScale(9)
    
    ///线颜色
    var lineColor: CGColor = HEXCOLOR(h: 0x00BFFF, alpha: 1.0).cgColor
    
    ///线宽度
    var lineWidth: CGFloat = 1.0
    
    ///动画展示时间
    var duration: TimeInterval = 1
    
    ///是否动画展示
    var isAnimated: Bool = true
    
    ///是否是曲线图
    var isSmooth: Bool = false
    
    //MARK: ----私有成员-----
    ///内容
    private var contentV: UIView = UIView()
    
    ///横轴
    private var xAxisV: UIView = UIView()
    private var xLabels: [UILabel] = []
    
    ///纵轴
    private var yAxisV: UIView = UIView()
    private var yLabels: [UILabel] = []
    private var referLines: [UIView] = []
    
    var observation: NSKeyValueObservation?
    
    lazy var pathView :LJBezierPathView = {
        let view = LJBezierPathView(withPoints: pointFrameArr, frame: .zero, isAnimated: isAnimated, isSmooth: isSmooth)
        return view
    }()
    
    private var maxNum:CGFloat = 0
    
    private var pointFrameArr: [CGPoint] = []
    
    private var scale:CGFloat = 0.9
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, isAnimated: Bool = true, isSmooth: Bool = false, isShowReferLine: Bool = true) {
        super.init(frame: frame)
        self.isAnimated = isAnimated
        self.isSmooth = isSmooth
        self.isShowReferLine = true
        self.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction)))
    }
    
    func setBackgroudColor(grandientColor: [CGColor], location: [NSNumber] = [0, 1], isHor: Bool = false){
        pathView.setBackgroudColor(grandientColor: grandientColor, location: location, isHor: isHor)
    }
    
    func setBackgroudColor(color: CGColor){
        pathView.setBackgroudColor(color: color)
    }
    
    func reDrawPoints(){
//        guard pointsArr.count > 0 else {
//            print("尚未设置坐标点!")
//            return
//        }
//
//        maxNum = 0
//        for point in pointsArr{
//            if point.yVal > maxNum{
//                maxNum = point.yVal
//            }
//        }
//
//        maxNum = maxNum * (1 / scale)
//
//        pointFrameArr.removeAll()
//        for (index, point) in pointsArr.enumerated(){
//            let xVal = CGFloat(index) * pathView.frame.size.width / CGFloat(pointsArr.count)
//            let yVal = (1 - point.yVal / maxNum) * pathView.frame.size.height
//            pointFrameArr.append(CGPoint(x: xVal, y: yVal))
//        }
//
//        for i in 1 ... yDivdeNum{
//            let yVal = (CGFloat(i) / CGFloat(yDivdeNum)) * pathView.frame.size.height
//            let label = yLabels[i - 1]
//            label.text = "\(Int(maxNum) / yDivdeNum * i)"
//            label.sizeToFit()
//            label.frame = CGRect(x: yAxisV.frame.minX - label.frame.width - WidthScale(5), y: xAxisV.frame.maxY - yVal, width: 0, height: 0)
//            label.sizeToFit()
//        }
//        setPathView()
        drawPoints()
    }
    
    override func didMoveToSuperview() {
        setupUI()
    }
    
    @objc private func pinchGestureAction(sender: UIPinchGestureRecognizer){
        self.scale = sender.scale
        if self.scale <= 0.2{
            self.scale = 0.2
        }
        if self.scale >= 2{
            self.scale = 2
        }
        isAnimated = false
        reDrawPoints()
    }
    
    private func setupUI(){
        
        addSubview(contentV)
        contentV.backgroundColor = .clear
        contentV.frame = self.bounds
        
        contentV.addSubview(pathView)
        
        pathView.frame = CGRect(x: contentV.frame.minX + WidthScale(10), y: contentV.frame.minY + WidthScale(10), width: contentV.frame.width - WidthScale(20), height: contentV.frame.height - WidthScale(20))
        
        contentV.addSubview(xAxisV)
        xAxisV.backgroundColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        xAxisV.frame = CGRect(x: pathView.frame.minX, y: pathView.frame.maxY, width: pathView.frame.width, height: 1)
        
        contentV.addSubview(yAxisV)
        yAxisV.backgroundColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        yAxisV.frame = CGRect(x: pathView.frame.minX, y: pathView.frame.minY, width: 1, height: pathView.frame.height)
        
        drawPoints()
    }
    
    private func drawPoints(){
        
        guard pointsArr.count > 0 else {
            print("尚未设置坐标点!")
            return
        }
        
        maxNum = 0
        for point in pointsArr{
            if point.yVal > maxNum{
                maxNum = point.yVal
            }
        }
        
        maxNum = maxNum * (1 / scale)
        
        for label in xLabels {
            label.removeFromSuperview()
        }
        xLabels.removeAll()
        
        for label in yLabels {
            label.removeFromSuperview()
        }
        yLabels.removeAll()

        pointFrameArr.removeAll()
        for (index, point) in pointsArr.enumerated(){
            let xVal = CGFloat(index) * pathView.frame.size.width / CGFloat(pointsArr.count)
            let yVal = (1 - point.yVal / maxNum) * pathView.frame.size.height
            
            let label = UILabel()
            label.text = point.xVal
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
            contentV.addSubview(label)
            label.frame = CGRect(x: xAxisV.frame.minX + xVal, y: xAxisV.frame.maxY + WidthScale(5), width: 0, height: 0)
            label.sizeToFit()
            
            xLabels.append(label)
            
            pointFrameArr.append(CGPoint(x: xVal, y: yVal))
        }
        
        for i in 1 ... yDivdeNum{
            let yVal = (CGFloat(i) / CGFloat(yDivdeNum)) * pathView.frame.size.height
            let label = UILabel()
            label.text = "\(Int(maxNum) / yDivdeNum * i)"
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
            contentV.addSubview(label)
            label.sizeToFit()
            label.frame = CGRect(x: yAxisV.frame.minX - label.frame.width - WidthScale(5), y: xAxisV.frame.maxY - yVal, width: 0, height: 0)
            label.sizeToFit()
            
            let line = UIView()
            line.isHidden = !isShowReferLine
            line.backgroundColor = HEXCOLOR(h: 0x949494, alpha: 1.0)
            contentV.addSubview(line)
            line.frame = CGRect(x: xAxisV.frame.minX, y: xAxisV.frame.maxY - yVal, width: xAxisV.frame.width, height: 1)
            
            yLabels.append(label)
        }
        
        setPathView()
    }
    
    private func setPathView(){
        pathView.lineColor = lineColor
        pathView.lineWidth = lineWidth
        pathView.isSmooth = isSmooth
        pathView.isAnimated = isAnimated
        pathView.setBackgroudColor(grandientColor: [HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 0).cgColor])
        pathView.pointFrameArr = pointFrameArr
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        setupUI()
    }
    
    private func sizeDidChange(){
        for view in contentV.subviews{
            view.removeFromSuperview()
        }
        contentV.removeFromSuperview()
        setupUI()
    }
}
