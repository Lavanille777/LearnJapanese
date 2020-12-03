//
//  CoordinateView.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/11/27.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

//class CoordinateView: UIView {
//    
//    ///坐标系上的点
//    var pointsArr: [CoordinatePointModel] = []
//
//    var yDivdeNum: Int = 5
//    
//    var isShowXPoint: Bool = true
//    
//    ///横轴
//    private var xAxisV: UIView = UIView()
//    
//    ///内容
//    private var contentV: UIView = UIView()
//    
//    ///纵轴
//    private var yAxisV: UIView = UIView()
//    
//    ///参考线
//    var isShowReferLine: Bool = false
//    private var yLabels: [UILabel] = []
//    private var xLabels: [UILabel] = []
//    private var referLines: [UIView] = []
//    
//    lazy var pathView :BezierPathView = {
//        let view = BezierPathView(withPoints: pointFrameArr, frame: .zero, isAnimated: true, isSmooth: false)
//        return view
//    }()
//    
//    
//    
//    private var maxNum = 0
//    
//    private var pointFrameArr: [CGPoint] = []
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupUI(){
//        addSubview(contentV)
//        contentV.backgroundColor = .clear
//        contentV.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//        
//        contentV.addSubview(pathView)
//        pathView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview().inset(WidthScale(20))
//        }
//        layoutIfNeeded()
//        
//        contentV.addSubview(xAxisV)
//        xAxisV.backgroundColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
//        xAxisV.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalTo(pathView)
//            make.height.equalTo(1)
//        }
//        
//        contentV.addSubview(yAxisV)
//        yAxisV.backgroundColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
//        yAxisV.snp.makeConstraints { (make) in
//            make.top.left.bottom.equalTo(pathView)
//            make.width.equalTo(1)
//        }
//        layoutIfNeeded()
//    }
//    
//    func drawPoints(){
//        
//        guard pointsArr.count > 0 else {
//            print("尚未设置坐标点!")
//            return
//        }
//        
//        for label in xLabels{
//            label.removeFromSuperview()
//        }
//        xLabels.removeAll()
//        
//        for label in yLabels{
//            label.removeFromSuperview()
//        }
//        yLabels.removeAll()
//        
//        for (index, point) in pointsArr.enumerated(){
//            let xVal = (CGFloat(pointsArr.count) - 1 - CGFloat(index)) * pathView.frame.size.width / CGFloat(pointsArr.count)
//            let yVal = (1 - point.yVal / CGFloat(maxNum)) * pathView.frame.size.height
//            
//            let label = UILabel()
//            label.text = point.xVal
//            label.font = UIFont.systemFont(ofSize: WidthScale(10))
//            label.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
//            contentV.addSubview(label)
//            label.snp.makeConstraints { (make) in
//                make.top.equalTo(xAxisV.snp.bottom).offset(WidthScale(5))
//                make.centerX.equalTo(yAxisV).offset(xVal)
//            }
//            xLabels.append(label)
//            
//            pointFrameArr.append(CGPoint(x: xVal, y: yVal))
//        }
//        
//        for i in 0 ..< yDivdeNum{
//            let yVal = (CGFloat(i) / CGFloat(yDivdeNum)) * pathView.frame.size.height
//            let label = UILabel()
//            label.text = "\(maxNum / yDivdeNum * i)"
//            label.font = UIFont.systemFont(ofSize: WidthScale(10))
//            label.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
//            contentV.addSubview(label)
//            label.snp.makeConstraints { (make) in
//                make.right.equalTo(yAxisV).offset(-WidthScale(5))
//                make.bottom.equalTo(xAxisV).offset(-yVal)
//            }
//            
//            let line = UIView()
//            line.backgroundColor = HEXCOLOR(h: 0x949494, alpha: 1.0)
//            contentV.addSubview(line)
//            line.snp.makeConstraints { (make) in
//                make.left.right.equalTo(xAxisV)
//                make.bottom.equalTo(xAxisV).offset(-yVal)
//                make.height.equalTo(1)
//            }
//            
//            yLabels.append(label)
//        }
//
//        pathView.setBackgroudColor(grandientColor: [HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 0).cgColor])
//        pathView.pointFrameArr = pointFrameArr
//    }
//    
//    
//
//}
