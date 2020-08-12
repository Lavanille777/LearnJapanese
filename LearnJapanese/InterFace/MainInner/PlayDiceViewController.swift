//
//  PlayDiceViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/31.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class PlayDiceViewController: LJMainAnimationViewController {
    
    var blueView: UIView = UIView()
    
    let diceView = UIView()
    
    var transform = CATransform3DIdentity
    var angle = CGPoint.init(x: 0, y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.targetTitleL.text = "玩骰子"
        
        addDice()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewTransform))
        diceView.addGestureRecognizer(panGesture)
    }
    
    @objc func viewTransform(sender: UIPanGestureRecognizer) {
        
        let point = sender.translation(in: diceView)
        let angleX = angle.x + (point.x/30)
        let angleY = angle.y - (point.y/30)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DRotate(transform, angleX, 0, 1, 0)
        transform = CATransform3DRotate(transform, angleY, 1, 0, 0)
        diceView.layer.sublayerTransform = transform
        
        if sender.state == .ended {
            angle.x = angleX
            angle.y = angleY
        }
    }
    
    func addDice() {
        
        let viewFrame = UIScreen.main.bounds
        
        var diceTransform = CATransform3DIdentity
        
        diceView.frame = CGRect(x: 0, y: viewFrame.maxY / 2 - 50, width: viewFrame.width, height: 100)
        
        //1
        let dice1 = UIImageView.init(image: UIImage(named: "dice1"))
        dice1.backgroundColor = .blue
        dice1.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice1.layer.transform = diceTransform
        
        //6
        let dice6 = UIImageView.init(image: UIImage(named: "dice6"))
        dice6.backgroundColor = .yellow
        dice6.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, -50)
        dice6.layer.transform = diceTransform
        
        //2
        let dice2 = UIImageView.init(image: UIImage(named: "dice2"))
        dice2.backgroundColor = .green
        dice2.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (CGFloat.pi / 2), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice2.layer.transform = diceTransform
        
        //5
        let dice5 = UIImageView.init(image: UIImage(named: "dice5"))
        dice5.backgroundColor = .cyan
        dice5.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (-CGFloat.pi / 2), 0, 1, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice5.layer.transform = diceTransform
        
        //3
        let dice3 = UIImageView.init(image: UIImage(named: "dice3"))
        dice3.backgroundColor = .darkGray
        dice3.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (-CGFloat.pi / 2), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice3.layer.transform = diceTransform
        
        //4
        let dice4 = UIImageView.init(image: UIImage(named: "dice4"))
        dice4.backgroundColor = .gray
        dice4.frame = CGRect(x: viewFrame.maxX / 2 - 50, y: 0, width: 100, height: 100)
        diceTransform = CATransform3DRotate(CATransform3DIdentity, (CGFloat.pi / 2), 1, 0, 0)
        diceTransform = CATransform3DTranslate(diceTransform, 0, 0, 50)
        dice4.layer.transform = diceTransform
        
        diceView.addSubview(dice1)
        diceView.addSubview(dice2)
        diceView.addSubview(dice3)
        diceView.addSubview(dice4)
        diceView.addSubview(dice5)
        diceView.addSubview(dice6)
        
        view.addSubview(diceView)
    }
    
    

}
