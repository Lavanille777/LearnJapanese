//
//  ReviewWordsViewController.swift
//  LearnJapanese
//  复习单词
//  Created by 唐星宇 on 2020/7/28.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class ReviewWordsViewController: LJMainAnimationViewController, UIGestureRecognizerDelegate {
    
    ///要复习的词
    var reviewWordL: UILabel = UILabel()
    ///发音
    var hiraganaL: UILabel = UILabel()
    
    ///发音按钮
    var voiceBtn: UIButton = UIButton()
    ///选项
    var selectionBtnArr: [UIButton] = []
    ///跳过按钮
    var skipBtn: UIButton = UIButton()
    
    ///已记忆的单词数组
    var rememberedWordArr: [WordModel] = []
    ///三个错误答案
    var wrongWordArr: [WordModel] = []{
        didSet{
            reviewWordL.text = randomWord.japanese
            hiraganaL.text = randomWord.pronunciation
            correctIndex = Int(arc4random() % 3)
            selectionBtnArr[correctIndex].setTitle(randomWord.chinese, for: .normal)
            var count = 0
            for (index,btn) in selectionBtnArr.enumerated() {
                if index != correctIndex{
                    btn.setTitle(wrongWordArr[count].chinese, for: .normal)
                    count += 1
                }
            }
        }
    }
    ///随机词
    var randomWord: WordModel = WordModel()
    
    ///正确选项下标
    var correctIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getRandomWord()
    }
    
    func setupUI() {
//        view.backgroundColor = HEXCOLOR(h: 0xDEB887, alpha: 1.0)
        view.addGradientLayer(colors: [HEXCOLOR(h: 0xF5DEB3, alpha: 0.5).cgColor, HEXCOLOR(h: 0xF5DEB3, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        targetTitleL.text = "温故知新"
        
        view.addSubview(reviewWordL)
        reviewWordL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        reviewWordL.font = UIFont(name: FontYuanTiBold, size: WidthScale(24))
        reviewWordL.textAlignment = .center
        reviewWordL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(targetTitleL.snp.bottom).offset(WidthScale(20))
            make.width.equalTo(WidthScale(200))
        }
        
        view.addSubview(hiraganaL)
        hiraganaL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        hiraganaL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(18))
        hiraganaL.textAlignment = .center
        hiraganaL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(reviewWordL.snp.bottom).offset(WidthScale(10))
            make.width.equalTo(WidthScale(200))
        }
        
        view.addSubview(voiceBtn)
        voiceBtn.addTarget(self, action: #selector(voiceBtnAction), for: .touchUpInside)
        voiceBtn.setImage(UIImage(named: "saying"), for: .normal)
        voiceBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(reviewWordL.snp.bottom)
            make.left.equalTo(reviewWordL.snp.right)
            make.width.height.equalTo(WidthScale(40))
        }
        
        selectionBtnArr.removeAll()
        
        for index in 0..<4 {
            let btn = UIButton()
            btn.setTitleColor(HEXCOLOR(h: 0x101010, alpha: 1.0), for: .normal)
            btn.titleLabel?.font = UIFont(name: FontYuanTiRegular, size: WidthScale(16))
            btn.addTarget(self, action: #selector(selectWordAction), for: .touchUpInside)
            btn.backgroundColor = HEXCOLOR(h: 0xFFF5EE, alpha: 1.0)
            btn.tag = index
            btn.addOncePressAnimation()
            btn.layer.shadowColor = HEXCOLOR(h: 0x101010, alpha: 0.2).cgColor
            btn.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
            btn.layer.shadowRadius = WidthScale(5)
            btn.layer.shadowOpacity = 1.0
            btn.layer.cornerRadius = WidthScale(10)
            btn.titleLabel?.numberOfLines = 2
            btn.titleLabel?.textAlignment = .left
            selectionBtnArr.append(btn)
            view.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.top.equalTo(reviewWordL.snp.bottom).offset(WidthScale(CGFloat(90 * index + 50)))
                make.left.right.equalToSuperview().inset(WidthScale(40))
                make.height.equalTo(WidthScale(70))
            }
        }
        
        skipBtn.setTitle("不记得了", for: .normal)
        view.addSubview(skipBtn)
        skipBtn.setTitleColor(.white, for: .normal)
        skipBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(20))
        skipBtn.layer.masksToBounds = true
        skipBtn.layer.cornerRadius = WidthScale(15)
        skipBtn.tag = 200
        skipBtn.addTarget(self, action: #selector(selectWordAction), for: .touchUpInside)
        skipBtn.addOncePressAnimation()
        skipBtn.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(50) + IPHONEX_BH)
            make.left.right.equalToSuperview().inset(WidthScale(40))
            make.height.equalTo(WidthScale(44))
        }
        view.layoutIfNeeded()
        skipBtn.addGradientLayer(colors: [HEXCOLOR(h: 0x66ccff, alpha: 0.5).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        
    }
    
    @objc func voiceBtnAction(){
        LJSpeechManager.speakWords(randomWord.japanese)
    }
    
    @objc func selectWordAction(_ sender: UIButton){
        if sender.tag == correctIndex{
            sender.setTitleColor(.green , for: .normal)
            randomWord.wrongMark = false
        }else if sender.tag != 200{
            randomWord.wrongMark = true
            sender.setTitleColor(.red , for: .normal)
            selectionBtnArr[correctIndex].setTitleColor(.green, for: .normal)
            UIView.makeToast("记在错词本上了哦~")
        }else{
            randomWord.wrongMark = true
            selectionBtnArr[correctIndex].setTitleColor(.green, for: .normal)
            UIView.makeToast("记在错词本上了哦~")
        }
        SQLManager.updateWord(randomWord)
        skipBtn.isEnabled = false
        for btn in selectionBtnArr {
            btn.isEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.switchWord()
            self.skipBtn.isEnabled = true
            for btn in self.selectionBtnArr {
                btn.isEnabled = true
            }
        }
    }
    
    @objc func switchWord(){
        for (index, btn) in selectionBtnArr.enumerated() {
            UIView.animate(withDuration: 0.25, delay: Double(index) * 0.1, options: .curveEaseIn, animations: {
                btn.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.reviewWordL.snp.bottom).offset(WidthScale(CGFloat(90 * index + 50)))
                    make.right.equalTo(self.view.snp.left)
                    make.width.equalTo(SCREEN_WIDTH - WidthScale(80))
                    make.height.equalTo(WidthScale(70))
                }
                self.view.layoutIfNeeded()
            }) { (finished) in
                btn.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.reviewWordL.snp.bottom).offset(WidthScale(CGFloat(90 * index + 50)))
                    make.left.equalTo(self.view.snp.right)
                    make.width.equalTo(SCREEN_WIDTH - WidthScale(80))
                    make.height.equalTo(WidthScale(70))
                }
                if index == self.selectionBtnArr.count - 1{
                    self.getRandomWord()
                }
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    btn.snp.remakeConstraints { (make) in
                        make.top.equalTo(self.reviewWordL.snp.bottom).offset(WidthScale(CGFloat(90 * index + 50)))
                        make.centerX.equalToSuperview()
                        make.width.equalTo(SCREEN_WIDTH - WidthScale(80))
                        make.height.equalTo(WidthScale(70))
                    }
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            btn.setTitleColor(HEXCOLOR(h: 0x101010, alpha: 1.0) , for: .normal)
        }
    }
    
    @objc func getRandomWord() {
        if rememberedWordArr.count == 0{
            rememberedWordArr = SQLManager.queryAllRememberedWord() ?? []
        }
        
        if rememberedWordArr.count < 4{
            Dprint("多记些词再来吧")
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        var randomIndex = Int(arc4random() % UInt32(self.rememberedWordArr.count))
        self.randomWord = self.rememberedWordArr[randomIndex]
        self.reviewWordL.text = self.randomWord.japanese
        
        var tempArr: [WordModel] = []
        while tempArr.count < 3 {
            randomIndex = Int(arc4random() % UInt32(self.rememberedWordArr.count))
            if self.rememberedWordArr[randomIndex] != self.randomWord{
                tempArr.append(self.rememberedWordArr[randomIndex])
            }
        }
        wrongWordArr = tempArr
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
