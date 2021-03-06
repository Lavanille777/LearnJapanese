//
//  StudyProgressSegmentView.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/12/2.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class StudyProgressSegmentView: UIView {

    var bgView: UIView = UIView()
    
    var segmentItems: [UIButton] = [UIButton(), UIButton(), UIButton()]
    
    var selBGView: UIView = UIView()
    
    var selItemBlk: ((_ btn: UIButton)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    func setupUI() {
        self.addSubview(bgView)
        bgView.backgroundColor = HEXCOLOR(h: 0xFFF0F5, alpha: 1.0)
        bgView.layer.cornerRadius = WidthScale(10)
        bgView.layer.masksToBounds = true
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(selBGView)
        selBGView.backgroundColor = HEXCOLOR(h: 0xFFC0CB, alpha: 0.7)
        selBGView.layer.masksToBounds = true
        selBGView.layer.cornerRadius = WidthScale(10)
        selBGView.snp.makeConstraints { (make) in
            make.width.equalTo(WidthScale(88))
            make.height.equalTo(WidthScale(30))
            make.left.equalToSuperview().inset(WidthScale(8))
            make.centerY.equalToSuperview()
        }
        
        for i in 0 ..< 2 {
            bgView.addSubview(segmentItems[i])
            segmentItems[i].snp.makeConstraints { (make) in
                make.width.equalTo(WidthScale(80))
                make.height.equalTo(WidthScale(30))
                make.left.equalToSuperview().inset(WidthScale(CGFloat(i * 90 + 10)))
                make.centerY.equalToSuperview()
            }
            segmentItems[i].tag = i
            switch i {
            case 0:
                segmentItems[i].setTitle("过去7天", for: .normal)
            case 1:
                segmentItems[i].setTitle("过去14天", for: .normal)
            default:
                break
            }
            segmentItems[i].setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1.0), for: .normal)
            segmentItems[i].titleLabel?.font = UIFont(name: FontYuanTiRegular, size: WidthScale(12))
            
            segmentItems[i].addTarget(self, action: #selector(segmentItemAction), for: .touchUpInside)
        }
    }
    
    @objc func segmentItemAction(sender: UIButton){
           
           let x = self.selBGView.frame.minX + (WidthScale(CGFloat(sender.tag * 90 + 8)) - self.selBGView.frame.minX) / 2
           if x != self.selBGView.frame.minX{
               UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                   self.selBGView.snp.remakeConstraints { (make) in
                       make.width.equalTo(WidthScale(120))
                       make.height.equalTo(WidthScale(30))
                       make.left.equalToSuperview().inset(x)
                       make.centerY.equalToSuperview()
                   }
                   self.layoutIfNeeded()
               }) { (finished) in
                   UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                       self.selBGView.snp.remakeConstraints { (make) in
                           make.width.equalTo(WidthScale(88))
                           make.height.equalTo(WidthScale(30))
                           make.left.equalToSuperview().inset(WidthScale(CGFloat(sender.tag * 90 + 8)))
                           make.centerY.equalToSuperview()
                       }
                       
                       self.layoutIfNeeded()
                   })
               }
               
               if let selItemBlk = selItemBlk{
                   selItemBlk(sender)
               }
           }
       }


}
