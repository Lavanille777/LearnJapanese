//
//  LJImageTextViewController.swift
//  LearnJapanese
//  图文页
//  Created by 唐星宇 on 2020/7/28.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJImageTextViewController: LJMainAnimationViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var scrollV: UIScrollView = UIScrollView()
    ///顶部图片
    var imageV: UIImageView = UIImageView()
    ///文字介绍
    var textBGV: UIView = UIView()
    
    var titleL: UILabel = UILabel()
    
    var titleBGV: UIView = UIView()
    
    var titleBGVGradientLayer: CAGradientLayer = CAGradientLayer()
    
    var text1L: UILabel = UILabel()
    
    ///中部图片
    var imageInnerV: UIImageView = UIImageView()
    
    var text2L: UILabel = UILabel()
    
    var model: ArticleModel = ArticleModel(){
        didSet{
            imageV.image = UIImage(named: model.img1)
            imageInnerV.image = UIImage(named: model.img2)
            titleL.text = model.title
            
            var mutableAttrStr = NSMutableAttributedString(string: model.text1)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = WidthScale(10)
            mutableAttrStr.addAttributes([.paragraphStyle:style, .font: UIFont(name: FontHanziPenW5, size: WidthScale(16)) ?? UIFont.systemFont(ofSize: WidthScale(16)), .foregroundColor: HEXCOLOR(h: 0x101010, alpha: 1.0)], range: NSMakeRange(0, mutableAttrStr.length))
            text1L.attributedText = mutableAttrStr
            
            mutableAttrStr = NSMutableAttributedString(string: model.text2)
            mutableAttrStr.addAttributes([.paragraphStyle:style, .font: UIFont(name: FontHanziPenW5, size: WidthScale(16)) ?? UIFont.systemFont(ofSize: WidthScale(16)), .foregroundColor: HEXCOLOR(h: 0x101010, alpha: 1.0)], range: NSMakeRange(0, mutableAttrStr.length))
            text2L.attributedText = mutableAttrStr
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navgationBarV.backBtn.setTitleColor(.white, for: .normal)
        view.addSubview(scrollV)
        scrollV.backgroundColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        scrollV.delegate = self
        scrollV.showsVerticalScrollIndicator = false
        scrollV.contentInsetAdjustmentBehavior = .never
        scrollV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollV.addSubview(imageV)
//        imageV.image = UIImage(named: "colCell1_1")
        imageV.contentMode = .scaleAspectFill
        imageV.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(view)
            make.height.equalTo(self.view.frame.width * 140/160)
        }
        
        imageV.addSubview(titleBGV)
        titleBGV.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(imageV)
            make.height.equalTo(WidthScale(50))
        }
        view.layoutIfNeeded()
        titleBGVGradientLayer = titleBGV.addGradientLayer(colors: [HEXCOLOR(h: 0x101010, alpha: 0.0).cgColor, HEXCOLOR(h: 0x101010, alpha: 1.0).cgColor], locations: [0, 1], isHor: false)
        
        titleBGV.addSubview(titleL)
        titleL.textColor = .white
        titleL.font = UIFont.init(name: FontHanziPenW5, size: WidthScale(18))
        titleL.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview().inset(WidthScale(10))
        }
        
        scrollV.addSubview(textBGV)
        scrollV.addSubview(text1L)
        textBGV.backgroundColor = HEXCOLOR(h: 0xFFFAF0, alpha: 1.0)
        textBGV.layer.cornerRadius = WidthScale(20)
        textBGV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(self.view.frame.width * 140/160)
            make.left.right.equalTo(view)
            make.bottom.equalTo(scrollV).offset(WidthScale(1000))
        }
        
        text1L.numberOfLines = 0

        text1L.snp.makeConstraints { (make) in
            make.top.equalTo(textBGV).inset(WidthScale(20))
            make.left.equalTo(view).inset(WidthScale(20))
            make.width.equalTo(SCREEN_WIDTH - WidthScale(30))
        }
        
        scrollV.addSubview(imageInnerV)
        imageInnerV.layer.cornerRadius = WidthScale(20)
        imageInnerV.layer.masksToBounds = true
        imageInnerV.snp.makeConstraints { (make) in
            make.top.equalTo(text1L.snp.bottom).offset(WidthScale(20))
            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(210)))
            make.centerX.equalTo(view)
        }
        
        scrollV.addSubview(text2L)
        text2L.numberOfLines = 0
        text2L.snp.makeConstraints { (make) in
            make.top.equalTo(imageInnerV.snp.bottom).offset(WidthScale(20))
            make.left.equalTo(view).inset(WidthScale(20))
            make.width.equalTo(SCREEN_WIDTH - WidthScale(30))
            make.bottom.equalToSuperview().inset(IPHONEX_BH + WidthScale(20))
        }
        
        self.view.bringSubviewToFront(navgationBarV)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navgationBarV.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navgationBarV.addGradientLayer(colors: [HEXCOLOR(h: 0x000000, alpha: 1).cgColor, HEXCOLOR(h: 0x000000, alpha: 0).cgColor], locations: [0, 1], isHor: false)
        self.navgationBarV.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.navgationBarV.alpha = 1
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0{
            imageV.contentMode = .scaleAspectFill
            imageV.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().inset(scrollView.contentOffset.y)
                make.left.right.equalTo(view).inset(scrollView.contentOffset.y / 2)
                make.height.equalTo((SCREEN_WIDTH - scrollView.contentOffset.y) * 140 / 160)
            }
            scrollView.layoutIfNeeded()
        }else{
            imageV.contentMode = .scaleAspectFill
            imageV.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.right.equalTo(view)
                make.height.equalTo(self.view.frame.width * 140 / 160)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
