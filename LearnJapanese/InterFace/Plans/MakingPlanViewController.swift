//
//  MakingPlanViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/6/29.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class MakingPlanViewController: LJBaseViewController, UINavigationControllerDelegate {
    
    var interactionInProgress = false //用于指示交互是否在进行中。
    
    ///交互控制器
    private var interactivePopTransition : LJPopInteractiveTransitioning!
    ///日期选择器
    private var datePickerBgV: UIView = UIView()
    private var datePickerBtn: UIButton = UIButton()
    private var datePickerBgEffectV: UIVisualEffectView = UIVisualEffectView()
    private var datePicker = UIDatePicker()
    
    var bgImgV: UIImageView = UIImageView()
    
    ///目标
    var targetTitleL: UILabel = UILabel()
    var targetButtons: [UIButton] = []
    
    ///考试时间
    var examnationTimeV: UIView = UIView()
    var dateSelectImgV: UIImageView = UIImageView()
    var examnationTimeTitleL: UILabel = UILabel()
    var examnationTimeL: UILabel = UILabel()
    
    ///生成计划
    var generatingPlansTitleL: UILabel = UILabel()
    var generatingPlansL: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIScreenEdgePanGestureRecognizer(target:self,action:#selector(handleGesture(gestureRecognizer:)))
        gesture.edges = .left
        self.view.addGestureRecognizer(gesture)
        setupUI()
        self.createNavbar(navTitle: "", leftIsImage: false, leftStr: "返回", rightIsImage: false, rightStr: nil, leftAction: nil, ringhtAction: nil)
        self.navgationBarV.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(bgImgV)
        bgImgV.tag = 101
        bgImgV.contentMode = .center
        bgImgV.isUserInteractionEnabled = true
        bgImgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        targetTitleL.tag = 100
        targetTitleL.font = UIFont.boldSystemFont(ofSize: WidthScale(24))
        targetTitleL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        view.addSubview(targetTitleL)
        targetTitleL.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalToSuperview().inset(NavPlusStatusH)
        }
        
        initLevelBtns()
        
        examnationTimeTitleL.text = "选择考试时间"
        examnationTimeTitleL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        examnationTimeTitleL.font = UIFont.boldSystemFont(ofSize: WidthScale(20))
        view.addSubview(examnationTimeTitleL)
        examnationTimeTitleL.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalTo(targetTitleL.snp.bottom).offset(WidthScale(70))
        }
        
        view.addSubview(examnationTimeV)
        examnationTimeV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(examnationTimeVAction)))
        examnationTimeV.layer.borderColor = HEXCOLOR(h: 0x949494, alpha: 1.0).cgColor
        examnationTimeV.layer.borderWidth = WidthScale(1)
        examnationTimeV.layer.cornerRadius = WidthScale(5)
        examnationTimeV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalTo(examnationTimeTitleL.snp.bottom).offset(WidthScale(20))
            make.size.equalTo(CGSize(width: WidthScale(200), height: WidthScale(40)))
        }
        
        examnationTimeV.addSubview(dateSelectImgV)
        dateSelectImgV.image = UIImage.init(named: "date_sel")
        dateSelectImgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(5))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(WidthScale(30))
        }
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日";
        examnationTimeL.text = formatter.string(from: Date())
        examnationTimeL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        examnationTimeL.font = UIFont.systemFont(ofSize: WidthScale(16))
        view.addSubview(examnationTimeL)
        examnationTimeL.snp.makeConstraints { (make) in
            make.left.equalTo(dateSelectImgV.snp.right).offset(WidthScale(20))
            make.centerY.equalTo(dateSelectImgV)
        }
        
        view.addSubview(datePickerBgV)
        datePickerBgV.isHidden = true
        datePickerBgV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
            make.height.equalToSuperview()
        }
        
        datePickerBgEffectV.effect = UIBlurEffect(style: .prominent)
        datePickerBgV.addSubview(datePickerBgEffectV)
        datePickerBgEffectV.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(330))
        }
        
        datePickerBgEffectV.contentView.addSubview(datePickerBtn)
        datePickerBtn.setTitle("确认", for: .normal)
        datePickerBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(20))
        datePickerBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1.0), for: .normal)
        datePickerBtn.addTarget(self, action: #selector(datePickerBtnAction), for: .touchUpInside)
        datePickerBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(5))
            make.centerX.equalToSuperview()
        }
        
        datePickerBgEffectV.contentView.addSubview(datePicker)
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh")
        datePicker.addTarget(self, action: #selector(dateChanged),
                             for: .valueChanged)
        datePicker.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(290))
        }
    }
    
    @objc func datePickerBtnAction(){
        
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.datePickerBgV.snp.remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(self.view.snp.bottom)
                    make.height.equalTo(WidthScale(300))
                }
                self.view.layoutIfNeeded()
            }, completion: {(finished) in
                self.datePickerBgV.isHidden = true
            })
    }
    
    @objc func examnationTimeVAction(){
        
        datePicker.minimumDate = Date()
        ///最长五年
        datePicker.maximumDate = Date(timeInterval: 5 * 31536000, since: Date())
        datePickerBgV.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.datePickerBgV.snp.makeConstraints { (make) in
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
            btn.tag = i
            btn.addTarget(self, action: #selector(targetSelectAction), for: .touchUpInside)
            targetButtons.append(btn)
            view.addSubview(btn)
            if btn.tag == 0{
                btn.isSelected = true
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(14))
            }
            btn.isSelected = btn.tag == 0
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
        for btn in targetButtons {
            if btn.tag == sender.tag{
                btn.isSelected = true
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WidthScale(14))
                btn.layer.borderWidth = WidthScale(2)
                UIView.animate(withDuration: 0.2, animations: {
                    btn.snp.remakeConstraints { (make) in
                        make.centerX.equalTo(self.view.snp.left).inset(WidthScale(CGFloat(40 + btn.tag * 60)))
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
                            make.centerX.equalTo(self.view.snp.left).inset(WidthScale(CGFloat(40 + btn.tag * 60)))
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
    
    
    //MARK: 导航动画
    // 以下----使用UIPercentDrivenInteractiveTransition交互控制器
    @objc func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        var progress = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).x / (SCREEN_WIDTH * 0.8)
        progress = min(1.0, max(0.0, progress))
        
        if gestureRecognizer.state == .began {
            self.interactivePopTransition = LJPopInteractiveTransitioning()
            interactionInProgress = true
            self.navigationController?.popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            interactivePopTransition.update(progress)
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            interactivePopTransition.finishBy(cancelled: progress < 0.4)
            interactionInProgress = false
            self.interactivePopTransition = nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return LJPushTransitionAnimator.init()
        }else if operation == .pop {
            return LJPopTransitionAnimator.init()
        }
        return nil
    }
    
    /// 当返回值为nil时，上面的协议返回的push和pop动画才会有作用
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactivePopTransition != nil {
            return interactivePopTransition
        }
        return nil
    }
    
}
