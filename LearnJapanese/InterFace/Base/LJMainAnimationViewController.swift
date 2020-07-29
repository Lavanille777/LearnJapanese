//
//  LJMainAnimationViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/27.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainAnimationViewController: LJBaseViewController, UINavigationControllerDelegate {
    var popAnimation: LJPopTransitionAnimator?
    
    ///交互控制器
    private var interactivePopTransition : LJPopInteractiveTransitioning!
    
    var replaceInteractivePopTransition: LJPopInteractiveTransitioning = LJPopInteractiveTransitioning()
    
    var bgImgV: UIImageView = UIImageView()
    
    ///目标
    var targetTitleL: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIScreenEdgePanGestureRecognizer(target:self,action:#selector(handleGesture(gestureRecognizer:)))
        gesture.edges = .left
        self.view.addGestureRecognizer(gesture)
        
        view.backgroundColor = .white
        view.addSubview(bgImgV)
        bgImgV.tag = 101
        bgImgV.contentMode = .center
        bgImgV.isUserInteractionEnabled = true
//        bgImgV.image = UIImage.init(named: "cell3")
        bgImgV.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        bgImgV.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        targetTitleL.tag = 100
        targetTitleL.font = UIFont.init(name: FontYuanTiRegular, size: WidthScale(24))
        targetTitleL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        view.addSubview(targetTitleL)
        targetTitleL.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalToSuperview().inset(NavPlusStatusH)
        }
        
        createNavbar(navTitle: "", leftIsImage: false, leftStr: "返回", rightIsImage: false, rightStr: nil, leftAction: nil, ringhtAction: nil)
        navgationBarV.backgroundColor = .clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    //MARK: 导航动画
    // 以下----使用UIPercentDrivenInteractiveTransition交互控制器
    @objc func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        var progress = gestureRecognizer.translation(in: gestureRecognizer.view?.superview).x / (SCREEN_WIDTH * 0.8)
        progress = min(1.0, max(0.0, progress))
        
        if gestureRecognizer.state == .began{
            interactivePopTransition = replaceInteractivePopTransition
            self.navigationController?.popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            interactivePopTransition.update(progress)
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            interactivePopTransition.velocity = gestureRecognizer.velocity(in: gestureRecognizer.view?.superview).x
            if interactivePopTransition.transitionContext != nil && interactivePopTransition.interactionInProgress{
                interactivePopTransition.finishBy(cancelled: progress < 0.4)
                interactivePopTransition = nil
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    self.interactivePopTransition.finishBy(cancelled: progress < 0.4)
                    self.interactivePopTransition = nil
                }
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return popAnimation
        }
        return nil
    }
    
    /// 当返回值为nil时，上面的协议返回的push和pop动画才会有作用
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactivePopTransition != nil {
            return interactivePopTransition
        }
        return nil
    }
    
}
