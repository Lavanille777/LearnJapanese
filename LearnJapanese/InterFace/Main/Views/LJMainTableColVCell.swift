//
//  LJMainTableColVCell.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/20.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainTableColVCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var popAnimation: LJPopTransitionAnimator?
    
    var replaceInteractivePopTransition: LJPopInteractiveTransitioning?
    
    lazy var tableColV: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = WidthScale(20)
        flowLayout.itemSize = CGSize(width: WidthScale(176), height: WidthScale(154))
        flowLayout.scrollDirection = .horizontal
        let tableColV: UICollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        tableColV.register(LJMainCollectionViewCell.self, forCellWithReuseIdentifier: "LJMainCollectionViewCell")
        tableColV.dataSource = self
        tableColV.delegate = self
        tableColV.contentInset = UIEdgeInsets(top: 0, left: WidthScale(20), bottom: 0, right: WidthScale(20))
        tableColV.showsHorizontalScrollIndicator = false
        tableColV.backgroundColor = .clear
        return tableColV
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.backgroundColor = .clear
        addSubview(tableColV)
        tableColV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LJMainCollectionViewCell", for: indexPath) as! LJMainCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LJMainCollectionViewCell else {
            return
        }
        let rect = cell.convert(cell.bgImgV.frame, to: nil)
        NotificationCenter.default.post(name: NSNotification.Name(MAINVIEWPUSHTOUCH), object: nil, userInfo: ["view": cell, "rect": rect])
        
        let vc = LJImageTextViewController()
        vc.popAnimation = popAnimation
        vc.replaceInteractivePopTransition = replaceInteractivePopTransition!
        self.currentNavViewController()?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Dprint(scrollView.contentOffset)
        if let colV = scrollView as? UICollectionView{
//            for cell in colV.visibleCells as! [LJMainCollectionViewCell]{
//                if let indexPath = colV.indexPath(for: cell), let layoutAttri = colV.layoutAttributesForItem(at: indexPath){
//                    let cellFrame = colV.convert(layoutAttri.frame, to: nil)
//
//                    let angle = angleToRadian(Double(-cellFrame.origin.x) / 8)
//                    var transform = CATransform3DIdentity
//                    transform.m34 = -1.0 / 800
//                    let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
//                    cell.layer.transform = rotation
//                }
//            }
        }
        
        
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
