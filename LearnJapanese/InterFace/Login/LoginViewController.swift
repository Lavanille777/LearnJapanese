//
//  LoginViewController.swift
//  LearnJapanese
//  登录页
//  Created by 唐星宇 on 2020/5/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    ///登录标题
    var loginTitleL: UILabel = UILabel()
    ///卡片界面
    var cardContentV: UIView = UIView()
    ///头像
    var avatarImgV: UIImageView = UIImageView()
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
    var toRegistBtn: UIButton = UIButton()
    
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
        cardContentV.layer.borderColor = HEXCOLOR(h: mainColor, alpha: 1.0).cgColor
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
        
        cardContentV.addSubview(accountV)
        accountV.layer.borderWidth = WidthScale(1)
        accountV.layer.borderColor = HEXCOLOR(h: mainColor, alpha: 1.0).cgColor
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
        passwordV.layer.borderColor = HEXCOLOR(h: mainColor, alpha: 1.0).cgColor
        passwordV.layer.cornerRadius = WidthScale(20)
        passwordV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
            make.top.equalTo(accountV.snp.bottom).offset(WidthScale(10))
            make.centerX.equalToSuperview()
        }
        
        passwordV.addSubview(passwordTF)
        passwordTF.placeholder = "密码"
        passwordTF.isSecureTextEntry = true
        passwordTF.font = UIFont.systemFont(ofSize: WidthScale(14))
        passwordTF.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        passwordTF.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(30))
            make.centerY.equalToSuperview()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
