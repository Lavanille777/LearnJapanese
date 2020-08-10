//
//  AppDelegate.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/5/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let model = SQLManager.queryUserById(1){
            userInfo = model
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy.MM.dd"
            if dateFormat.string(from: userInfo.loginDate) != dateFormat.string(from: Date()){
                userInfo.todayWordsCount = 0
                userInfo.loginDate = Date()
                if SQLManager.updateUser(userInfo){
                    Dprint("更新数据库成功")
                }else{
                    Dprint("更新数据库失败")
                }
            }
        }
        
        for name in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: name)
            {
                print(fontName)
            }
        }
        
        self.window = UIWindow()
        
        var navContrller = UINavigationController.init(rootViewController: LJMainTabBarViewController())
        if userInfo.userName == ""{
            navContrller = UINavigationController.init(rootViewController: LoginViewController())
        }
        self.window?.rootViewController = navContrller
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
    
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    
    
}

