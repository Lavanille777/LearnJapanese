//
//  PronunciationCollectionViewCell.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/19.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class PronunciationCollectionViewCell: UICollectionViewCell {
    
    ///平假名
    var mainL: UILabel = UILabel()
    ///片假名
    var subL: UILabel = UILabel()
    
    var model: PronunciationModel = PronunciationModel(){
        didSet{
            mainL.text = model.hiragana
            subL.text = model.katakana
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    func setupUI() {
        addSubview(mainL)
        mainL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(20))
        mainL.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(WidthScale(5))
        }
        
        addSubview(subL)
        subL.textColor = HEXCOLOR(h: 0x949494, alpha: 1.0)
        subL.font = UIFont(name: FontYuanTiBold, size: WidthScale(14))
        subL.snp.makeConstraints { (make) in
            make.bottom.equalTo(mainL)
            make.left.equalTo(mainL.snp.right).offset(WidthScale(5))
            make.right.equalToSuperview().inset(WidthScale(5))
        }
    }
}
