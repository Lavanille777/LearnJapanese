//
//  WordsTableViewCell.swift
//  LearnJapanese
//  收藏夹单词单元
//  Created by 唐星宇 on 2020/8/18.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class WordsTableViewCell: UITableViewCell {
    
    var contentV: UIView = UIView()
    
    var japaneseL: UILabel = UILabel()
    
    var hiraganaL: UILabel = UILabel()
    
    var chineseL: UILabel = UILabel()
    
//    var
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.selectionStyle = .none
    }

}
