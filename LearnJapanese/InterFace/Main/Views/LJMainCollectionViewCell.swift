//
//  LJMainCollectiionViewCell.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var bgView: UIView = UIView()
    
    var bgImgV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI(){
        self.backgroundColor = .clear
        self.addPressAnimation()
        addSubview(bgView)
        bgView.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 1).cgColor
        bgView.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        bgView.layer.shadowRadius = WidthScale(5)
        bgView.layer.shadowOpacity = 1.0
        bgView.layer.cornerRadius = WidthScale(10)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(bgImgV)
        bgImgV.image = UIImage(named: "colCell")
        bgImgV.layer.cornerRadius = WidthScale(10)
        bgImgV.layer.masksToBounds = true
        bgImgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("LJMainCollectionViewCell===初始化失败")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}
