//
//  MainTabBarController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/5/20.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    ///首页子控制器
    let mainVC: LJMainViewController = LJMainViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.delegate = self
        self.tabBar.isTranslucent = true
        addTabbarChildController()
    }
    
    private func setupOneChildViewController(_ vc:UIViewController,title:String, normalImage:String, selectedImage:String){
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage.init(named: normalImage)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage.init(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        self.addChild(vc)
    }
    
    private func addTabbarChildController(){
        setupOneChildViewController(mainVC, title: "首页", normalImage: "fa5-book", selectedImage: "fa5-book")
//        setupOneChildViewController(messageCtrl, title: "消息", normalImage: "tabbar_2_nor", selectedImage: "tabbar_2_sel")
//        setupOneChildViewController(mineCtrl, title: "我的", normalImage: "tabbar_3_nor", selectedImage: "tabbar_3_sel")
    }

}
