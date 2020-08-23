//
//  UIViewEx.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/7.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 添加渐变层
    ///
    /// - Parameters:
    ///   - colors: 渐变色值
    ///   - locations: 颜色所在位置(默认开始结束处)
    ///   - isHor: 是否是横向渐变(默认竖向)
    /// - Returns: 渐变层
    @discardableResult func addGradientLayer(colors: [CGColor], locations: [NSNumber] = [0.0, 1.0], isHor: Bool = false) -> CAGradientLayer {
        let graLayer = CAGradientLayer()
        graLayer.frame = self.bounds
        graLayer.backgroundColor = UIColor.clear.cgColor
        graLayer.colors = colors //设置渐变色
        graLayer.locations = locations
        if isHor{ //设置横向渐变
            graLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)  //默认.5,0
            graLayer.endPoint = CGPoint.init(x: 1.0, y: 0.0)  //默认.5,1
        }
        self.layer.insertSublayer(graLayer, at: 0)
        return graLayer
    }
    
    private struct AssociatedKeys {
        static var timerKey = 100
    }
    
    var timer: Timer? {
        get{
            guard let t = objc_getAssociatedObject(self,  &AssociatedKeys.timerKey) as? Timer else {
                return nil
            }
            return t
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.timerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult func addPressAnimation() -> UILongPressGestureRecognizer {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pressAction))
        longPress.minimumPressDuration = 0
        longPress.cancelsTouchesInView = false
        if let self = self as? UIGestureRecognizerDelegate{
            longPress.delegate = self
        }
        self.addGestureRecognizer(longPress)
        return longPress
    }
    
    @discardableResult func addOncePressAnimation() -> UILongPressGestureRecognizer {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(oncePressAction))
        longPress.minimumPressDuration = 0
        longPress.cancelsTouchesInView = false
        if let self = self as? UIGestureRecognizerDelegate{
            longPress.delegate = self
        }
        self.addGestureRecognizer(longPress)
        return longPress
    }
    
    @objc func oncePressAction(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
            }, completion: nil)
            
        }
        
        if sender.state == .changed || sender.state == .ended || sender.state == .cancelled{
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    @objc func pressAction(_ sender: UILongPressGestureRecognizer){
        var scale: CGFloat = 1
        if sender.state == .began {
            timer = Timer.scheduledTimer(withTimeInterval: 0.017, repeats: true, block: { (timer) in
                scale -= 0.01
                if scale > 0.9{
                    self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
                }
            })
            timer?.fire()
        }
        if sender.state == .changed || sender.state == .ended || sender.state == .cancelled{
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }
            if let timer = timer{
                timer.invalidate()
            }
            timer = nil
        }
    }
    
    ///获取当前视图所在导航控制器
    func currentNavViewController() -> UINavigationController? {
        var n = next
        while n != nil {
            if n is UINavigationController {
                return n as? UINavigationController
            }
            n = n?.next
        }
        return nil
    }
    
    class func makeToast(_ str: String){
        DispatchQueue.main.async {
            for view in LJToastView.shared().subviews{
                view.removeFromSuperview()
            }
            
            let mesL: UILabel = UILabel()
            mesL.text = str
            mesL.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(16))
            mesL.textColor = HEXCOLOR(h: 0xD2691E, alpha: 1.0)
            mesL.numberOfLines = 0
            LJToastView.shared().addSubview(mesL)
            
            mesL.snp.makeConstraints { (make) in
                make.left.top.right.bottom.equalToSuperview().inset(WidthScale(10))
            }
            
            if LJToastView.shared().superview == nil{
                UIApplication.shared.windows[0].addSubview(LJToastView.shared())
                LJToastView.shared().snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().inset(WidthScale(80) + IPHONEX_BH)
                    make.centerX.equalToSuperview()
                    make.left.greaterThanOrEqualToSuperview().inset(WidthScale(20))
                    make.right.lessThanOrEqualToSuperview().inset(WidthScale(20))
                }
                LJToastView.shared().layoutIfNeeded()
                LJToastView.shared().alpha = 0
                LJToastView.shared().transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            
            if let curTask = LJToastView.shared().task{
                DispatchQueue.main.cancel(curTask)
            }
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                LJToastView.shared().alpha = 1
                LJToastView.shared().transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { (finished) in
                if finished{
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
                        LJToastView.shared().transform = CGAffineTransform(scaleX: 1, y: 1)
                    }) { (finished) in
                        if finished{
                            if let curTask = LJToastView.shared().task{
                                DispatchQueue.main.cancel(curTask)
                            }
                            let task = DispatchQueue.main.delay(2) {
                                LJToastView.shared().task = nil
                                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                                    LJToastView.shared().alpha = 0
                                    LJToastView.shared().transform = CGAffineTransform(translationX: SCREEN_WIDTH, y: 0)
                                }) { (finished) in
                                    LJToastView.shared().removeFromSuperview()
                                }
                            }
                            LJToastView.shared().task = task
                        }else{
                            Dprint("动画未结束")
                        }
                    }
                }
            }
        }
    }
    
}
