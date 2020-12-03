//
//  LearnNewWordViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/27.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import AudioToolbox

class LearnNewWordViewController: LJMainAnimationViewController {
    
    ///未记忆的单词数组
    var unRememberedWordArr: [WordModel] = []
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
    ///发音按钮
    var voiceBtn: UIButton = UIButton()
    ///收藏按钮
    var markBtn: UIButton = UIButton()
    ///跳过按钮
    var passBtn: UIButton = UIButton()
    
    ///下一个按钮
    var nextBtn: UIButton = UIButton()
    ///环形进度条
    var progressView: LJCycleProgressView = LJCycleProgressView.init(withWidth: WidthScale(10), radious: WidthScale(50), trackColor: HEXCOLOR(h: 0xe6e6e6, alpha: 1.0), progressStartColor: HEXCOLOR(h: 0x00BFFF, alpha: 0.2), progressEndColor: HEXCOLOR(h: 0x6495ED, alpha: 1.0))
    var progressL: UILabel = UILabel()
    var progressCount: Int = 0
    ///今日已记忆数
    var todayCountL: UILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getRandomWord()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshCycleView()
    }
    
    func refreshCycleView(){
        if userInfo.todayWordsCount <= userInfo.averageWordsCount{
            self.progressCount = userInfo.todayWordsCount
            self.todayCountL.text = "今天记了\(userInfo.todayWordsCount)个生词"
            self.progressL.text = "\(self.progressCount)/\(userInfo.averageWordsCount)"
            self.progressView.setProgress(progress: CGFloat(userInfo.todayWordsCount) / CGFloat(userInfo.averageWordsCount), time: 0.5, animate: true)
        }else{
            self.progressCount = userInfo.rememberWordsCount
            self.progressView.setProgress(progress: CGFloat(userInfo.rememberWordsCount) / CGFloat(userInfo.wordsCount), time: 0.5, animate: true)
            self.todayCountL.text = "一共记了\(userInfo.rememberWordsCount)个生词"
            self.progressL.text = "\(userInfo.rememberWordsCount)/\(userInfo.wordsCount)"
        }
    }
    
    func setupUI() {
//        view.backgroundColor = HEXCOLOR(h: 0xFFFFF0, alpha: 1.0)
        titleImgV.image = UIImage(named: "cat1")
        view.addGradientLayer(colors: [HEXCOLOR(h: 0xFDF5E6, alpha: 0.25).cgColor, HEXCOLOR(h: 0xFDF5E6, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        targetTitleL.text = "学点儿新词"
        
        view.addSubview(wordCard)
        wordCard.backgroundColor = HEXCOLOR(h: 0xFFF5EE, alpha: 1.0)
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
        
        wordCard.addSubview(pronunciationLabel)
        pronunciationLabel.font = UIFont.systemFont(ofSize: WidthScale(20))
        pronunciationLabel.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        pronunciationLabel.textAlignment = .center
        pronunciationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(jpLabel.snp.bottom).offset(WidthScale(20))
            make.left.right.lessThanOrEqualToSuperview().inset(WidthScale(10))
            make.centerX.equalTo(jpLabel)
        }
        
        wordCard.addSubview(chineseLabel)
        chineseLabel.font = UIFont(name: FontYuanTiRegular, size: WidthScale(16))
        chineseLabel.numberOfLines = 0
        chineseLabel.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        chineseLabel.textAlignment = .center
        chineseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pronunciationLabel.snp.bottom).offset(WidthScale(20))
            make.left.right.lessThanOrEqualToSuperview().inset(WidthScale(10))
            make.centerX.equalTo(jpLabel)
        }
        
        wordCard.addSubview(voiceBtn)
        voiceBtn.addTarget(self, action: #selector(voiceBtnAction), for: .touchUpInside)
        voiceBtn.setImage(UIImage(named: "saying"), for: .normal)
        voiceBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(10))
            make.right.equalToSuperview().inset(WidthScale(50))
            make.width.height.equalTo(WidthScale(40))
        }
        
        wordCard.addSubview(markBtn)
        markBtn.addTarget(self, action: #selector(markBtnAction), for: .touchUpInside)
        markBtn.setImage(UIImage(named: "collect_unsel"), for: .normal)
        markBtn.setImage(UIImage(named: "collect_sel"), for: .selected)
        markBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(13))
            make.left.equalToSuperview().inset(WidthScale(50))
            make.width.height.equalTo(WidthScale(40))
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(100))
            make.top.equalTo(wordCard.snp.bottom).offset(StatusBarHeight)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(progressL)
        progressL.font = UIFont(name: FontYuanTiBold, size: WidthScale(20))
        progressL.text = "\(progressCount)/\(userInfo.averageWordsCount)"
        progressL.textColor = HEXCOLOR(h: 0x6495ED, alpha: 1.0)
        progressL.snp.makeConstraints { (make) in
            make.center.equalTo(progressView)
        }
        
        view.addSubview(todayCountL)
        todayCountL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(18))
        todayCountL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        todayCountL.text = "今天记了\(userInfo.todayWordsCount)个生词"
        todayCountL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(progressView.snp.bottom).offset(WidthScale(10))
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
        nextBtn.setTitle("下一个", for: .normal)
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
    
    @objc func voiceBtnAction(){
        LJSpeechManager.speakWords(randomWord.japanese)
    }
    
    @objc func markBtnAction(){
        randomWord.bookMark = !markBtn.isSelected
        if SQLManager.updateWord(randomWord){
            Dprint("收藏/取消收藏 成功")
            markBtn.isSelected = !markBtn.isSelected
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            UIView.animate(withDuration: 0.25, animations: {
                self.markBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { (finished) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.markBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
                }) { (finished) in
                    
                }
            }
        }else{
            Dprint("收藏/取消收藏 失败")
        }
    }
    
    @objc func switchWord(_ sender: UIButton){
        if sender.tag == 201{
            progressCount += 1
            userInfo.todayWordsCount += 1
            userInfo.rememberWordsCount += 1
            recordInfo.recordNum += 1
            randomWord.isRemembered = true
            recordInfo.date = Date.correctToDay()
            if SQLManager.updateUser(userInfo) && SQLManager.updateWord(randomWord) && SQLManager.updateRecord(recordInfo){
                Dprint("更新数据库成功")
            }else{
                Dprint("更新数据库失败")
            }
        }
        
        if userInfo.todayWordsCount == userInfo.averageWordsCount{
            let alert = LJAlertViewController(withTitle: "要休息一下吗", alert: "今天已经记了\(userInfo.todayWordsCount)个生词", confirmTitle: "就这样吧", cancelTitle: "我还能学!", confirmed: { (alert) in
                self.navigationController?.popViewController(animated: true)
            }) {
                
            }

            alert.show()
        }
        
        refreshCycleView()
        
        self.view.layoutIfNeeded()
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
            self.view.layoutIfNeeded()
            self.getRandomWord()
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
    
    @objc func getRandomWord() {
        DispatchQueue.global().async {
            if self.unRememberedWordArr.count == 0{
                self.unRememberedWordArr = SQLManager.queryAllUnrememberedWord() ?? []
            }
            DispatchQueue.main.async{
                if self.unRememberedWordArr.count > 0{
                    let randomIndex = Int(arc4random() % UInt32(self.unRememberedWordArr.count))
                    self.randomWord = self.unRememberedWordArr[randomIndex]
                    self.jpLabel.text = self.randomWord.japanese
                    self.pronunciationLabel.text = self.randomWord.pronunciation
                    self.chineseLabel.text = self.randomWord.chinese
                    self.markBtn.isSelected = self.randomWord.bookMark
                }
            }
        }
    }
    
}
