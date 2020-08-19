//
//  searchWordTbCell.swift
//  LearnJapanese
//  查单词列表单元
//  Created by 唐星宇 on 2020/7/23.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class SearchWordTbCell: UITableViewCell {
    ///内容视图
    var contentBGV: UIView = UIView()
    var contentV: UIView = UIView()
    ///日语
    var japaneseL: UILabel = UILabel()
    ///发音
    var pronunciationL: UILabel = UILabel()
    ///释义
    var chineseL: UILabel = UILabel()
    
    var model: WordModel = WordModel(){
        didSet{
            japaneseL.text = model.japanese
            pronunciationL.text = model.pronunciation
            chineseL.text = model.chinese
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.addSubview(contentBGV)
        contentBGV.layer.cornerRadius = WidthScale(10)
        contentBGV.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.5).cgColor
        contentBGV.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        contentBGV.layer.shadowRadius = WidthScale(5)
        contentBGV.layer.shadowOpacity = 1.0
        contentBGV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH - WidthScale(40))
            make.height.equalTo(WidthScale(80))
        }
        
        contentBGV.addSubview(contentV)
        contentV.layer.cornerRadius = WidthScale(10)
        contentV.layer.masksToBounds = true
        contentV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        layoutIfNeeded()
        contentV.addGradientLayer(colors: [HEXCOLOR(h: 0x87CEFA, alpha: 1).cgColor, HEXCOLOR(h: 0x00BFFF, alpha: 1).cgColor], locations: [0,1], isHor: true)
        
        contentV.addSubview(japaneseL)
        japaneseL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        japaneseL.font = UIFont(name: FontYuanTiBold, size: WidthScale(18))
        japaneseL.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(10))
            make.left.equalToSuperview().inset(WidthScale(20))
        }
        
        contentV.addSubview(pronunciationL)
        pronunciationL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        pronunciationL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(14))
        pronunciationL.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.bottom.equalToSuperview().inset(WidthScale(10))
        }
        
        contentV.addSubview(chineseL)
        chineseL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        chineseL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(14))
        chineseL.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(WidthScale(20))
            make.width.lessThanOrEqualTo(WidthScale(200))
            make.centerY.equalToSuperview()
        }
        
    }

}
