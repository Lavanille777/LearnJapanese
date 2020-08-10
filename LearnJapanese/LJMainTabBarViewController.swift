//
//  LJMainTabBarViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/3.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainTabBarViewController: LJBaseViewController {
    
    var tabbarView: LJTabbarView = LJTabbarView()
    
    var currentIndex: Int = 0
    
    ///首页子控制器
    let mainVC: LJMainViewController = LJMainViewController()
    ///查词典子控制器
    let dictionaryVC: SearchWordViewController = SearchWordViewController()
    ///我的子控制器
    let mineCtrl: MineViewController = MineViewController()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(tabbarView)
        tabbarView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(WidthScale(66))
            make.bottom.equalToSuperview().inset(IPHONEX_BH + WidthScale(20))
            make.left.right.equalToSuperview().inset(WidthScale(50))
        }
        
        tabbarView.layer.cornerRadius = WidthScale(15)
        tabbarView.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.5).cgColor
        tabbarView.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        tabbarView.layer.shadowRadius = WidthScale(5)
        tabbarView.layer.shadowOpacity = 1.0
        tabbarView.selTabbarItemBlk = {[weak self] (btn) in
            if let weakSelf = self{
                if btn.tag != weakSelf.currentIndex{
                    weakSelf.children[weakSelf.currentIndex].view.removeFromSuperview()
                    weakSelf.view.insertSubview(weakSelf.children[btn.tag].view, belowSubview: weakSelf.tabbarView)
                    weakSelf.currentIndex = btn.tag
                }
            }
        }
        
        mainVC.view.tag = 0
        self.addChild(mainVC)
        dictionaryVC.view.tag = 1
        self.addChild(dictionaryVC)
        mineCtrl.view.tag = 2
        self.addChild(mineCtrl)
        
        view.insertSubview(mainVC.view, belowSubview: tabbarView)
    }

}
