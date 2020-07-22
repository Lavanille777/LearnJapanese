//
//  LJPopTransitionAnimator.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/21.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJPopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning{
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
        guard let fromViewC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? MakingPlanViewController else{
            return
        }
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        toView?.alpha = 0
        if let vc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? MainTabBarController{
            let maskView: UIVisualEffectView = UIVisualEffectView()
            maskView.effect = UIBlurEffect.init(style: .regular)
            //这句一定要，这时toView是不会自己加上来的
            transitionContext.containerView.addSubview(toView!)
            transitionContext.containerView.addSubview(maskView)
            maskView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            toView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            transitionContext.containerView.addSubview(fromView!)
            if let cell = vc.mainVC.mainTableView.cellForRow(at: vc.mainVC.didSelectIndexPath) as? LJMainTableViewCell{
                let rect = cell.bgImgV.convert(cell.bgImgV.bounds, to: vc.view)
                fromView?.layer.masksToBounds = true
                fromView?.layer.cornerRadius = cell.bgImgV.layer.cornerRadius
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
                    fromView?.frame = rect
                    fromView?.layoutIfNeeded()
                    toView?.alpha = 1
                    maskView.effect = nil
                    toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    fromViewC.navigationController?.navigationBar.alpha = 0
                    for view in fromViewC.view.subviews {
                        if view.tag != 101 && view.tag != 100{
                            view.alpha = 0
                        }
                    }
                    fromViewC.targetTitleL.snp.remakeConstraints { (make) in
                        make.centerY.equalToSuperview().offset(-WidthScale(8))
                        make.left.equalToSuperview().inset(WidthScale(20))
                    }
                    fromViewC.targetTitleL.font = UIFont.systemFont(ofSize: WidthScale(20))
                    fromViewC.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    //结束动画，否则会干扰下次动画
                    fromView?.isHidden = true
                    fromView?.removeFromSuperview()
                    maskView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
            
        }
        
        
    }

}
