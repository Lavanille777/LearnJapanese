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
    
    var textL: UILabel = UILabel()
    
    var titleL: UILabel = UILabel()
    
    var titleBGV: UIView = UIView()
    
    var titleBGVGradientLayer: CAGradientLayer = CAGradientLayer()

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
        imageV.image = UIImage(named: "colCell")
        imageV.contentMode = .scaleAspectFit
        imageV.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(view)
            make.height.equalTo(self.view.frame.width * WidthScale(140/160))
        }
        
        view.addSubview(titleBGV)
        titleBGV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(imageV)
            make.height.equalTo(WidthScale(50))
        }
        view.layoutIfNeeded()
        titleBGVGradientLayer = titleBGV.addGradientLayer(colors: [HEXCOLOR(h: 0x101010, alpha: 0.0).cgColor, HEXCOLOR(h: 0x101010, alpha: 1.0).cgColor], locations: [0, 1], isHor: false)
        
        titleBGV.addSubview(titleL)
        titleL.text = "上野公园"
        titleL.textColor = .white
        titleL.font = UIFont.init(name: FontHanziPenW3, size: WidthScale(18))
        titleL.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview().inset(WidthScale(10))
        }
        
        scrollV.addSubview(textBGV)
        scrollV.addSubview(textL)
        textBGV.backgroundColor = HEXCOLOR(h: 0xFAFAF8, alpha: 1.0)
        textBGV.layer.cornerRadius = WidthScale(20)
        textBGV.snp.makeConstraints { (make) in
            make.top.equalTo(imageV.snp.bottom)
            make.left.right.equalTo(view)
//            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(scrollV).offset(WidthScale(1000))
        }
        let str = "上野公园是日本最大的公园，也是东京的文化中心。它位于JR上野车站旁边，从银座乘地铁可以直达。园内有东京文化会馆、国立西洋美术馆，东京国立博物馆、东京都美术馆、上野动物园等等。上野公园是有雕刻家高村光云所作的西乡隆盛铜像，以及野口英世的铜像。除了许多文化设施外，也是春天赏樱的热门地点。\n\n有“史迹和文化财物的宝库”之称的上野公园里，有宽永寺、德川家灵庙、东昭宫、清水堂、西乡隆盛铜像等古迹，这些江户和明治时代的建筑散落在苍松翠柏之中，与湖光山色十分相宜。园内还有很多博物馆，有东京国立博物馆、国立科学博物馆、国立西洋美术馆、都立美术馆等等。园西北有上野动物园，饲养着九百多种珍禽异兽，在园内的不忍池内，终年栖息着大量野生的黑天鹅、大雁、鸳鸯、鸬鹚和野鸭。池畔还有一个水族馆，里面有五百多种水生动物。动物园边上建有牡丹园，种植了70多个品种3000多株牡丹。"
        textL.numberOfLines = 0
        let mutableAttrStr = NSMutableAttributedString(string: str)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = WidthScale(10)
        mutableAttrStr.addAttributes([.paragraphStyle:style, .font: UIFont(name: FontHanziPenW5, size: WidthScale(18)) ?? UIFont.systemFont(ofSize: WidthScale(18)), .foregroundColor: HEXCOLOR(h: 0x101010, alpha: 1.0)], range: NSMakeRange(0, mutableAttrStr.length))
        textL.attributedText = mutableAttrStr
        textL.snp.makeConstraints { (make) in
            make.top.equalTo(imageV.snp.bottom).offset(WidthScale(20))
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
                make.height.equalTo(WidthScale(328 + abs(scrollView.contentOffset.y) ))
            }
            scrollView.layoutIfNeeded()
        }else{
            imageV.contentMode = .scaleAspectFit
            imageV.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.right.equalTo(view)
                make.height.equalTo(self.view.frame.width * WidthScale(140/160))
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
