//
//  LJTransitionAnimator.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/21.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJPushTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration : TimeInterval
    var completeHander : ((Bool) -> Void)?
    
    init(duration : TimeInterval = 0.25){
        self.duration = duration
        super.init()
    }
    //方法1
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // 方法2
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? MakingPlanViewController else{
            return
        }
        
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        
        if let vc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? MainTabBarController{
            
            let maskView: UIVisualEffectView = UIVisualEffectView()
            maskView.effect = nil
            transitionContext.containerView.addSubview(maskView)
            maskView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            transitionContext.containerView.addSubview(toView!)
            
            if let cell = vc.mainVC.mainTableView.cellForRow(at: vc.mainVC.didSelectIndexPath) as? LJMainTableViewCell{
                
                toViewC.navigationController?.navigationBar.alpha = 0
                toView?.isHidden = true
                fromView?.layer.cornerRadius = WidthScale(10)
                let rect = cell.bgImgV.convert(cell.bgImgV.bounds, to: vc.view)
                toView?.layer.masksToBounds = true
                toView?.layer.cornerRadius = cell.bgImgV.layer.cornerRadius
                toView?.frame = rect
                toView?.layoutIfNeeded()
                toView?.isHidden = false
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
                    maskView.effect = UIBlurEffect.init(style: .regular)
                    toViewC.navigationController?.navigationBar.alpha = 1
                    toView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
                    fromView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: { (finished) -> Void in
                    cell.bgImgV.snp.remakeConstraints { (make) in
                        make.center.equalToSuperview()
                        make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(120)))
                    }
                    cell.layoutIfNeeded()
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    toView?.layer.cornerRadius = 0
                    fromView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    maskView.removeFromSuperview()
                    //结束动画，否则会干扰下次动画
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
            
        }
        
        
    }
    
}
