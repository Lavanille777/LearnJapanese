//
//  SpellViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/27.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import AudioToolbox

class SpellViewController: LJMainAnimationViewController, UITextFieldDelegate {
    
    ///已记忆的单词数组
    var rememberedWordArr: [WordModel] = []
    ///随机词
    var randomWord: WordModel = WordModel()
    
    ///单词卡片
    var wordCard: UIView = UIView()
    
    ///日语文本
    var jpLabel: UILabel = UILabel()
    ///假名
    var pronunciationLabel: UILabel = UILabel()
    ///中文文本
    var chineseLabel: UILabel = UILabel()
    ///输入框
    var inputV: UIView = UIView()
    var inputTF: UITextField = UITextField()
    var inputUnderLine: UIView = UIView()

    ///跳过按钮
    var passBtn: UIButton = UIButton()
    
    ///下一个按钮
    var nextBtn: UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getRandomWord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIMenuController.shared.isMenuVisible = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIMenuController.shared.isMenuVisible = true
    }
    
    func setupUI() {
        view.backgroundColor = HEXCOLOR(h: 0xFFFFF0, alpha: 1.0)
        
        targetTitleL.text = "拼写练习"
        
        view.addSubview(wordCard)
        wordCard.backgroundColor = HEXCOLOR(h: 0xFFFAF0, alpha: 1.0)
        wordCard.layer.masksToBounds = false
        wordCard.layer.cornerRadius = WidthScale(10)
        wordCard.layer.shadowRadius = WidthScale(10)
        wordCard.layer.shadowColor = HEXCOLOR(h: 0xaaaaaa, alpha: 0.5).cgColor
        wordCard.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        wordCard.layer.shadowOpacity = 1.0
        //        wordCard.layer.borderColor = HEXCOLOR(h: mainGray, alpha: 1.0).cgColor
        //        wordCard.layer.borderWidth = WidthScale(1)
        wordCard.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(250), height: WidthScale(260)))
            make.top.equalToSuperview().offset(WidthScale(120) + StatusBarHeight)   //这里用StatusBarHeight只是因为简单。。
            make.centerX.equalToSuperview()
        }
        
        wordCard.addSubview(jpLabel)
        jpLabel.font = UIFont.systemFont(ofSize: WidthScale(26))
        jpLabel.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        jpLabel.textAlignment = .center
        jpLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(30))
            make.left.right.lessThanOrEqualToSuperview().inset(WidthScale(10))
            make.centerX.equalToSuperview()
        }
        
//        wordCard.addSubview(pronunciationLabel)
//        pronunciationLabel.font = UIFont.systemFont(ofSize: WidthScale(20))
//        pronunciationLabel.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
//        pronunciationLabel.textAlignment = .center
//        pronunciationLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(jpLabel.snp.bottom).offset(WidthScale(20))
//            make.left.right.lessThanOrEqualToSuperview().inset(WidthScale(10))
//            make.centerX.equalTo(jpLabel)
//        }
        
        wordCard.addSubview(chineseLabel)
        chineseLabel.font = UIFont(name: FontYuanTiRegular, size: WidthScale(16))
        chineseLabel.numberOfLines = 0
        chineseLabel.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        chineseLabel.textAlignment = .center
        chineseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(jpLabel.snp.bottom).offset(WidthScale(50))
            make.left.right.lessThanOrEqualToSuperview().inset(WidthScale(10))
            make.centerX.equalTo(jpLabel)
        }
        
        wordCard.addSubview(inputV)
        inputV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(200), height: WidthScale(30)))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(WidthScale(20))
        }
        
        inputV.addSubview(inputTF)
        inputTF.delegate = self
        inputTF.placeholder = "请输入相应的假名"
        inputTF.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        inputTF.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(16))
        inputTF.textAlignment = .center
        inputTF.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview().inset(WidthScale(5))
        }
        
        inputV.addSubview(inputUnderLine)
        inputUnderLine.backgroundColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        inputUnderLine.snp.makeConstraints { (make) in
            make.height.equalTo(WidthScale(1))
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(passBtn)
        passBtn.setTitle("跳过", for: .normal)
        passBtn.setTitleColor(.white, for: .normal)
        passBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(20))
        passBtn.layer.masksToBounds = true
        passBtn.layer.cornerRadius = WidthScale(15)
        passBtn.addTarget(self, action: #selector(switchWord), for: .touchUpInside)
        passBtn.tag = 200
        passBtn.addOncePressAnimation()
        passBtn.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(50) + IPHONEX_BH)
            make.left.equalToSuperview().inset(WidthScale(40))
            make.size.equalTo(CGSize(width: WidthScale(100), height: WidthScale(44)))
        }
        view.layoutIfNeeded()
        passBtn.addGradientLayer(colors: [HEXCOLOR(h: 0x66ccff, alpha: 0.5).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        
        view.addSubview(nextBtn)
        nextBtn.setTitle("确认", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(20))
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = WidthScale(15)
        nextBtn.addTarget(self, action: #selector(switchWord), for: .touchUpInside)
        nextBtn.tag = 201
        nextBtn.addOncePressAnimation()
        nextBtn.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(50) + IPHONEX_BH)
            make.right.equalToSuperview().inset(WidthScale(40))
            make.size.equalTo(CGSize(width: WidthScale(100), height: WidthScale(44)))
        }
        view.layoutIfNeeded()
        nextBtn.addGradientLayer(colors: [HEXCOLOR(h: 0x66ccff, alpha: 0.5).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        
    }
    
    @objc func switchWord(_ sender: UIButton){
        inputTF.isEnabled = false
        if sender.tag == 201 && (inputTF.text == randomWord.japanese || inputTF.text == randomWord.pronunciation){
            inputTF.textColor = .green
            randomWord.wrongMark = false
        }else{
            randomWord.wrongMark = true
            inputTF.text = randomWord.pronunciation
            inputTF.textColor = .red
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if SQLManager.updateWord(self.randomWord){
                Dprint("更新数据库成功")
            }else{
                Dprint("更新数据库失败")
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.wordCard.transform = CGAffineTransform.init(rotationAngle: angleToRadian(-20) )
                
                self.wordCard.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize(width: WidthScale(250), height: WidthScale(260)))
                    make.top.equalToSuperview().offset(WidthScale(120) + StatusBarHeight)
                    make.right.equalTo(self.view.snp.left)
                }
                self.view.layoutIfNeeded()
                
                
            }) { (finish) in
                self.wordCard.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize(width: WidthScale(250), height: WidthScale(260)))
                    make.top.equalToSuperview().offset(WidthScale(120) + StatusBarHeight)
                    make.left.equalTo(self.view.snp.right)
                }
                self.inputTF.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
                self.view.layoutIfNeeded()
                self.getRandomWord()
                self.inputTF.text = ""
                self.inputTF.isEnabled = true
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.wordCard.transform = CGAffineTransform.init(rotationAngle: 0)
                    self.wordCard.snp.remakeConstraints { (make) in
                        make.size.equalTo(CGSize(width: WidthScale(250), height: WidthScale(260)))
                        make.top.equalToSuperview().offset(WidthScale(120) + StatusBarHeight)
                        make.centerX.equalToSuperview()
                    }
                    self.view.layoutIfNeeded()
                }) { (finish) in
                    
                }
            }
        }
        
    }
    
    @objc func getRandomWord() {
        DispatchQueue.global().async {
            if self.rememberedWordArr.count == 0{
                self.rememberedWordArr = SQLManager.queryAllRememberedKanjiWord() ?? []
            }
            DispatchQueue.main.async{
                if self.rememberedWordArr.count > 0{
                    let randomIndex = Int(arc4random() % UInt32(self.rememberedWordArr.count))
                    self.randomWord = self.rememberedWordArr[randomIndex]
                    self.jpLabel.text = self.randomWord.japanese
                    self.pronunciationLabel.text = self.randomWord.pronunciation
                    self.chineseLabel.text = self.randomWord.chinese
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        if keyBoardHeight > SCREEN_HEIGHT - wordCard.frame.maxY{
            UIView.animate(withDuration: 0.25) {
                self.wordCard.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize(width: WidthScale(250), height: WidthScale(260)))
                    make.bottom.equalToSuperview().inset(self.keyBoardHeight)
                    make.centerX.equalToSuperview()
                }
            }
        }

    }
    
    override func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.wordCard.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: WidthScale(250), height: WidthScale(260)))
                make.top.equalToSuperview().offset(WidthScale(120) + StatusBarHeight)
                make.centerX.equalToSuperview()
            }
        }
        
    }
    
}
