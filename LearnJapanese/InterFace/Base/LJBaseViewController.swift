//
//  LJBaseViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/5/20.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJBaseViewController: UIViewController {
    ///键盘高度
    var keyBoardHeight: CGFloat = 0
    
    /// 返回方法(可重写)
    @objc public func navBackAction() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //导航视图
    lazy var navgationBarV:LJNavigationBar = {
        let barV = LJNavigationBar.init()
        barV.backgroundColor = .white
        return barV
    }()
    
    // MARK: - PRIVATE
    func createNavbar(navTitle:String, leftIsImage:Bool, leftStr:String?, rightIsImage:Bool, rightStr:String?, leftAction:Selector?, ringhtAction:Selector?, lineColor:UIColor? = nil) {
        //背景
        self.view.addSubview(navgationBarV)
        navgationBarV.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(StatusBarHeight+NavBarHeight)
        }
        //返回按钮
        if leftIsImage {
            if let leftStr = leftStr{
                navgationBarV.backBtn.setImage(UIImage.init(named: leftStr), for: .normal)
            }else{
                navgationBarV.backBtn.setImage(UIImage.init(named: "L_back"), for: .normal)
            }
        }else{
            if let leftStr = leftStr {
                navgationBarV.backBtn.setTitle(leftStr, for: .normal)
                navgationBarV.backBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1), for: .normal)
                navgationBarV.backBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            }
        }
        if let leftAction = leftAction {
            navgationBarV.backBtn.addTarget(self, action: leftAction, for: .touchUpInside)
        }else{
            navgationBarV.backBtn.addTarget(self, action: #selector(navBackAction), for: .touchUpInside)
        }
        navgationBarV.addSubview(navgationBarV.backBtn)
        navgationBarV.backBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalTo(WidthScale(60))
            make.height.equalTo(NavBarHeight)
        }
        //右侧按钮
        if rightIsImage{
            if let rightString = rightStr {
                navgationBarV.rightBtn.setImage(UIImage.init(named: rightString), for: .normal)
            }
        }else{
            if let rightString = rightStr {
                navgationBarV.rightBtn.setTitle(rightString, for: .normal)
                navgationBarV.rightBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1), for: .normal)
                navgationBarV.rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
        if let ringhtAction = ringhtAction {
            navgationBarV.rightBtn.addTarget(self, action: ringhtAction, for: .touchUpInside)
        }
        navgationBarV.addSubview(navgationBarV.rightBtn)
        navgationBarV.rightBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(NavBarHeight)
            make.width.equalTo(rightIsImage ? NavBarHeight:90)
        }
        //标题
        navgationBarV.navTitleL.text = navTitle
        navgationBarV.addSubview(navgationBarV.navTitleL)
        navgationBarV.navTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(navgationBarV.backBtn.snp.right).offset(((rightIsImage ? 0:(90-NavBarHeight))+10))
            make.right.equalTo(navgationBarV.rightBtn.snp.left).offset(-10)
            make.bottom.equalToSuperview()
            make.height.equalTo(NavBarHeight)
        }
        
        if let lineColor = lineColor{
            let lineView = UIView.init(frame: .zero)
            lineView.backgroundColor = lineColor
            navgationBarV.addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let value = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
        let keyboardRec = (value as AnyObject).cgRectValue
        keyBoardHeight = keyboardRec?.size.height ?? 0
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let value = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
        let keyboardRec = (value as AnyObject).cgRectValue
        keyBoardHeight = keyboardRec?.size.height ?? 0
    }
    
}
