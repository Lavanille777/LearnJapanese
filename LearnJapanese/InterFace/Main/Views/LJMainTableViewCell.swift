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
        self.selectionStyle = .none
        self.addSubview(bgImgV)
        bgImgV.contentMode = .center
        bgImgV.image = UIImage.init(named: "cell_bg")
        bgImgV.layer.cornerRadius = WidthScale(10)
        bgImgV.layer.masksToBounds = true
        bgImgV.backgroundColor = .orange
        bgImgV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(120)))
        }
        
        bgImgV.addSubview(bgMaskV)
        bgMaskV.backgroundColor = HEXCOLOR(h: 0x000000, alpha: 0.2)
        bgMaskV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}
