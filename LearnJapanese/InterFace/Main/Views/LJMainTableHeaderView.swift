//
//  LJMainTableHeaderView.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/5/21.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainTableHeaderView: UITableViewHeaderFooterView {
    
    ///大标题
    var title1L: UILabel = UILabel()
    ///小标题
    var title2L: UILabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("未实现初始化")
    }
    
    func setupUI(){
        self.backgroundColor = .clear
        
        self.addSubview(title1L)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "M月d日" // 自定义时间格式
        title1L.text = dateformatter.string(from: Date())
        title1L.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        title1L.font = UIFont.boldSystemFont(ofSize: WidthScale(26))
        title1L.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalToSuperview().inset(WidthScale(20))
        }
        
        self.addSubview(title2L)
        title2L.text = "千里の道も一歩から"
        title2L.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        title2L.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(14))
        title2L.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(20))
            make.top.equalTo(title1L.snp.bottom).offset(WidthScale(10))
        }
        
    }

}
