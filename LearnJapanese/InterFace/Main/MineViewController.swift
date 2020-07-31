//
//  MineViewController.swift
//  LearnJapanese
//  我的页面
//  Created by 唐星宇 on 2020/7/31.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class MineViewController: LJBaseViewController {
    ///圆角背景
    var roundCornerBgV: UIView = UIView()
    ///头像
    var avatarImgV: UIImageView = UIImageView()
    ///昵称
    var nickNameL: UILabel = UILabel()
    ///坚持天数
    var daysCountL: UILabel = UILabel()
    ///卡片
    var cardV: UIView = UIView()
    ///单词环形进度条
    var wordsProgressView: LJCycleProgressView = LJCycleProgressView.init(withWidth: WidthScale(10), radious: WidthScale(50), trackColor: HEXCOLOR(h: 0xe6e6e6, alpha: 1.0), progressStartColor: HEXCOLOR(h: 0x00BFFF, alpha: 0.2), progressEndColor: HEXCOLOR(h: 0x6495ED, alpha: 1.0))
    ///考试环形进度条
    var targetProgressView: LJCycleProgressView = LJCycleProgressView.init(withWidth: WidthScale(10), radious: WidthScale(50), trackColor: HEXCOLOR(h: 0xe6e6e6, alpha: 1.0), progressStartColor: HEXCOLOR(h: 0xfa8c16, alpha: 0.2), progressEndColor: HEXCOLOR(h: 0xfa8c16, alpha: 1.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = HEXCOLOR(h: 0xfbfafb, alpha: 1.0)
        
        view.addSubview(roundCornerBgV)
        roundCornerBgV.backgroundColor = HEXCOLOR(h: 0x7468be, alpha: 1.0)
        roundCornerBgV.layer.cornerRadius = WidthScale(40)
        roundCornerBgV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(-WidthScale(40))
            make.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(347))
        }
        
    }

}
