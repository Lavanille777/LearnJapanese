//
//  LoginViewController.swift
//  LearnJapanese
//  登录页
//  Created by 唐星宇 on 2020/5/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LoginViewController: LJBaseViewController {
    
    enum PageState{
        case login
        case regist
    }
    
    ///登录标题
    var loginTitleL: UILabel = UILabel()
    ///卡片界面
    var cardContentV: UIView = UIView()
    ///头像
    var avatarImgV: UIImageView = UIImageView()
    ///昵称输入框
    var nickNameV: UIView = UIView()
    var nickNameTF: UITextField = UITextField()
    ///账号输入框
    var accountV: UIView = UIView()
    var accountTF: UITextField = UITextField()
    ///密码输入框
    var passwordV: UIView = UIView()
    var passwordTF: UITextField = UITextField()
    ///忘记密码按钮
    var forgetPWBtn: UIButton = UIButton()
    ///登录按钮
    var loginBtn: UIButton = UIButton()
    ///注册按钮
    var switchLoginRegistBtn: UIButton = UIButton()
    
    //MARK:- 私有数据
    var pageState: PageState = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(loginTitleL)
        loginTitleL.text = "登录"
        loginTitleL.font = UIFont.systemFont(ofSize: WidthScale(18))
        loginTitleL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        loginTitleL.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(42) + StatusBarHeight)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(cardContentV)
        cardContentV.backgroundColor = .white
        cardContentV.layer.masksToBounds = false
        cardContentV.layer.cornerRadius = WidthScale(10)
        cardContentV.layer.shadowRadius = WidthScale(10)
        cardContentV.layer.shadowColor = HEXCOLOR(h: 0xaaaaaa, alpha: 0.8).cgColor
        cardContentV.layer.shadowOpacity = 1.0
        cardContentV.layer.borderColor = HEXCOLOR(h: mainGray, alpha: 1.0).cgColor
        cardContentV.layer.borderWidth = WidthScale(1)
        cardContentV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(279), height: WidthScale(404)))
            make.top.equalTo(loginTitleL.snp.bottom).offset(WidthScale(64))
            make.centerX.equalToSuperview()
        }
        
        cardContentV.addSubview(avatarImgV)
        avatarImgV.backgroundColor = .gray
        avatarImgV.layer.cornerRadius = WidthScale(45)
        avatarImgV.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(90))
            make.top.equalToSuperview().inset(WidthScale(40))
            make.centerX.equalToSuperview()
        }
        
        cardContentV.addSubview(nickNameV)
        nickNameV.isHidden = true
        nickNameV.layer.borderWidth = WidthScale(1)
        nickNameV.layer.borderColor = HEXCOLOR(h: mainGray, alpha: 1.0).cgColor
        nickNameV.layer.cornerRadius = WidthScale(20)
        nickNameV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
            make.top.equalTo(avatarImgV.snp.bottom).offset(WidthScale(30))
            make.centerX.equalToSuperview()
        }
        
        nickNameV.addSubview(nickNameTF)
        nickNameTF.placeholder = "昵称"
        nickNameTF.font = UIFont.systemFont(ofSize: WidthScale(14))
        nickNameTF.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        nickNameTF.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(30))
            make.centerY.equalToSuperview()
        }
        
        cardContentV.addSubview(accountV)
        accountV.layer.borderWidth = WidthScale(1)
        accountV.layer.borderColor = HEXCOLOR(h: mainGray, alpha: 1.0).cgColor
        accountV.layer.cornerRadius = WidthScale(20)
        accountV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
            make.top.equalTo(avatarImgV.snp.bottom).offset(WidthScale(30))
            make.centerX.equalToSuperview()
        }
        
        accountV.addSubview(accountTF)
        accountTF.placeholder = "账号"
        accountTF.font = UIFont.systemFont(ofSize: WidthScale(14))
        accountTF.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        accountTF.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(30))
            make.centerY.equalToSuperview()
        }
        
        cardContentV.addSubview(passwordV)
        passwordV.layer.borderWidth = WidthScale(1)
        passwordV.layer.borderColor = HEXCOLOR(h: mainGray, alpha: 1.0).cgColor
        passwordV.layer.cornerRadius = WidthScale(20)
        passwordV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
            make.top.equalTo(accountV.snp.bottom).offset(WidthScale(10))
            make.centerX.equalToSuperview()
        }
        
        passwordV.addSubview(passwordTF)
        passwordTF.placeholder = "密码"
        passwordTF.keyboardType = .asciiCapable
        passwordTF.isSecureTextEntry = true
        passwordTF.font = UIFont.systemFont(ofSize: WidthScale(14))
        passwordTF.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        passwordTF.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(30))
            make.centerY.equalToSuperview()
        }
        
        forgetPWBtn.setTitle("忘记密码?", for: .normal)
        forgetPWBtn.titleLabel?.font = UIFont.systemFont(ofSize: WidthScale(12))
        forgetPWBtn.setTitleColor(HEXCOLOR(h: mainGray, alpha: 1.0), for: .normal)
        cardContentV.addSubview(forgetPWBtn)
        forgetPWBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(74))
            make.top.equalTo(passwordV.snp.bottom).offset(WidthScale(10))
        }
        
        cardContentV.addSubview(loginBtn)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: WidthScale(18))
        loginBtn.backgroundColor = HEXCOLOR(h: mainColor, alpha: 1.0)
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = WidthScale(20)
        loginBtn.addTarget(self, action: #selector(LoginAction), for: .touchUpInside)
        loginBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(forgetPWBtn.snp.bottom).offset(WidthScale(20))
            make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
        }
        
        switchLoginRegistBtn.setTitle("新用户? 点击这里注册", for: .normal)
        switchLoginRegistBtn.titleLabel?.font = UIFont.systemFont(ofSize: WidthScale(12))
        switchLoginRegistBtn.setTitleColor(HEXCOLOR(h: mainGray, alpha: 1.0), for: .normal)
        switchLoginRegistBtn.addTarget(self, action: #selector(switchLoginRegistAction), for: .touchUpInside)
        self.view.addSubview(switchLoginRegistBtn)
        switchLoginRegistBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(WidthScale(27) + IPHONEX_BH)
        }
        
    }
    
    //MARK: - 触摸事件
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// 切换登录注册模式
    @objc func switchLoginRegistAction(){
        switch pageState {
        case .login:
            loginTitleL.text = "注册"
            pageState = .regist
            UIView.animate(withDuration: 0.3, animations: {
                self.cardContentV.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize(width: WidthScale(279), height: WidthScale(428)))
                    make.top.equalTo(self.loginTitleL.snp.bottom).offset(WidthScale(64))
                    make.centerX.equalToSuperview()
                }
                self.nickNameV.isHidden = false
                self.accountV.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
                    make.top.equalTo(self.nickNameV.snp.bottom).offset(WidthScale(10))
                    make.centerX.equalToSuperview()
                }
                self.forgetPWBtn.isHidden = true
                self.loginBtn.setTitle("注册", for: .normal)
                self.loginBtn.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(self.passwordV.snp.bottom).offset(WidthScale(30))
                    make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
                }
                self.switchLoginRegistBtn.setTitle("已经有账号了？点击登录", for: .normal)
                self.view.layoutIfNeeded()
            }, completion: nil)
        case .regist:
            loginTitleL.text = "登录"
            pageState = .login
            UIView.animate(withDuration: 0.3, animations: {
                self.cardContentV.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize(width: WidthScale(279), height: WidthScale(404)))
                    make.top.equalTo(self.loginTitleL.snp.bottom).offset(WidthScale(64))
                    make.centerX.equalToSuperview()
                }
                self.nickNameV.isHidden = true
                self.accountV.snp.remakeConstraints { (make) in
                    make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
                    make.top.equalTo(self.avatarImgV.snp.bottom).offset(WidthScale(30))
                    make.centerX.equalToSuperview()
                }
                self.forgetPWBtn.isHidden = false
                self.loginBtn.setTitle("登录", for: .normal)
                self.loginBtn.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(self.forgetPWBtn.snp.bottom).offset(WidthScale(20))
                    make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
                }
                self.switchLoginRegistBtn.setTitle("新用户? 点击这里注册", for: .normal)
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func LoginAction(){
//        if let tabbarCtrl = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController{
//            tabbarCtrl.selectedIndex = 0
//            if let firstNav = tabbarCtrl.selectedViewController as? UINavigationController{
//                firstNav.popToRootViewController(animated: false)
//            }
//        }else{
        let tabbarVC = MainTabBarController()
        let navContrller = UINavigationController.init(rootViewController: tabbarVC)
        navContrller.modalPresentationStyle = .fullScreen
        navContrller.modalTransitionStyle = .flipHorizontal
        self.present(navContrller, animated: true, completion: nil)
//        }
    }
    //MARK: - 键盘监听
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        UIView.animate(withDuration: 0.3, animations: {
            self.cardContentV.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: WidthScale(279), height: WidthScale(428)))
                make.top.equalTo(self.loginTitleL.snp.bottom).offset(WidthScale(64))
                make.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }, completion: nil)

    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        UIView.animate(withDuration: 0.3, animations: {
            self.cardContentV.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: WidthScale(279), height: WidthScale(428)))
                make.bottom.equalToSuperview().inset(self.keyBoardHeight)
                make.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
