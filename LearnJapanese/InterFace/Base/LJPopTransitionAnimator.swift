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
    var touchView: UIView?
    var touchViewRect: CGRect?
    
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
        guard let fromViewC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? LJMainAnimationViewController else{
            return
        }
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view
        toView?.alpha = 0
        if let vc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? LJMainTabBarViewController{
            let maskView: UIVisualEffectView = UIVisualEffectView()
            maskView.effect = UIBlurEffect.init(style: .regular)
            transitionContext.containerView.addSubview(toView!)
            transitionContext.containerView.addSubview(maskView)
            maskView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            toView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            transitionContext.containerView.addSubview(fromView!)
            
            if let cell = touchView as? LJMainTableViewCell, let rect = touchViewRect{
                fromView?.layer.masksToBounds = true
                fromView?.layer.cornerRadius = cell.bgImgV.layer.cornerRadius
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
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
                    fromViewC.targetTitleL.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(20))
                    fromViewC.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    //结束动画，否则会干扰下次动画
                    fromView?.isHidden = true
                    fromView?.removeFromSuperview()
                    maskView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                        cell.transform = CGAffineTransform.init(a: 0.98, b: 0, c: 0, d: 0.98, tx: 0, ty: WidthScale(5))
                    }) { (finish) in
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                            cell.transform = CGAffineTransform.init(a: 1.02, b: 0, c: 0, d: 1.02, tx: 0, ty: 0)
                        }) { (finish) in
                            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                            }) { (finish) in
                                //                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                            }
                        }
                    }
                })
            }
            else if let cell = touchView as? LJMainCollectionViewCell, let fromViewC = fromViewC as? LJImageTextViewController, let rect = touchViewRect{
                fromView?.layer.masksToBounds = true
                fromView?.layer.cornerRadius = cell.bgImgV.layer.cornerRadius
                fromViewC.scrollV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
                    toView?.alpha = 1
                    maskView.effect = nil
                    toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    fromViewC.view.frame = rect
                    fromViewC.imageV.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview()
                        make.left.right.equalTo(fromViewC.view)
                        make.height.equalTo(fromViewC.view.frame.width * WidthScale(140/160))
                    }
                    fromViewC.navgationBarV.alpha = 0
                    fromViewC.view.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    //结束动画，否则会干扰下次动画
                    fromView?.removeFromSuperview()
                    maskView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                        cell.transform = CGAffineTransform.init(a: 0.98, b: 0, c: 0, d: 0.98, tx: 0, ty: WidthScale(5))
                    }) { (finish) in
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                            cell.transform = CGAffineTransform.init(a: 1.02, b: 0, c: 0, d: 1.02, tx: 0, ty: 0)
                        }) { (finish) in
                            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                                cell.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                            }) { (finish) in
                                //                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                            }
                        }
                    }
                })
            }
            
        }
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(MAINVIEWPUSHTOUCH), object: nil)
    }
    
}
