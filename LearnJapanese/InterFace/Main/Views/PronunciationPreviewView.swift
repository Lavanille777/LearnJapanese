//
//  PronunciationPreviewView.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/19.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class PronunciationPreviewView: UIView {
    ///单词卡
    var cardV: UIView = UIView()
    ///平假名
    var mainL: UILabel = UILabel()
    ///片假名
    var subL: UILabel = UILabel()
    ///罗马音
    var romeL: UILabel = UILabel()
    ///发音按钮
    var voiceBtn: UIButton = UIButton()
    
    var model: PronunciationModel = PronunciationModel(){
        didSet{
            mainL.text = model.hiragana
            subL.text = model.katakana
            romeL.text = model.rome
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
        
        self.addSubview(cardV)
        cardV.alpha = 0
        cardV.backgroundColor = HEXCOLOR(h: 0xFFFAF0, alpha: 1.0)
        cardV.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.5).cgColor
        cardV.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        cardV.layer.shadowRadius = WidthScale(5)
        cardV.layer.shadowOpacity = 1.0
        cardV.layer.cornerRadius = WidthScale(10)
        cardV.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(180))
            make.center.equalToSuperview()
        }
        
        cardV.addSubview(mainL)
        mainL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(36))
        mainL.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(WidthScale(-15))
            make.centerX.equalToSuperview().offset(-WidthScale(20))
        }
        
        cardV.addSubview(subL)
        subL.textColor = HEXCOLOR(h: 0x949494, alpha: 1.0)
        subL.font = UIFont(name: FontYuanTiBold, size: WidthScale(30))
        subL.snp.makeConstraints { (make) in
            make.bottom.equalTo(mainL)
            make.left.equalTo(mainL.snp.right).offset(WidthScale(10))
        }
        
        cardV.addSubview(romeL)
        romeL.textColor = HEXCOLOR(h: 0x949494, alpha: 1.0)
        romeL.font = UIFont(name: FontYuanTiBold, size: WidthScale(26))
        romeL.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(10))
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
        LJSpeechManager.speakWords(model.hiragana)
    }
    
    func pop() {
        UIViewController.getCurrentViewCtrl().view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        cardV.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.cardV.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.cardV.alpha = 0.5
        }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                self.cardV.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.cardV.alpha = 1
            }) { (finished) in
                
            }
        }
        voiceBtnAction()
    }
    
    @objc func hide(sender: UITapGestureRecognizer){
        guard !cardV.frame.contains(sender.location(in: self)) else {
            return
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.cardV.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.cardV.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
}
