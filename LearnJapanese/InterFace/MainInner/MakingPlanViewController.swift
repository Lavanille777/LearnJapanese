//
//  MakingPlanViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/6/29.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class MakingPlanViewController: LJBaseViewController {
    
    var isFromLogin: Bool = false
    
    var titleImgV: UIImageView = UIImageView()
    
    ///目标
    var targetTitleL: UILabel = UILabel()
    
    ///日期选择器
    private var datePickerBgV: UIView = UIView()
    private var datePickerBtn: UIButton = UIButton()
    private var datePickerBgEffectV: UIVisualEffectView = UIVisualEffectView()
    private var datePicker = UIDatePicker()
    
    var targetButtons: [UIButton] = []
    
    ///考试时间
    var examnationTimeV: UIView = UIView()
    var dateSelectImgV: UIImageView = UIImageView()
    var examnationTimeTitleL: UILabel = UILabel()
    var examnationTimeL: UILabel = UILabel()
    
    ///生成计划
    var generatingPlansTitleL: UILabel = UILabel()
    var generatingPlansL: UILabel = UILabel()
    
    ///确定计划按钮
    var confirmPlanBtn: UIButton = UIButton()
    
    ///选中的按钮
    var selectedBtn: UIButton?{
        didSet{
            if oldValue == nil{
                self.examnationTimeTitleL.isHidden = false
                self.examnationTimeV.isHidden = false
                self.examnationTimeL.isHidden = false
                self.examnationTimeTitleL.alpha = 0
                self.examnationTimeV.alpha = 0
                self.examnationTimeL.alpha = 0
                UIView.animate(withDuration: 1) {
                    self.examnationTimeTitleL.alpha = 1
                    self.examnationTimeV.alpha = 1
                    self.examnationTimeL.alpha = 1
                    self.view.layoutIfNeeded()
                }
            }
            planChanged()
        }
    }
    
    init(isFromLogin: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isFromLogin = isFromLogin
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        targetTitleL.tag = 100
        targetTitleL.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(24))
        targetTitleL.textColor = HEXCOLOR(h: 0xA0522D, alpha: 1.0)
        view.addSubview(targetTitleL)
        targetTitleL.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalToSuperview().inset(NavPlusStatusH)
        }
        
        titleImgV.image = UIImage(named: "cat1")
        titleImgV.tag = 100
        view.addSubview(titleImgV)
        titleImgV.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().inset(WidthScale(20))
            make.centerY.equalTo(targetTitleL)
            make.size.equalTo(CGSize(width: WidthScale(88), height: WidthScale(84)))
        }
        if !isFromLogin{
            createNavbar(navTitle: "", leftIsImage: false, leftStr: "返回", rightIsImage: false, rightStr: nil, leftAction: nil, ringhtAction: nil)
            navgationBarV.backgroundColor = .clear
        }
        
        view.backgroundColor = HEXCOLOR(h: 0xffcccc, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfo.havePlan ? setupMyPlanUI() : setupMakingPlanUI()
        view.bringSubviewToFront(navgationBarV)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !datePicker.isHidden && (datePicker.superview != nil){
            hideDatePicker()
        }
    }
    
    //无计划时的界面配置
    func setupMakingPlanUI() {
        targetTitleL.text = "制定计划"
        
        initLevelBtns()
        
        examnationTimeTitleL.isHidden = true
        examnationTimeTitleL.alpha = 0
        examnationTimeTitleL.text = "选择考试时间"
        examnationTimeTitleL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        examnationTimeTitleL.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(20))
        view.addSubview(examnationTimeTitleL)
        examnationTimeTitleL.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalTo(targetTitleL.snp.bottom).offset(WidthScale(70))
        }
        
        view.addSubview(examnationTimeV)
        examnationTimeV.isHidden = true
        examnationTimeV.alpha = 0
        examnationTimeV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDatePicker)))
        examnationTimeV.layer.borderColor = HEXCOLOR(h: 0x949494, alpha: 1.0).cgColor
        examnationTimeV.layer.borderWidth = WidthScale(1)
        examnationTimeV.layer.cornerRadius = WidthScale(5)
        examnationTimeV.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalTo(examnationTimeTitleL.snp.bottom).offset(WidthScale(20))
            make.size.equalTo(CGSize(width: WidthScale(200), height: WidthScale(40)))
        }
        
        examnationTimeV.addSubview(dateSelectImgV)
        dateSelectImgV.image = UIImage.init(named: "date_sel")
        dateSelectImgV.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(5))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(WidthScale(30))
        }
        
        view.addSubview(generatingPlansTitleL)
        generatingPlansTitleL.text = "先确定一个目标和期限吧"
        generatingPlansTitleL.numberOfLines = 0
        generatingPlansTitleL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        generatingPlansTitleL.font = UIFont(name: FontYuanTiBold, size: WidthScale(20))
        generatingPlansTitleL.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(WidthScale(300))
            make.left.equalTo(targetTitleL)
        }
        
        examnationTimeL.alpha = 0
        examnationTimeL.isHidden = true
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日";
        examnationTimeL.text = formatter.string(from: Date())
        examnationTimeL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        examnationTimeL.font = UIFont.systemFont(ofSize: WidthScale(16))
        view.addSubview(examnationTimeL)
        examnationTimeL.snp.remakeConstraints { (make) in
            make.left.equalTo(dateSelectImgV.snp.right).offset(WidthScale(20))
            make.centerY.equalTo(dateSelectImgV)
        }
        
        view.addSubview(confirmPlanBtn)
        confirmPlanBtn.alpha = 0
        confirmPlanBtn.isHidden = true
        confirmPlanBtn.setTitle("确认计划", for: .normal)
        confirmPlanBtn.setTitleColor(.white, for: .normal)
        confirmPlanBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(20))
        confirmPlanBtn.layer.masksToBounds = true
        confirmPlanBtn.layer.cornerRadius = WidthScale(15)
        confirmPlanBtn.addTarget(self, action: #selector(confirmPlanBtnAciton), for: .touchUpInside)
        confirmPlanBtn.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(40) + IPHONEX_BH)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(200), height: WidthScale(44)))
        }
        view.layoutIfNeeded()
        confirmPlanBtn.addGradientLayer(colors: [HEXCOLOR(h: 0x66ccff, alpha: 0.5).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        
        view.addSubview(datePickerBgV)
        datePickerBgV.isHidden = true
        datePickerBgV.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
            make.height.equalToSuperview()
        }

        datePickerBgEffectV.effect = UIBlurEffect(style: .prominent)
        datePickerBgV.addSubview(datePickerBgEffectV)
        datePickerBgEffectV.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(330))
        }

        datePickerBgEffectV.contentView.addSubview(datePickerBtn)
        datePickerBtn.setTitle("确认", for: .normal)
        datePickerBtn.titleLabel?.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(22))
        datePickerBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1.0), for: .normal)
        datePickerBtn.addTarget(self, action: #selector(datePickerBtnAction), for: .touchUpInside)
        datePickerBtn.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(5))
            make.centerX.equalToSuperview()
        }

        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh")
        datePicker.addTarget(self, action: #selector(dateChanged),
                             for: .valueChanged)
        
    }
    
    //有计划时的界面配置
    func setupMyPlanUI(){
        targetTitleL.text = "我的计划"
        
        view.addSubview(generatingPlansTitleL)
        let days = userInfo.targetDate.timeIntervalSinceNow / (3600 * 24)
        generatingPlansTitleL.numberOfLines = 0
        generatingPlansTitleL.text = "你选择的是N\(userInfo.targetLevel)\n\n需要掌握\(userInfo.wordsCount)个词汇\n\n距离考试还剩下\(Int(days))天"
        generatingPlansTitleL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        generatingPlansTitleL.font = UIFont.boldSystemFont(ofSize: WidthScale(20))
        generatingPlansTitleL.alpha = 0
        generatingPlansTitleL.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(WidthScale(300))
            make.left.equalTo(targetTitleL)
        }
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1) {
            self.generatingPlansTitleL.alpha = 1
            self.generatingPlansTitleL.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(WidthScale(300))
                make.left.equalTo(self.targetTitleL)
            }
            self.view.layoutIfNeeded()
        }
        
        view.addSubview(confirmPlanBtn)
        confirmPlanBtn.setTitle("修改计划", for: .normal)
        confirmPlanBtn.setTitleColor(.white, for: .normal)
        confirmPlanBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(20))
        confirmPlanBtn.layer.masksToBounds = true
        confirmPlanBtn.layer.cornerRadius = WidthScale(15)
        confirmPlanBtn.addTarget(self, action: #selector(confirmPlanBtnAciton), for: .touchUpInside)
        confirmPlanBtn.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(40) + IPHONEX_BH)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(200), height: WidthScale(44)))
        }
        view.layoutIfNeeded()
        confirmPlanBtn.addGradientLayer(colors: [HEXCOLOR(h: 0x66ccff, alpha: 0.5).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        
    }
    
    ///计划变更
    func planChanged(){
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日";
        let today: String = formatter.string(from: Date())
        examnationTimeL.text = formatter.string(from: datePicker.date)
        
        if examnationTimeL.text == today{
            confirmPlanBtn.alpha = 0
            confirmPlanBtn.isHidden = true
            generatingPlansTitleL.text = "再确认一下时间吧"
        }else if let btn = selectedBtn {
            confirmPlanBtn.alpha = 0
            confirmPlanBtn.isHidden = false
            let days = datePicker.date.timeIntervalSinceNow / (3600 * 24)
            generatingPlansTitleL.text = "你选择的是\(btn.titleLabel?.text ?? "")\n\n需要掌握\(btn.tag)个词汇\n\n距离考试还剩下\(Int(days))天\n\n平均每天记\(btn.tag/Int(days))个单词"
            UIView.animate(withDuration: 0.5) {
                self.confirmPlanBtn.alpha = 1
            }
        }else{
            confirmPlanBtn.alpha = 0
            confirmPlanBtn.isHidden = true
            generatingPlansTitleL.text = "还没选择目标呢"
        }
        
        generatingPlansTitleL.alpha = 0
        generatingPlansTitleL.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(WidthScale(300))
            make.left.equalTo(targetTitleL)
        }
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1) {
            self.generatingPlansTitleL.alpha = 1
            self.generatingPlansTitleL.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(WidthScale(300))
                make.left.equalTo(self.targetTitleL)
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func confirmPlanBtnAciton(){
        let alert = LJAlertViewController(withTitle: userInfo.havePlan ? "确定要修改计划吗" : "计划确定了吗", alert: userInfo.havePlan ? "所有记录将被清空" : nil, confirmTitle: "确定", cancelTitle: "再想想", confirmed: { (alert) in
            if userInfo.havePlan{
                userInfo.targetLevel = 0
                userInfo.targetDate = Date()
                userInfo.todayWordsCount = 0
                userInfo.rememberWordsCount = 0
                self.selectedBtn = nil
                userInfo.havePlan = false
            }else{
                userInfo.targetLevel = 8 - ((self.selectedBtn?.tag ?? 2000) / 1000)
                userInfo.targetDate = self.datePicker.date
                userInfo.ensureTargetDate = Date()
                userInfo.havePlan = true
            }
            userInfo.rememberWordsCount = 0
            
            if SQLManager.updateUser(userInfo){
                if self.isFromLogin{
                    let navContrller = UINavigationController.init(rootViewController: LJMainTabBarViewController())

                    let transtition: CATransition = CATransition()
                    transtition.duration = 0.5;
                    transtition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    UIApplication.shared.keyWindow?.rootViewController = navContrller
                    UIApplication.shared.keyWindow?.layer.add(transtition, forKey: "animation")
                    
                }else{
                    for view in self.view.subviews {
                        if view.tag != 100 && view.tag != 101{
                            view.removeFromSuperview()
                        }
                    }
                    userInfo.havePlan ? self.setupMyPlanUI() : self.setupMakingPlanUI()
                    self.createNavbar(navTitle: "", leftIsImage: false, leftStr: "返回", rightIsImage: false, rightStr: nil, leftAction: nil, ringhtAction: nil)
                }
                Dprint("更新成功")
            }else{
                Dprint("更新失败")
            }
            
        }, canceled: nil)

        alert.show()
        
    }
    
    @objc func datePickerBtnAction(){
        hideDatePicker()
        planChanged()
    }
    
    func hideDatePicker(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.datePickerBgV.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(self.view.snp.bottom)
                make.height.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }, completion: {(finished) in
            self.datePicker.removeFromSuperview()
        })
    }
    
    @objc func showDatePicker(){
        
        datePicker.minimumDate = Date(timeInterval: TimeInterval(selectedBtn!.tag / 40 * 86400), since: Date()) //最多一天40个词
        datePicker.maximumDate = Date(timeInterval: TimeInterval(selectedBtn!.tag * 86400), since: Date())    //最少一天1个词
        datePickerBgEffectV.contentView.addSubview(datePicker)
        datePicker.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(290))
        }
        datePickerBgV.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.datePickerBgV.snp.remakeConstraints { (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func dateChanged(){
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日";
        examnationTimeL.text = formatter.string(from: datePicker.date)
    }
    
    ///生成考试等级选择按钮
    func initLevelBtns(){
        targetButtons.removeAll()
        for i in 0..<5 {
            let btn = UIButton()
            btn.setTitle("N\(i + 1)", for: .normal)
            btn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1.0), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: WidthScale(14))
            btn.setTitleColor(HEXCOLOR(h: 0x101010, alpha: 1.0), for: .selected)
            btn.layer.cornerRadius = WidthScale(8)
            btn.layer.borderColor = HEXCOLOR(h: 0x66ccff, alpha: 0.3).cgColor
            btn.layer.borderWidth = WidthScale(1)
            btn.layer.masksToBounds = true
            btn.tag = (7 - i) * 1000
            btn.addTarget(self, action: #selector(targetSelectAction), for: .touchUpInside)
            targetButtons.append(btn)
            view.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.left).inset(WidthScale(CGFloat(40 + i * 60)))
                make.width.equalTo(WidthScale(44))
                make.centerY.equalTo(self.targetTitleL.snp.bottom).offset(WidthScale(30))
            }
            view.layoutIfNeeded()
            btn.addGradientLayer(colors: [HEXCOLOR(h: 0x66ccff, alpha: 0.3).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        }
    }
    
    @objc func targetSelectAction(_ sender: UIButton){
        for (index, btn) in targetButtons.enumerated() {
            if btn.tag == sender.tag{
                selectedBtn = sender
                btn.isSelected = true
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(14))
                btn.layer.borderWidth = WidthScale(2)
                UIView.animate(withDuration: 0.2, animations: {
                    btn.snp.remakeConstraints { (make) in
                        make.centerX.equalTo(self.view.snp.left).inset(WidthScale(CGFloat(40 + index * 60)))
                        make.size.equalTo(CGSize(width: btn.frame.size.width * 1.2, height: btn.frame.size.height * 1.2))
                        make.centerY.equalTo(self.targetTitleL.snp.bottom).offset(WidthScale(30))
                    }
                    self.view.layoutIfNeeded()
                    if let sublayers = btn.layer.sublayers{
                        if sublayers.count > 0{
                            sublayers[0].frame = btn.bounds
                            sublayers[0].frame.size.width = sublayers[0].frame.size.width + 1
                        }
                    }
                }) { (isComplete) in
                    UIView.animate(withDuration: 0.2, animations: {
                        btn.snp.remakeConstraints { (make) in
                            make.centerX.equalTo(self.view.snp.left).inset(WidthScale(CGFloat(40 + index * 60)))
                            make.size.equalTo(CGSize(width: btn.frame.size.width / 1.2, height: btn.frame.size.height / 1.2))
                            make.centerY.equalTo(self.targetTitleL.snp.bottom).offset(WidthScale(30))
                        }
                        self.view.layoutIfNeeded()
                        if let sublayers = btn.layer.sublayers{
                            if sublayers.count > 0{
                                sublayers[0].frame = btn.bounds
                                sublayers[0].frame.size.width = sublayers[0].frame.size.width + 1
                            }
                        }
                    })
                }
            }else{
                btn.isSelected = false
                btn.titleLabel?.font = UIFont.systemFont(ofSize: WidthScale(14))
                btn.layer.borderWidth = WidthScale(1)
            }
        }
    }
    
}
