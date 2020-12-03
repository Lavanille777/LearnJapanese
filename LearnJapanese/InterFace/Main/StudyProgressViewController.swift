//
//  StudyProgressViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/11/26.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class StudyProgressViewController: LJBaseViewController {
    
    var btn: UIButton = UIButton()
    
    var viewA: UIView = UIView()
    
    var coordinateV: LJCoordinateView = LJCoordinateView()
    
    var segmentV: StudyProgressSegmentView = StudyProgressSegmentView()
    
    private var dataArr: [RecordModel] = []
    
    ///坐标系上的点
    var pointsArr: [LJCoordinatePointModel] = []
    
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        setupUI()
        createNavbar(navTitle: "成长记录", leftIsImage: false, leftStr: "返回", rightIsImage: false, rightStr: nil, leftAction: nil, ringhtAction: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupUI(){
        view.backgroundColor = .white
        
        getPoints(days: 7)
        coordinateV.pointsArr = pointsArr
        coordinateV.frame = CGRect(x: 0, y: 0, width: WidthScale(345), height: WidthScale(200))
        coordinateV.isShowReferLine = true
        view.addSubview(coordinateV)
        coordinateV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(345), height: WidthScale(200)))
        }
        view.layoutIfNeeded()
        
        view.addSubview(segmentV)
        segmentV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(200), height: WidthScale(40)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(WidthScale(isiPhoneX ? 120 : 140))
        }
        segmentV.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.3).cgColor
        segmentV.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        segmentV.layer.shadowRadius = WidthScale(5)
        segmentV.layer.shadowOpacity = 1.0
        
        segmentV.selItemBlk = {[weak self] (btn) in
            if let weakSelf = self{
                if btn.tag != weakSelf.currentIndex{
                    weakSelf.currentIndex = btn.tag
                    if btn.tag == 0{
                        weakSelf.getPoints(days: 7)
                    }else if btn.tag == 1{
                        weakSelf.getPoints(days: 14)
                    }
                    weakSelf.coordinateV.pointsArr = weakSelf.pointsArr
                    weakSelf.coordinateV.reDrawPoints()
                }
            }
        }
        
    }
    
    func getPoints(days: Int){
        dataArr = SQLManager.queryRecords(byStartDate: Date(timeIntervalSinceNow: -TimeInterval(days - 1) * 86400).getCorrectDay(), toEndDate: Date(timeIntervalSinceNow: 86400).getCorrectDay())
        
        dataArr.sort { (model1, model2) -> Bool in
            model1.date < model2.date
        }
        
        var dic: [Date: Int] = [:]
        for model in dataArr {
            dic.updateValue(model.recordNum, forKey: model.date)
        }
        pointsArr.removeAll()
        for i in 0 ..< days {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd日"
            
            let point = LJCoordinatePointModel(withXVal: formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(-i * 86400)).getCorrectDay()))
            if let num = dic[Date(timeIntervalSinceNow: TimeInterval(-i * 86400)).getCorrectDay()]{
                point.yVal = CGFloat(num)
            }
            pointsArr.append(point)
        }
        pointsArr = pointsArr.reversed()
    }

}
