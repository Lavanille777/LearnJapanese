//
//  LJTransitionAnimator.swift
//  LearnJapanese
//  首页push动画
//  Created by 唐星宇 on 2020/7/21.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJPushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration : TimeInterval
    var completeHander : ((Bool) -> Void)?
    
    var touchView: UIView?
    var touchViewRect: CGRect?
    var fromVC: UIViewController?
    var toVC: UIViewController?
    
    init(duration : TimeInterval = 0.25){
        self.duration = duration
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(setTouchView), name: NSNotification.Name(MAINVIEWPUSHTOUCH), object: nil)
    }
    
    @objc func setTouchView(_ noti: Notification) {
        if let view = noti.userInfo?["view"] as? UIView, let rect = noti.userInfo?["rect"] as? CGRect{
            touchView = view
            touchViewRect = rect
        }
    }
    
    //方法1
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // 方法2
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? LJMainAnimationViewController,let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let touchView = touchView else{
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        let toView = toVC.view
        let fromView = fromVC.view
    
        if fromVC is LJMainTabBarViewController{
            let maskView: UIVisualEffectView = UIVisualEffectView()
            maskView.effect = nil
            
            transitionContext.containerView.addSubview(maskView)
            maskView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            transitionContext.containerView.addSubview(toView!)
            fromView?.layer.cornerRadius = WidthScale(10)
            toView?.layer.masksToBounds = true
            toView?.layer.cornerRadius = WidthScale(10)
            
            //主页列表转场动画
            if let cell = touchView as? LJMainTableViewCell, let rect = touchViewRect{
                toView?.frame = rect
                toView?.layoutIfNeeded()
                for view in toVC.view.subviews {
                    if view.tag != 101 && view.tag != 100{
                        view.alpha = 0
                    }
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { () -> Void in
                    maskView.effect = UIBlurEffect.init(style: .regular)
                    toView?.frame = CGRect(x: WidthScale(10), y: -WidthScale(15), width: SCREEN_WIDTH - WidthScale(20), height: SCREEN_HEIGHT - WidthScale(20))
                    fromView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    for view in toVC.view.subviews {
                        if view.tag != 101 && view.tag != 100{
                            view.alpha = 0.5
                        }
                    }
                    toView?.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                        toView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                        for view in toVC.view.subviews {
                            if view.tag != 101 && view.tag != 100{
                                view.alpha = 1
                            }
                        }
                        toView?.layoutIfNeeded()
                    }, completion: { (finished) -> Void in
                        cell.bgImgV.snp.remakeConstraints { (make) in
                            make.center.equalToSuperview()
                            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(120)))
                        }
                        toView?.layer.cornerRadius = 0
                        cell.layoutIfNeeded()
                        cell.transform = CGAffineTransform(translationX: 0, y: 0)
                        fromView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                        fromView?.layer.cornerRadius = 0
                        maskView.removeFromSuperview()
                        //结束动画，否则会干扰下次动画
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    })
                })
            }//文化介绍部分的点击动画
            else if let cell = touchView as? LJMainCollectionViewCell, let toVC = toVC as? LJImageTextViewController, let rect = touchViewRect{
                toVC.view.frame = rect
                toVC.imageV.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.left.right.equalTo(toVC.view)
                    make.height.equalTo(toVC.view.frame.width * 140/160)
                }
                toVC.textBGV.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().inset(toVC.view.frame.width * 140/160)
                    make.left.right.equalTo(toVC.view)
                    make.bottom.equalTo(toVC.scrollV).offset(WidthScale(1000))
                }
                toVC.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { () -> Void in
                    maskView.effect = UIBlurEffect.init(style: .regular)
                    toVC.view.frame = CGRect(x: WidthScale(10), y: -WidthScale(15), width: SCREEN_WIDTH - WidthScale(20), height: SCREEN_HEIGHT - WidthScale(20))
                    fromView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    toVC.imageV.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview()
                        make.left.right.equalTo(toVC.view)
                        make.height.equalTo(toVC.view.frame.width * 140/160)
                    }
                    toVC.textBGV.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview().inset(toVC.view.frame.width * 140/160)
                        make.left.right.equalTo(toVC.view)
                        make.bottom.equalTo(toVC.scrollV).offset(WidthScale(1000))
                    }
                    toVC.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                        toVC.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                        toVC.imageV.snp.remakeConstraints { (make) in
                            make.top.equalToSuperview()
                            make.left.right.equalTo(toVC.view)
                            make.height.equalTo(toVC.view.frame.width * 140/160)
                        }
                        toVC.textBGV.snp.remakeConstraints { (make) in
                            make.top.equalToSuperview().inset(toVC.view.frame.width * 140/160)
                            make.left.right.equalTo(toVC.view)
                            make.bottom.equalTo(toVC.scrollV).offset(WidthScale(1000))
                        }
                        toVC.view.layoutIfNeeded()
                    }, completion: { (finished) -> Void in
                        cell.bgImgV.snp.remakeConstraints { (make) in
                            make.center.equalToSuperview()
                            make.size.equalTo(rect.size)
                        }
                        toView?.layer.cornerRadius = 0
                        cell.layoutIfNeeded()
                        cell.transform = CGAffineTransform(translationX: 0, y: 0)
                        fromView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                        fromView?.layer.cornerRadius = 0
                        maskView.removeFromSuperview()
                        //结束动画，否则会干扰下次动画
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    })
                })
            }
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(MAINVIEWPUSHTOUCH), object: nil)
    }
}
