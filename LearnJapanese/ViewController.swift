//
//  ViewController.swift
//  LearnJapanese
//  首页
//  Created by 唐星宇 on 2020/5/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    ///前往登录页
    var toLoginBtn: UIButton = UIButton()
    ///前往注册页
    var toRegistBtn: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(toLoginBtn)
        toLoginBtn.setTitle("登录", for: .normal)
        toLoginBtn.setTitleColor(HEXCOLOR(h: 0x101010, alpha: 1.0), for: .normal)
        toLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: WidthScale(16))
        toLoginBtn.addTarget(self, action: #selector(jumpToLogin), for: .touchUpInside)
        toLoginBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(WidthScale(80))
        }
        
        self.view.addSubview(toRegistBtn)
        toRegistBtn.setTitle("注册", for: .normal)
        toRegistBtn.setTitleColor(HEXCOLOR(h: 0x101010, alpha: 1.0), for: .normal)
        toRegistBtn.titleLabel?.font = UIFont.systemFont(ofSize: WidthScale(16))
        toRegistBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(toLoginBtn.snp.bottom).offset(WidthScale(20))
        }
        
    }
    
    ///前往登录页
    @objc func jumpToLogin(){
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}

