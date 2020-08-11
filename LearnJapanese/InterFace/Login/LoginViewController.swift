//
//  LoginViewController.swift
//  LearnJapanese
//  登录页
//  Created by 唐星宇 on 2020/5/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import TZImagePickerController

class LoginViewController: LJBaseViewController, TZImagePickerControllerDelegate {
    
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
    ///登录按钮
    var loginBtn: UIButton = UIButton()
    
    //MARK:- 私有数据
    var pageState: PageState = .login
    var avatarImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(loginTitleL)
        loginTitleL.text = "こ ん に ち は"
        loginTitleL.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(30))
        loginTitleL.textColor = HEXCOLOR(h: 0xFFC0CB, alpha: 1.0)
        loginTitleL.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(42) + StatusBarHeight)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(cardContentV)
        cardContentV.backgroundColor = .white
        cardContentV.layer.masksToBounds = false
        cardContentV.layer.cornerRadius = WidthScale(10)
        cardContentV.layer.shadowRadius = WidthScale(10)
        cardContentV.layer.shadowColor = HEXCOLOR(h: 0xaaaaaa, alpha: 0.5).cgColor
        cardContentV.layer.shadowOpacity = 1.0
//        cardContentV.layer.borderColor = HEXCOLOR(h: mainGray, alpha: 1.0).cgColor
//        cardContentV.layer.borderWidth = WidthScale(1)
        cardContentV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(279), height: WidthScale(300)))
            make.top.equalTo(loginTitleL.snp.bottom).offset(WidthScale(100))
            make.centerX.equalToSuperview()
        }
        
        cardContentV.addSubview(avatarImgV)
        do {
            try avatarImgV.image = UIImage(data: Data(contentsOf: URL.init(fileURLWithPath: "\(docPath)\(userInfo.avatarURL)")))
        } catch let error {
            Dprint(error)
            avatarImgV.image = UIImage(named: "avatar")
        }
        
        avatarImgV.isUserInteractionEnabled = true
        avatarImgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapAction)))
        avatarImgV.layer.cornerRadius = WidthScale(45)
        avatarImgV.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(90))
            make.top.equalToSuperview().inset(WidthScale(40))
            make.centerX.equalToSuperview()
        }
        
        cardContentV.addSubview(nickNameV)
        nickNameV.layer.borderWidth = WidthScale(1)
        nickNameV.layer.borderColor = HEXCOLOR(h: mainGray, alpha: 1.0).cgColor
        nickNameV.layer.cornerRadius = WidthScale(20)
        nickNameV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
            make.top.equalTo(avatarImgV.snp.bottom).offset(WidthScale(30))
            make.centerX.equalToSuperview()
        }
        
        nickNameV.addSubview(nickNameTF)
        nickNameTF.placeholder = "起个好听的昵称吧"
        nickNameTF.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(16))
        nickNameTF.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        nickNameTF.textAlignment = .center
        nickNameTF.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(30))
            make.centerY.equalToSuperview()
        }
        
        cardContentV.addSubview(loginBtn)
        loginBtn.setTitle("确定", for: .normal)
        loginBtn.setTitleColor(HEXCOLOR(h: 0xD2691E, alpha: 1.0), for: .normal)
        loginBtn.titleLabel?.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(18))
        loginBtn.backgroundColor = HEXCOLOR(h: 0xFFC0CB, alpha: 1.0)
        loginBtn.addOncePressAnimation()
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = WidthScale(20)
        loginBtn.addTarget(self, action: #selector(LoginAction), for: .touchUpInside)
        loginBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameV.snp.bottom).offset(WidthScale(20))
            make.size.equalTo(CGSize(width: WidthScale(208), height: WidthScale(46)))
        }
        
    }
    
    //MARK: - 触摸事件
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func avatarTapAction(){
        let imgPickerVC: TZImagePickerController = TZImagePickerController(maxImagesCount: 1, columnNumber: 5, delegate: self, pushPhotoPickerVc: true)
        imgPickerVC.allowCrop = true
        imgPickerVC.cropRect = CGRect(x: 0, y: imgPickerVC.view.frame.midY - SCREEN_WIDTH/2, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        imgPickerVC.didFinishPickingPhotosHandle = {[weak self](imgs, asset, isSelectOriginalPhoto) in
            if let weakSelf = self{
                weakSelf.avatarImgV.image = imgs?[0]
                weakSelf.avatarImg = imgs?[0]
            }
        }
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    
    @objc func LoginAction(){
        if nickNameTF.text == ""{
            let pulse = CASpringAnimation(keyPath: "position.x")
            pulse.damping = 10;
            pulse.stiffness = 100;
            pulse.mass = 1;
            pulse.initialVelocity = 0;
            pulse.fromValue = nickNameV.layer.position.x - 20
            pulse.toValue = nickNameV.layer.position.x
            pulse.duration = pulse.settlingDuration
            nickNameV.layer.add(pulse, forKey: nil)
        }else{
            userInfo.userName = nickNameTF.text!
            if let avatarImg = avatarImg, let data = avatarImg.jpegData(compressionQuality: 1.0), let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last{
                let url = URL.init(fileURLWithPath: "\(path)/avatar_\(userInfo.id).jpeg")
                do {
                    try data.write(to: url)
                    userInfo.avatarURL = "/avatar_\(userInfo.id).jpeg"
                    if SQLManager.updateUser(userInfo) {
                        Dprint("用户数据更新成功")
                    }else{
                        Dprint("用户数据更新失败")
                    }
                } catch let error {
                    Dprint("头像存储失败\(error)")
                }
            }
            let tabbarVC = LJMainTabBarViewController()
            let navContrller = UINavigationController.init(rootViewController: tabbarVC)
            navContrller.modalPresentationStyle = .fullScreen
            navContrller.modalTransitionStyle = .flipHorizontal
            self.present(navContrller, animated: true, completion: nil)
        }
    }
    //MARK: - 键盘监听
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        UIView.animate(withDuration: 0.3, animations: {
            self.cardContentV.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: WidthScale(279), height: WidthScale(300)))
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
                make.size.equalTo(CGSize(width: WidthScale(279), height: WidthScale(300)))
                make.bottom.equalToSuperview().inset(self.keyBoardHeight)
                make.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
