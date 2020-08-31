//
//  LJMainTableViewCell.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/5/21.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainTableViewCell: UITableViewCell {
    
    ///背景图片
    var bgImgV: UIImageView = UIImageView()
    ///遮罩
    var bgMaskV: UIView = UIView()
    ///标题
    var titleL: UILabel = UILabel()
    ///右侧图片
    var rightImgV: UIImageView = UIImageView()
    
    var contentV: UIView = UIView()
    
    ///高斯模糊
    var blurEffect = UIBlurEffect(style: .regular)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(){
        
        self.addPressAnimation()
        
        self.selectionStyle = .none
        self.addSubview(contentV)
        
        self.backgroundColor = .clear
        
        contentV.layer.cornerRadius = WidthScale(10)
        contentV.backgroundColor = .white
        contentV.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.4).cgColor
        contentV.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        contentV.layer.shadowRadius = WidthScale(5)
        contentV.layer.shadowOpacity = 1.0
        contentV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(120)))
        }
        
        self.addSubview(bgImgV)
        bgImgV.contentMode = .center
//        bgImgV.backgroundColor = .clear
        bgImgV.layer.cornerRadius = WidthScale(10)
        bgImgV.layer.masksToBounds = true
        bgImgV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(120)))
        }
        layoutIfNeeded()
        
        self.addSubview(titleL)
        titleL.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(20))
        titleL.textColor = HEXCOLOR(h: 0xA0522D, alpha: 1.0)
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(bgImgV).inset(WidthScale(20))
            make.top.equalTo(bgImgV).inset(WidthScale(40))
        }
        
        self.addSubview(rightImgV)
        rightImgV.contentMode = .scaleAspectFit
        rightImgV.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(WidthScale(40))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(88), height: WidthScale(84)))
        }
         
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
