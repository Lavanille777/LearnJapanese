//
//  LJTabbarView.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/3.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJTabbarView: UIView {
    
    var bgView: UIVisualEffectView = UIVisualEffectView()
    
    var tabbarItems: [UIButton] = [UIButton(), UIButton(), UIButton()]
    
    var selBGView: UIView = UIView()
    
    var selTabbarItemBlk: ((_ btn: UIButton)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    func setupUI() {
        bgView.effect = UIBlurEffect(style: .prominent)
//        bgView.layer.borderWidth = WidthScale(0.5)
//        bgView.layer.borderColor = HEXCOLOR(h: 0xFFB6C1, alpha: 0.5).cgColor
        bgView.backgroundColor = HEXCOLOR(h: 0xFF69B4, alpha: 0.3)
        self.addSubview(bgView)
        bgView.layer.cornerRadius = WidthScale(15)
        bgView.layer.masksToBounds = true
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgView.contentView.addSubview(selBGView)
        selBGView.backgroundColor = HEXCOLOR(h: 0xFFC0CB, alpha: 0.7)
        selBGView.layer.masksToBounds = true
        selBGView.layer.cornerRadius = WidthScale(10)
        selBGView.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(48))
            make.left.equalToSuperview().inset(WidthScale(CGFloat(28)))
            make.centerY.equalToSuperview()
        }
        
        for i in 0 ..< 3 {
            bgView.contentView.addSubview(tabbarItems[i])
            tabbarItems[i].snp.makeConstraints { (make) in
                make.width.height.equalTo(WidthScale(44))
                make.left.equalToSuperview().inset(WidthScale(CGFloat(i * 86 + 30)))
                make.centerY.equalToSuperview()
            }
            tabbarItems[i].tag = i
            tabbarItems[i].setImage(UIImage(named: "tabbar_\(i + 1)"), for: .normal)
            tabbarItems[i].addTarget(self, action: #selector(tabbarItemAction), for: .touchUpInside)
            
//            tabbarItems[i].backgroundColor = .red
        }
    }
    
    @objc func tabbarItemAction(sender: UIButton){
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            let x = self.selBGView.frame.minX + (WidthScale(CGFloat(sender.tag * 86 + 28)) - self.selBGView.frame.minX) / 2
            self.selBGView.snp.remakeConstraints { (make) in
                make.height.equalTo(WidthScale(48))
                make.width.equalTo(WidthScale(80))
                make.left.equalToSuperview().inset(x)
                make.centerY.equalToSuperview()
            }
            self.layoutIfNeeded()
        }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                self.selBGView.snp.remakeConstraints { (make) in
                    make.width.height.equalTo(WidthScale(48))
                    make.left.equalToSuperview().inset(WidthScale(CGFloat(sender.tag * 86 + 28)))
                    make.centerY.equalToSuperview()
                }
                
                self.layoutIfNeeded()
            })
        }
        
        if let selTabbarItemBlk = selTabbarItemBlk{
            selTabbarItemBlk(sender)
        }
    }

}
