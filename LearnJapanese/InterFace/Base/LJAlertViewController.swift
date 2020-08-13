//
//  LJAlertViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/12.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJAlertViewController: LJBaseViewController {
    
    ///背景遮罩
    var bgView: UIView = UIView()
    ///弹框
    var alertCard: UIView = UIView()
    ///按钮分割线
    var horDivLine: UIView = UIView()
    var verDivLine: UIView = UIView()
    ///输入框
    var inputTF: UITextField = UITextField()
    var inputLine: UIView = UIView()
    ///确认按钮
    var confirmBtn: UIButton = UIButton()
    ///确认文字
    var confirmStr: String = "确认"
    ///取消按钮
    var cancelBtn: UIButton = UIButton()
    ///取消文字
    var cancelStr: String = "取消"
    ///标题
    var titleL: UILabel = UILabel()
    ///提示信息
    var alertL: UILabel = UILabel()
    
    var confirmBlk: ((LJAlertViewController)->())?
    var cancelBlk: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    init(withTitle title: String, alert: String?, confirmTitle: String?, cancelTitle: String?, confirmed: ((LJAlertViewController)->())?, canceled: (()->())?){
        super.init(nibName: nil, bundle: nil)
        self.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        titleL.text = title
        confirmBlk = confirmed
        cancelBlk = canceled
        if let alert = alert{
            alertL.text = alert
        }
        confirmStr = confirmTitle ?? "确认"
        cancelStr = cancelTitle ?? "取消"
        
        setupUI()
    }
    
    init(withInputPlaceHolder placeHolder: String, title: String, confirmTitle: String?, cancelTitle: String?, confirmed: ((LJAlertViewController)->())?, canceled: (()->())?){
        super.init(nibName: nil, bundle: nil)
        self.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        inputTF.placeholder = placeHolder
        titleL.text = title
        confirmBlk = confirmed
        cancelBlk = canceled
        
        confirmStr = confirmTitle ?? "确认"
        cancelStr = cancelTitle ?? "取消"
        
        setupInputUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    func setupInputUI() {
        setupUI()
        
        alertCard.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(300), height: WidthScale(180)))
        }
        
        alertCard.addSubview(inputTF)
        inputTF.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(18))
        inputTF.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        inputTF.textAlignment = .center
        inputTF.snp.makeConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(WidthScale(20))
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(WidthScale(20))
        }
        
        alertCard.addSubview(inputLine)
        inputLine.backgroundColor = HEXCOLOR(h: 0xcc6633, alpha: 0.4)
        inputLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(inputTF)
            make.height.equalTo(WidthScale(1))
            make.top.equalTo(inputTF.snp.bottom).offset(WidthScale(3))
        }
    }
    
    func setupUI() {
        view.addSubview(bgView)
        bgView.backgroundColor = HEXCOLOR(h: 0x000000, alpha: 0.2)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(alertCard)
        alertCard.backgroundColor = HEXCOLOR(h: 0xFFFAFA, alpha: 1.0)
        alertCard.layer.cornerRadius = WidthScale(20)
        alertCard.layer.shadowOpacity = 1.0
        alertCard.layer.shadowRadius = WidthScale(5)
        alertCard.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        alertCard.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.8).cgColor
        alertCard.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(300), height: WidthScale(150)))
        }
        
        alertCard.addSubview(titleL)
        titleL.textColor = HEXCOLOR(h: 0xD2691E, alpha: 1.0)
        titleL.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(20))
        titleL.textAlignment = .center
        titleL.numberOfLines = 2
        titleL.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(10))
            make.top.equalToSuperview().inset(WidthScale(20))
            make.centerX.equalToSuperview()
        }
        
        alertCard.addSubview(alertL)
        alertL.textColor = HEXCOLOR(h: 0xD2691E, alpha: 1.0)
        alertL.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(14))
        alertL.textAlignment = .center
        alertL.numberOfLines = 2
        alertL.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(10))
            make.top.equalTo(titleL.snp.bottom).offset(WidthScale(10))
            make.centerX.equalToSuperview()
        }
        
        alertCard.addSubview(confirmBtn)
        confirmBtn.titleLabel?.textAlignment = .center
        confirmBtn.setTitle(confirmStr, for: .normal)
        confirmBtn.setTitleColor(HEXCOLOR(h: 0x330000, alpha: 1.0), for: .normal)
        confirmBtn.titleLabel?.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(18))
        confirmBtn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.left.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(150), height: WidthScale(50)))
        }
        
        alertCard.addSubview(cancelBtn)
        cancelBtn.titleLabel?.textAlignment = .center
        cancelBtn.setTitle(cancelStr, for: .normal)
        cancelBtn.setTitleColor(HEXCOLOR(h: 0xcc6633, alpha: 1.0), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(18))
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(150), height: WidthScale(50)))
        }
        
        alertCard.addSubview(horDivLine)
        horDivLine.backgroundColor = HEXCOLOR(h: 0xcc6633, alpha: 0.2)
        horDivLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(2))
            make.bottom.equalToSuperview().inset(WidthScale(50))
        }
        
        alertCard.addSubview(verDivLine)
        verDivLine.backgroundColor = HEXCOLOR(h: 0xcc6633, alpha: 0.2)
        verDivLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(0))
            make.top.equalTo(horDivLine.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(WidthScale(2))
        }
        
    }
    
    @objc func confirmAction(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.bgView.alpha = 0
            self.alertCard.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.layoutIfNeeded()
        }) { (finised) in
            self.removeFromParent()
            self.view.removeFromSuperview()
            if let blk = self.confirmBlk{
                blk(self)
            }
        }

    }
    
    @objc func cancelAction(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.bgView.alpha = 0
            self.alertCard.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.layoutIfNeeded()
        }) { (finised) in
            self.removeFromParent()
            self.view.removeFromSuperview()
            if let blk = self.cancelBlk{
                blk()
            }
        }
    }
    
    func show(){
        bgView.alpha = 0
        alertCard.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIViewController.getCurrentViewCtrl().view.addSubview(view)
        UIViewController.getCurrentViewCtrl().addChild(self)
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            self.bgView.alpha = 0.5
            self.alertCard.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.view.layoutIfNeeded()
        }) { (finised) in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.bgView.alpha = 1
                self.alertCard.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    //MARK: - 键盘监听
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        UIView.animate(withDuration: 0.3, animations: {
            self.alertCard.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(self.alertCard.bounds.size)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        if SCREEN_HEIGHT - alertCard.frame.maxY < keyBoardHeight{
            UIView.animate(withDuration: 0.3, animations: {
                self.alertCard.snp.remakeConstraints { (make) in
                    make.size.equalTo(self.alertCard.bounds.size)
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview().inset(self.keyBoardHeight)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
