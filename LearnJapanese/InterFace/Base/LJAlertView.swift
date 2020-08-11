//
//  LJAlertView.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/11.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
enum LJAlertViewStyle {
    case oneBtn
    case twoBtns
}

class LJAlertView: UIView {
    ///背景遮罩
    var bgView: UIView = UIView()
    ///弹框
    var alertCard: UIView = UIView()
    ///确认按钮
    var confirmBtn: UIButton = UIButton()
    ///确认文字
    var confirmStr: String = "确认"
    ///取消按钮
    var cancelBtn: UIButton = UIButton()
    ///取消文字
    var cancelStr: String = "取消"
    ///提示信息
    var titleL: UILabel = UILabel()
    
    var confirmBlk: (()->())?
    var cancelBlk: (()->())?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(withTitle title: String, confirmTitle: String?, cancelTitle: String?, confirmed: (()->())?, canceled: (()->())?){
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        titleL.text = title
        confirmBlk = confirmed
        cancelBlk = canceled
        
        confirmStr = confirmTitle ?? "确认"
        cancelStr = cancelTitle ?? "取消"
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    func setupUI() {
        self.addSubview(bgView)
        bgView.backgroundColor = HEXCOLOR(h: 0x000000, alpha: 0.2)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(alertCard)
        alertCard.backgroundColor = HEXCOLOR(h: 0xFFFAFA, alpha: 1.0)
        alertCard.layer.cornerRadius = WidthScale(20)
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
        
        alertCard.addSubview(confirmBtn)
        confirmBtn.titleLabel?.textAlignment = .center
        confirmBtn.setTitle(confirmStr, for: .normal)
        confirmBtn.setTitleColor(HEXCOLOR(h: 0x330000, alpha: 1.0), for: .normal)
        confirmBtn.titleLabel?.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(18))
        confirmBtn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        confirmBtn.snp.makeConstraints { (make) in
            make.bottom.left.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(150), height: WidthScale(60)))
        }
        
        alertCard.addSubview(cancelBtn)
        cancelBtn.titleLabel?.textAlignment = .center
        cancelBtn.setTitle(cancelStr, for: .normal)
        cancelBtn.setTitleColor(HEXCOLOR(h: 0xcc6633, alpha: 1.0), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(18))
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(150), height: WidthScale(60)))
        }
        
    }
    
    @objc func confirmAction(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.bgView.alpha = 0
            self.alertCard.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.layoutIfNeeded()
        }) { (finised) in
            self.removeFromSuperview()
            if let blk = self.confirmBlk{
                blk()
            }
        }

    }
    
    @objc func cancelAction(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.bgView.alpha = 0
            self.alertCard.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.layoutIfNeeded()
        }) { (finised) in
            self.removeFromSuperview()
            if let blk = self.cancelBlk{
                blk()
            }
        }
    }
    
    func show(){
        bgView.alpha = 0
        alertCard.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIViewController.getCurrentViewCtrl().view.addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.bgView.alpha = 0.5
            self.alertCard.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.layoutIfNeeded()
        }) { (finised) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.bgView.alpha = 1
                self.alertCard.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
