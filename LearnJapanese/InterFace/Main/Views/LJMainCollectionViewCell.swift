//
//  LJMainCollectiionViewCell.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainCollectionViewCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    ///高斯模糊
    var blurEffect = UIBlurEffect(style: .dark)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI(){
        self.backgroundColor = .clear
        addSubview(bgView)
        bgView.backgroundColor = .darkGray
        bgView.alpha = 0.5
        bgView.layer.shadowColor = HEXCOLOR(h: 0x303030, alpha: 1).cgColor
        bgView.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        bgView.layer.shadowRadius = WidthScale(5)
        bgView.layer.shadowOpacity = 1.0
        bgView.layer.cornerRadius = WidthScale(10)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("LJMainCollectionViewCell===初始化失败")
    }
}
