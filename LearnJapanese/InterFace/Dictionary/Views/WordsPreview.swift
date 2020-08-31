//
//  WordsPreview.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/19.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class WordsPreview: UIView {
    var maskV: UIView = UIView()
    ///单词卡
    var cardBGV: UIView = UIView()
    var cardV: UIView = UIView()
    ///平假名
    var mainL: UILabel = UILabel()
    ///片假名
    var subL: UILabel = UILabel()
    ///中文释义
    var chineseL: UILabel = UILabel()
    ///发音按钮
    var voiceBtn: UIButton = UIButton()
    
    var model: WordModel = WordModel(){
        didSet{
            mainL.text = model.japanese
            subL.text = model.pronunciation
            chineseL.text = model.chinese
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    func setupUI(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        self.addSubview(maskV)
        maskV.backgroundColor = HEXCOLOR(h: 0x000000, alpha: 1)
        maskV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(cardBGV)
        cardBGV.alpha = 0
        cardBGV.layer.shadowColor = HEXCOLOR(h: 0x303030, alpha: 0.5).cgColor
        cardBGV.layer.shadowRadius = WidthScale(10)
        cardBGV.layer.shadowOpacity = 1.0
        cardBGV.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        cardBGV.layer.cornerRadius = WidthScale(20)
        cardBGV.snp.makeConstraints { (make) in
            make.width.equalTo(WidthScale(240))
            make.height.equalTo(WidthScale(300))
            make.center.equalToSuperview()
        }
        
        cardBGV.addSubview(cardV)
        cardV.backgroundColor = .white
        cardV.layer.masksToBounds = true
        cardV.layer.cornerRadius = WidthScale(10)
        cardV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.layoutIfNeeded()
        
        cardV.addGradientLayer(colors: [HEXCOLOR(h: 0x87CEFA, alpha: 1).cgColor, HEXCOLOR(h: 0x00BFFF, alpha: 1).cgColor], locations: [0,1], isHor: true)
        
        cardV.addSubview(mainL)
        mainL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(24))
        mainL.numberOfLines = 2
        mainL.textAlignment = .center
        mainL.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(20))
            make.left.right.equalToSuperview().inset(WidthScale(10))
            make.centerX.equalToSuperview()
        }
        
        cardV.addSubview(subL)
        subL.textAlignment = .center
        subL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        subL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(18))
        subL.numberOfLines = 2
        subL.snp.makeConstraints { (make) in
            make.top.equalTo(mainL.snp.bottom).offset(WidthScale(20))
            make.left.right.equalToSuperview().inset(WidthScale(10))
            make.centerX.equalToSuperview()
        }
        
        cardV.addSubview(chineseL)
        chineseL.textAlignment = .center
        chineseL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        chineseL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(16))
        chineseL.numberOfLines = 0
        chineseL.snp.makeConstraints { (make) in
            make.top.equalTo(subL.snp.bottom).offset(WidthScale(20))
            make.left.right.equalToSuperview().inset(WidthScale(10))
            make.centerX.equalToSuperview()
        }
        
        cardV.addSubview(voiceBtn)
        voiceBtn.addTarget(self, action: #selector(voiceBtnAction), for: .touchUpInside)
        voiceBtn.setImage(UIImage(named: "saying"), for: .normal)
        voiceBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(25))
            make.centerX.equalToSuperview().inset(WidthScale(50))
            make.width.height.equalTo(WidthScale(40))
        }
    }
    
    @objc func voiceBtnAction(){
        LJSpeechManager.speakWords(model.japanese)
    }
    
    func pop() {
        UIViewController.getCurrentViewCtrl().view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        maskV.alpha = 0
        cardBGV.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.maskV.alpha = 0.1
            self.cardBGV.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.cardBGV.alpha = 0.5
        }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.cardBGV.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.cardBGV.alpha = 1
                self.maskV.alpha = 0.2
            }) { (finished) in
                
            }
        }
        voiceBtnAction()
    }
    
    @objc func hide(sender: UITapGestureRecognizer){
        guard !cardBGV.frame.contains(sender.location(in: self)) else {
            return
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            self.cardBGV.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.cardBGV.alpha = 0
            self.maskV.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
}
