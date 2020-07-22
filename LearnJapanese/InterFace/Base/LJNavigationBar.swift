//
//  LJNavigationBar.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/22.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJNavigationBar: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("初始化失败")
    }
    
    /// 导航标题
    lazy var navTitleL:UILabel = {
        let nTitle = UILabel.init()
        nTitle.textAlignment = .center
        nTitle.font = UIFont.systemFont(ofSize: 15)
        nTitle.textColor = HEXCOLOR(h: 0x3b3b3b, alpha: 1)
        return nTitle
    }()
    
    /// 导航是否是透明色
    var isNavBarClear:Bool = false{
        didSet{
            if isNavBarClear == true{
                self.backgroundColor = .clear
                navTitleL.textColor = .white
                if rightBtn.title(for: .normal) != nil{
                    rightBtn.setTitleColor(.white, for: .normal)
                }
            }else{
                self.backgroundColor = .white
                navTitleL.textColor = .black
                if rightBtn.title(for: .normal) != nil{
                    rightBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1), for: .normal)
                }
            }
        }
    }
    
    //设置导航栏透明度
    var navbarAlpha:CGFloat = 0 {
        didSet{
            self.alpha = navbarAlpha
        }
    }
    
    // MARK: - PRIVAE
    lazy var backBtn:UIButton = {
        let bBtn = UIButton.init(type: .custom)
        return bBtn
    }()
    
    lazy var rightBtn:UIButton = {
        let rBtn = UIButton.init(type: .custom)
        return rBtn
    }()

}
