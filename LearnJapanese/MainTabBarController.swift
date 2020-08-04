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
    ///查词典子控制器
    let dictionaryVC: SearchWordViewController = SearchWordViewController()
    ///我的子控制器
    let mineCtrl: MineViewController = MineViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        self.delegate = self
        self.tabBar.isTranslucent = true
//        self.tabBar.snp.remakeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview().inset(WidthScale(20))
//            make.height.equalTo(WidthScale(44))
//        }
        addTabbarChildController()
    }
    
    private func setupOneChildViewController(_ vc:UIViewController,title:String, normalImage:String, selectedImage:String){
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage.init(named: normalImage)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage.init(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        self.addChild(vc)
    }
    
    private func addTabbarChildController(){
        setupOneChildViewController(mainVC, title: "首页", normalImage: "tabbar_1_sel", selectedImage: "tabbar_1_sel")
        setupOneChildViewController(dictionaryVC, title: "词典", normalImage: "tabbar_1_sel", selectedImage: "tabbar_1_sel")
        setupOneChildViewController(mineCtrl, title: "我的", normalImage: "tabbar_1_sel", selectedImage: "tabbar_1_sel")
    }

}
