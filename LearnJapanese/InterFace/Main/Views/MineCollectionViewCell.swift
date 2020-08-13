//
//  MineCollectionViewCell.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class MineCollectionViewCell: UICollectionViewCell {
    ///背景
    var bgView: UIView = UIView()
    ///图标
    var imgV: UIImageView = UIImageView()
    ///标题
    var titleL: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    func setupUI(){
        self.addSubview(bgView)
        bgView.addOncePressAnimation()
        bgView.layer.cornerRadius = WidthScale(10)
        bgView.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.8).cgColor
        bgView.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        bgView.layer.shadowRadius = WidthScale(5)
        bgView.layer.shadowOpacity = 1.0
        bgView.backgroundColor = HEXCOLOR(h: 0x000000, alpha: 0.5)
        bgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        bgView.addSubview(imgV)
        imgV.layer.cornerRadius = WidthScale(10)
        imgV.layer.masksToBounds = true
        imgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(titleL)
        titleL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        titleL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(14))
        titleL.textAlignment = .center
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(WidthScale(10))
            make.left.right.equalToSuperview()
        }
    }
}
