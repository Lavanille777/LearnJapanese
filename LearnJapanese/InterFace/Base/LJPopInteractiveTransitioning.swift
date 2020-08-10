//
//  LJPopInteractiveTransitioning.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/21.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJPopInteractiveTransitioning: NSObject, UIViewControllerInteractiveTransitioning {
    var interactionInProgress = false //用于指示交互是否在进行中。
    
    var transitionContext : UIViewControllerContextTransitioning!
    var transitingView : UIView!
    var velocity: CGFloat = 0
    
    var fromVC: UIViewController!
    var toVC: UIViewController!
    var toView: UIView!
    var maskView: UIVisualEffectView!
    
    var targetRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var originRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var touchView: UIView?
    var touchViewRect: CGRect?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(setTouchView), name: NSNotification.Name(MAINVIEWPUSHTOUCH), object: nil)
    }
    
    @objc func setTouchView(_ noti: Notification) {
        if let view = noti.userInfo?["view"] as? UIView, let rect = noti.userInfo?["rect"] as? CGRect{
            touchView = view
            touchViewRect = rect
        }
    }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        interactionInProgress = true
        self.transitionContext = transitionContext
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        maskView = UIVisualEffectView()
        maskView.effect = UIBlurEffect.init(style: .dark)
        toView?.layer.cornerRadius = WidthScale(10)
        toView?.layer.masksToBounds = true
        transitionContext.containerView.addSubview(toView!)
        transitionContext.containerView.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        transitionContext.containerView.addSubview(fromView!)
        
        if let vc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? LJMainTabBarViewController{
            if let cell = touchView as? LJMainTableViewCell , let rect = touchViewRect{
                targetRect = rect
                originRect = fromView!.frame
                fromView?.layer.masksToBounds = true
                fromView?.layer.cornerRadius = cell.bgImgV.layer.cornerRadius
            }else if let cell = touchView as? LJMainCollectionViewCell, let rect = touchViewRect{
                targetRect = rect
                originRect = fromView!.frame
                fromView?.layer.masksToBounds = true
                fromView?.layer.cornerRadius = cell.bgImgV.layer.cornerRadius
            }
        }
        
        if let fromVC = self.transitionContext.viewController(forKey: .from) as? LJImageTextViewController{
            fromVC.scrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        self.toView = toView
        self.transitingView = fromView
        toView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    open func update(_ percentComplete: CGFloat){
        guard transitionContext != nil else{
            return
        }
        if let fromVC = self.transitionContext.viewController(forKey: .from) as? LJMainAnimationViewController{
            let width = originRect.width - (originRect.width - targetRect.width) * percentComplete
            let height = originRect.height - (originRect.height - targetRect.height) * percentComplete
            
            transitingView.frame = CGRect(x: percentComplete * targetRect.origin.x, y: percentComplete * targetRect.origin.y, width: width, height: height)
            maskView.alpha = 1 - percentComplete * 0.5
            fromVC.navgationBarV.alpha = 1 - percentComplete
            toView?.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentComplete, y: 0.8 + 0.2 * percentComplete)
            if let fromVC = fromVC as? LJImageTextViewController{
                fromVC.imageV.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.left.right.equalTo(fromVC.view)
                    make.height.equalTo(fromVC.view.frame.width * WidthScale(140/160))
                }
            }else{
                for view in fromVC.view.subviews {
                    if view.tag != 101 && view.tag != 100{
                        if percentComplete <= 0.5{
                            view.alpha = 1 - percentComplete * 2
                        }else{
                            view.alpha = 0
                        }
                    }
                }
            }
            fromVC.targetTitleL.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset((fromVC.view.frame.height / 2 - NavPlusStatusH - fromVC.targetTitleL.frame.height) * percentComplete + NavPlusStatusH)
                make.left.equalToSuperview().inset(WidthScale(20))
            }
            fromVC.view.layoutIfNeeded()
            if percentComplete > 0.4 && fromVC.targetTitleL.font == UIFont.init(name: FontYuanTiRegular, size: WidthScale(24)){
                fromVC.targetTitleL.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(20))
            }else if percentComplete < 0.4 && fromVC.targetTitleL.font == UIFont.init(name: FontYuanTiRegular, size: WidthScale(20)){
                fromVC.targetTitleL.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(24))
            }
        }
    }
    
    func finishBy(cancelled: Bool) {
        self.transitionContext!.cancelInteractiveTransition()
        if cancelled && velocity < 500{
            UIView.animate(withDuration: 0.15, animations: {
                self.transitingView.frame = self.originRect
                self.toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.maskView.effect = nil
                self.transitingView.layer.cornerRadius = 0
                if let fromVC = self.transitionContext.viewController(forKey: .from) as? LJMainAnimationViewController{
                    if let fromVC = fromVC as? LJImageTextViewController{
                        fromVC.imageV.snp.remakeConstraints { (make) in
                            make.top.equalToSuperview()
                            make.left.right.equalTo(fromVC.view)
                            make.height.equalTo(fromVC.view.frame.width * WidthScale(140/160))
                        }
                        fromVC.navgationBarV.alpha = 1
                    }else{
                        for view in fromVC.view.subviews {
                            if view.tag != 101 && view.tag != 100{
                                view.alpha = 1
                            }
                        }
                    }
                    fromVC.targetTitleL.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().inset(WidthScale(20))
                        make.top.equalToSuperview().inset(NavPlusStatusH)
                    }
                    fromVC.targetTitleL.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(24))
                }
            }, completion: {completed in
                self.interactionInProgress = false
                self.maskView.removeFromSuperview()
                self.transitionContext!.completeTransition(false)
            })
            
        } else {
            if let fromVC = self.transitionContext.viewController(forKey: .from) as? LJMainAnimationViewController{
                if let fromVC = fromVC as? LJImageTextViewController{
                    fromVC.imageV.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview()
                        make.left.right.equalTo(fromVC.view)
                        make.height.equalTo(fromVC.view.frame.width * WidthScale(140/160))
                    }
                    fromVC.navgationBarV.alpha = 0
                }else{
                    for view in fromVC.view.subviews {
                        if view.tag != 101 && view.tag != 100{
                            view.alpha = 0
                        }
                    }
                }
                fromVC.targetTitleL.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview().offset(-WidthScale(8))
                    make.left.equalToSuperview().inset(WidthScale(20))
                }
                fromVC.targetTitleL.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(20))
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.transitingView!.frame = self.targetRect
                self.maskView.effect = nil
                self.toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                if let fromVC = self.transitionContext.viewController(forKey: .from) as? LJMainAnimationViewController{
                    if let fromVC = fromVC as? LJImageTextViewController{
                        fromVC.imageV.snp.remakeConstraints { (make) in
                            make.top.equalToSuperview()
                            make.left.right.equalTo(fromVC.view)
                            make.height.equalTo(fromVC.view.frame.width * WidthScale(140/160))
                        }
                    }
                }
                self.transitingView.layoutIfNeeded()
            }, completion: {completed in
                self.toView?.layer.cornerRadius = 0
                self.maskView.removeFromSuperview()
                self.transitingView.removeFromSuperview()
                self.transitionContext!.completeTransition(true)
                if let toVC = self.transitionContext.viewController(forKey: .to) as? LJMainTabBarViewController, let cell = self.touchView{
                    toVC.view.layoutIfNeeded()
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                        cell.transform = CGAffineTransform.init(a: 0.98, b: 0, c: 0, d: 0.98, tx: 0, ty: WidthScale(5))
                    }) { (finish) in
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                            cell.transform = CGAffineTransform.init(a: 1.0, b: 0, c: 0, d: 1.02, tx: 0, ty: 0)
                        }) { (finish) in
                            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                            }) { (finish) in
                                self.interactionInProgress = false
                            }
                        }
                    }
                }
            })
        }
    }
    
    open func cancel(){
        
    }
    
    open func finish(){
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(MAINVIEWPUSHTOUCH), object: nil)
    }
    
}
