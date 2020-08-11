//
//  MineViewController.swift
//  LearnJapanese
//  我的页面
//  Created by 唐星宇 on 2020/7/31.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import TZImagePickerController

class MineViewController: LJBaseViewController, TZImagePickerControllerDelegate {
    ///圆角背景
    var roundCornerBgV: UIView = UIView()
    ///头像
    var avatarV: UIView = UIView()
    var avatarImgV: UIImageView = UIImageView()
    ///昵称
    var nickNameL: UILabel = UILabel()
    ///坚持天数
    var daysCountL: UILabel = UILabel()
    ///卡片
    var cardV: UIView = UIView()
    ///单词环形进度条
    var wordsProgressView: LJCycleProgressView = LJCycleProgressView.init(withWidth: WidthScale(10), radious: WidthScale(50), trackColor: HEXCOLOR(h: 0xe6e6e6, alpha: 1.0), progressStartColor: HEXCOLOR(h: 0x00BFFF, alpha: 0.2), progressEndColor: HEXCOLOR(h: 0x6495ED, alpha: 1.0))
    ///考试环形进度条
    var targetProgressView: LJCycleProgressView = LJCycleProgressView.init(withWidth: WidthScale(10), radious: WidthScale(50), trackColor: HEXCOLOR(h: 0xe6e6e6, alpha: 1.0), progressStartColor: HEXCOLOR(h: 0xfa8c16, alpha: 0.2), progressEndColor: HEXCOLOR(h: 0xfa8c16, alpha: 1.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = HEXCOLOR(h: 0xfbfafb, alpha: 1.0)
        
        view.addSubview(roundCornerBgV)
        roundCornerBgV.backgroundColor = HEXCOLOR(h: 0x6495ED, alpha: 1.0)
        roundCornerBgV.layer.cornerRadius = WidthScale(40)
        roundCornerBgV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(-WidthScale(40))
            make.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(347))
        }
        
        view.addSubview(cardV)
        cardV.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1.0)
        cardV.layer.cornerRadius = WidthScale(20)
        cardV.layer.shadowRadius = WidthScale(10)
        cardV.layer.shadowColor = HEXCOLOR(h: 0x101010, alpha: 0.3).cgColor
        cardV.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        cardV.layer.shadowOpacity = 1.0
        cardV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(233)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(WidthScale(115))
        }
        
        cardV.addSubview(avatarV)
        avatarV.backgroundColor = .white
        avatarV.layer.cornerRadius = WidthScale(44)
        avatarV.layer.shadowColor = HEXCOLOR(h: 0x483D8B, alpha: 0.8).cgColor
        avatarV.layer.shadowOffset = CGSize(width: WidthScale(2), height: WidthScale(2))
        avatarV.layer.shadowRadius = WidthScale(3)
        avatarV.layer.shadowOpacity = 1.0
        avatarV.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(88))
            make.top.left.equalToSuperview().inset(WidthScale(20))
        }
        
        avatarV.addSubview(avatarImgV)
        avatarImgV.layer.cornerRadius = WidthScale(44)
        avatarImgV.contentMode = .scaleAspectFill
        avatarImgV.isUserInteractionEnabled = true
        avatarImgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapAction)))
        avatarImgV.layer.masksToBounds = true
        do {
            try avatarImgV.image = UIImage(data: Data(contentsOf: URL.init(fileURLWithPath: "\(docPath)\(userInfo.avatarURL)")))
        } catch let error {
            Dprint("头像读取失败===\(error)")
            avatarImgV.image = UIImage(named: "avatar")
        }
        avatarImgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        cardV.addSubview(nickNameL)
        nickNameL.text = userInfo.userName
        nickNameL.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(26))
        nickNameL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        nickNameL.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgV.snp.right).offset(WidthScale(20))
            make.centerY.equalTo(avatarImgV)
        }
        
        
    }
    
    
    @objc func avatarTapAction(){
        let imgPickerVC: TZImagePickerController = TZImagePickerController(maxImagesCount: 1, columnNumber: 5, delegate: self, pushPhotoPickerVc: true)
        imgPickerVC.allowCrop = true
        imgPickerVC.cropRect = CGRect(x: 0, y: imgPickerVC.view.frame.midY - SCREEN_WIDTH/2, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        imgPickerVC.didFinishPickingPhotosHandle = {[weak self](imgs, asset, isSelectOriginalPhoto) in
            if let weakSelf = self{
                weakSelf.avatarImgV.image = imgs?[0]
                if let avatarImg = imgs?[0], let data = avatarImg.jpegData(compressionQuality: 1.0), let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last{
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
            }
        }
        
        let alert = LJAlertView(withTitle: "确定要修改头像吗", confirmTitle: nil, cancelTitle: nil, confirmed: {
            self.present(imgPickerVC, animated: true, completion: nil)
        }, canceled: nil)
        
        alert.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
}
