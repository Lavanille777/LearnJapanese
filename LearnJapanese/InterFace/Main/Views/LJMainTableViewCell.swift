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
    
    var contentV: UIView = UIView()
    
    var timer: Timer?
    
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
        self.selectionStyle = .none
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(pressAction))
        longPress.minimumPressDuration = 0
        longPress.cancelsTouchesInView = false
        longPress.delegate = self
        self.addGestureRecognizer(longPress)
        self.addSubview(contentV)
        
        self.backgroundColor = .clear
        
        contentV.layer.cornerRadius = WidthScale(10)
        
        contentV.backgroundColor = .white
        contentV.layer.shadowColor = HEXCOLOR(h: 0x303030, alpha: 0.3).cgColor
        contentV.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        contentV.layer.shadowRadius = WidthScale(5)
        contentV.layer.shadowOpacity = 1.0
        contentV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(120)))
        }
        
        self.addSubview(bgImgV)
        bgImgV.contentMode = .center
        bgImgV.backgroundColor = .clear
        bgImgV.layer.cornerRadius = WidthScale(10)
        bgImgV.layer.masksToBounds = true
        bgImgV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(120)))
        }
        
        self.addSubview(titleL)
        titleL.font = UIFont.systemFont(ofSize: WidthScale(20))
        titleL.textColor = HEXCOLOR(h: 0x101010, alpha: 1.0)
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(bgImgV).inset(WidthScale(20))
            make.top.equalTo(bgImgV).inset(WidthScale(40))
        }
         
    }
    
    @objc func pressAction(_ sender: UILongPressGestureRecognizer){
         var scale: CGFloat = 1
         if sender.state == .began {
            timer = Timer.scheduledTimer(withTimeInterval: 0.017, repeats: true, block: { (timer) in
                scale -= 0.003
                if scale > 0.95{
                    self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
                }
            })
            timer?.fire()
         }
         if sender.state == .ended || sender.state == .cancelled{
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }
             if let timer = timer{
                 timer.invalidate()
             }
             timer = nil
         }
     }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
