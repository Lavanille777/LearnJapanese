//
//  searchWordTbCell.swift
//  LearnJapanese
//  查单词列表单元
//  Created by 唐星宇 on 2020/7/23.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class SearchWordTbCell: UITableViewCell {
    ///日语
    var japaneseL: UILabel = UILabel()
    ///发音
    var pronunciationL: UILabel = UILabel()
    ///释义
    var chineseL: UILabel = UILabel()
    
    var model: wordModel = wordModel(){
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
        
        addSubview(japaneseL)
        japaneseL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        japaneseL.font = UIFont.boldSystemFont(ofSize: WidthScale(18))
        japaneseL.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(WidthScale(10))
            make.left.equalToSuperview().inset(WidthScale(20))
        }
        
        addSubview(pronunciationL)
        pronunciationL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        pronunciationL.font = UIFont.systemFont(ofSize: WidthScale(14))
        pronunciationL.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.bottom.equalToSuperview().inset(WidthScale(10))
        }
        
        addSubview(chineseL)
        chineseL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        chineseL.font = UIFont.systemFont(ofSize: WidthScale(14))
        chineseL.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(WidthScale(20))
            make.width.lessThanOrEqualTo(WidthScale(200))
            make.centerY.equalToSuperview()
        }
        
    }

}
