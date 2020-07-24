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
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        interactionInProgress = true
        self.transitionContext = transitionContext
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        maskView = UIVisualEffectView()
        maskView.effect = UIBlurEffect.init(style: .dark)
        toView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        toView?.layer.cornerRadius = WidthScale(10)
        toView?.layer.masksToBounds = true
        transitionContext.containerView.addSubview(toView!)
        transitionContext.containerView.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        transitionContext.containerView.addSubview(fromView!)
        
        if let vc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? MainTabBarController{
            if let cell = vc.mainVC.mainTableView.cellForRow(at: vc.mainVC.didSelectIndexPath) as? LJMainTableViewCell{
                targetRect = cell.bgImgV.convert(cell.bgImgV.bounds, to: vc.view)
                originRect = fromView!.frame
                fromView?.layer.masksToBounds = true
                fromView?.layer.cornerRadius = cell.bgImgV.layer.cornerRadius
            }
        }
        self.toView = toView
        self.transitingView = fromView
    }
    
    open func update(_ percentComplete: CGFloat){
        guard transitionContext != nil else{
            return
        }
        if let fromVC = self.transitionContext.viewController(forKey: .from) as? MakingPlanViewController{
            for view in fromVC.view.subviews {
                if view.tag != 101 && view.tag != 100{
                    if percentComplete <= 0.5{
                        view.alpha = 1 - percentComplete * 2
                    }else{
                        view.alpha = 0
                    }
                }
            }
            if percentComplete > 0.7 && fromVC.targetTitleL.font == UIFont.boldSystemFont(ofSize: WidthScale(24)){
                UIView.animate(withDuration: 0.25, animations: {
                    fromVC.targetTitleL.snp.remakeConstraints { (make) in
                        make.centerY.equalToSuperview().offset(-WidthScale(8))
                        make.left.equalToSuperview().inset(WidthScale(20))
                    }
                    fromVC.view.layoutIfNeeded()
                }) { (finished) in
                    fromVC.targetTitleL.font = UIFont.systemFont(ofSize: WidthScale(20))
                }
            }else if percentComplete < 0.4 && fromVC.targetTitleL.font == UIFont.systemFont(ofSize: WidthScale(20)){
                UIView.animate(withDuration: 0.25, animations: {
                    fromVC.targetTitleL.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().inset(WidthScale(20))
                        make.top.equalToSuperview().inset(NavPlusStatusH)
                    }
                    fromVC.view.layoutIfNeeded()
                }) { (finished) in
                   fromVC.targetTitleL.font = UIFont.boldSystemFont(ofSize: WidthScale(24))
                }
            }
        }
        let width = originRect.width - (originRect.width - targetRect.width) * percentComplete
        let height = originRect.height - (originRect.height - targetRect.height) * percentComplete

        transitingView.frame = CGRect(x: percentComplete * targetRect.origin.x, y: percentComplete * targetRect.origin.y, width: width, height: height)
        maskView.alpha = 1 - percentComplete * 0.5
        toView?.transform = CGAffineTransform(scaleX: 0.8 + 0.2 * percentComplete, y: 0.8 + 0.2 * percentComplete)
    }
    
    func finishBy(cancelled: Bool) {
        self.transitionContext!.cancelInteractiveTransition()
        if cancelled && velocity < 500{
            UIView.animate(withDuration: 0.15, animations: {
                self.transitingView.frame = self.originRect
                self.toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.maskView.effect = nil
                self.transitingView.layer.cornerRadius = 0
                if let fromVC = self.transitionContext.viewController(forKey: .from) as? MakingPlanViewController{
                    for view in fromVC.view.subviews {
                        if view.tag != 101 && view.tag != 100{
                            view.alpha = 1
                        }
                    }
                    fromVC.targetTitleL.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().inset(WidthScale(20))
                        make.top.equalToSuperview().inset(NavPlusStatusH)
                    }
                    fromVC.targetTitleL.font = UIFont.boldSystemFont(ofSize: WidthScale(24))
                }
            }, completion: {completed in
                self.interactionInProgress = false
                self.maskView.removeFromSuperview()
                self.transitionContext!.completeTransition(false)
            })

        } else {
            UIView.animate(withDuration: 0.15, animations: {
                self.transitingView!.frame = self.targetRect
                self.transitingView.layoutIfNeeded()
                self.maskView.effect = nil
                self.toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                if let fromVC = self.transitionContext.viewController(forKey: .from) as? MakingPlanViewController{
                    for view in fromVC.view.subviews {
                        if view.tag != 101 && view.tag != 100{
                            view.alpha = 0
                        }
                    }
                    fromVC.targetTitleL.snp.remakeConstraints { (make) in
                        make.centerY.equalToSuperview().offset(-WidthScale(8))
                        make.left.equalToSuperview().inset(WidthScale(20))
                    }
                    fromVC.targetTitleL.font = UIFont.systemFont(ofSize: WidthScale(20))
                }
            }, completion: {completed in
                self.toView?.layer.cornerRadius = 0
                self.maskView.removeFromSuperview()
                self.transitingView.removeFromSuperview()
                self.transitionContext!.completeTransition(true)
                if let toVC = self.transitionContext.viewController(forKey: .to) as? MainTabBarController, let cell = toVC.mainVC.mainTableView.cellForRow(at: toVC.mainVC.didSelectIndexPath) as? LJMainTableViewCell{
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

}
