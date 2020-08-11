//
//  UIViewControllerEx.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/28.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

extension UIViewController {
    /// 获取当前视图控制器
    ///
    /// - Returns: 当前视图控制器
    @objc class func getCurrentViewCtrl()->UIViewController{
        var window = UIApplication.shared.keyWindow  //.keywindow must be used from main thread only
        if window?.windowLevel != UIWindow.Level.normal {  //.windowLevel
            let windows = UIApplication.shared.windows
            for subWin in windows {
                if subWin.windowLevel == UIWindow.Level.normal {
                    window = subWin
                    break
                }
            }
        }
        if let frontView = window?.subviews.first{   //.subviews
            let nextResponder = frontView.next  //.next
            if let tabbarCtrl = nextResponder as? UITabBarController{
                if let selectedCtrl = tabbarCtrl.selectedViewController{
                    if let navCtrl = selectedCtrl as? UINavigationController {
                        return UIViewController.getCurrentViewCtrl(navCtrl: navCtrl)
                    }else{
                        return selectedCtrl
                    }
                }else{
                    if let firstCtrl = tabbarCtrl.viewControllers?.first{
                        return firstCtrl
                    }else{
                        return tabbarCtrl
                    }
                }
            }else if let navCtrl = nextResponder as? UINavigationController{
                return UIViewController.getCurrentViewCtrl(navCtrl: navCtrl)
            }else if let viewCtrl = nextResponder as? UIViewController{
                return viewCtrl
            }
        }
        let windowCtrl = window?.rootViewController
        if let tabbarCtrl = windowCtrl as? UITabBarController{
            if let selectedCtrl = tabbarCtrl.selectedViewController {
                if let navCtrl = selectedCtrl as? UINavigationController {
                    return UIViewController.getCurrentViewCtrl(navCtrl: navCtrl)
                }else{
                    return selectedCtrl
                }
            }else{
                if let firstCtrl = tabbarCtrl.viewControllers?.first{
                    return firstCtrl
                }else{
                    return tabbarCtrl
                }
            }
        }else if let navCtrl = windowCtrl as? UINavigationController{
            return UIViewController.getCurrentViewCtrl(navCtrl: navCtrl)
        }else{
            return windowCtrl!
        }
    }
    
    // MARK: - private
    fileprivate class func getCurrentViewCtrl(navCtrl:UINavigationController) -> UIViewController {
        if let visibleCtrl = navCtrl.visibleViewController{
            if let tabbarCtrl = visibleCtrl as? UITabBarController{
                return UIViewController.getCurrentViewCtrl(subTabbarCtrl:tabbarCtrl)
            }else{
                return visibleCtrl
            }
        }else{
            if let firstCtrl = navCtrl.viewControllers.first{
                return firstCtrl
            }else{
                return navCtrl
            }
        }
    }
    
    fileprivate class func getCurrentViewCtrl(subTabbarCtrl:UITabBarController) -> UIViewController {
        if let selectedCtrl = subTabbarCtrl.selectedViewController{
            if let subNavCtrl = selectedCtrl as? UINavigationController {
                if let subVisibleCtrl = subNavCtrl.visibleViewController{
                    return subVisibleCtrl
                }else{
                    if let firstCtrl = subNavCtrl.viewControllers.first{
                        return firstCtrl
                    }else{
                        return subNavCtrl
                    }
                }
            }else{
                return selectedCtrl
            }
        }else{
            if let firstCtrl = subTabbarCtrl.viewControllers?.first{
                return firstCtrl
            }else{
                return subTabbarCtrl
            }
        }
    }
    
    

}
