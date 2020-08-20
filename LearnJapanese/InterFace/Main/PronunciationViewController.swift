//
//  PronunciationViewController.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/8/19.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class PronunciationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    ///清音
    var surdArr: [PronunciationModel] = []
    ///浊音
    var dullArr: [PronunciationModel] = []
    ///拗音
    var yoonArr: [PronunciationModel] = []
    ///行列
    var columnLineArr1: [PronunciationModel] = []
    var columnLineArr2: [PronunciationModel] = []
    var columnLineArr3: [PronunciationModel] = []
    var currentIndex: Int = 0
    
    ///分页滚动视图
    var scrollBGV: UIScrollView = UIScrollView()
    ///分页控制器
    var pronunciationSegmentView: PronunciationSegmentView = PronunciationSegmentView()
    ///预览
    var pronunciationPreviewView: PronunciationPreviewView = PronunciationPreviewView()
    ///三张五十音图表
    lazy var colVArr: [UICollectionView] = {
        var colVArr: [UICollectionView] = []
        for i in 0 ..< 3{
            let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            flowLayout.estimatedItemSize = CGSize(width: WidthScale(60), height: WidthScale(40))
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = WidthScale(12)
            flowLayout.minimumLineSpacing = 0
            
            let colV: UICollectionView = UICollectionView(frame: CGRect(x: CGFloat(i) * SCREEN_WIDTH + WidthScale(10), y: NavPlusStatusH + WidthScale(isiPhoneX ? 45 : 15), width: SCREEN_WIDTH - WidthScale(20), height: SCREEN_HEIGHT - NavPlusStatusH - WidthScale(40)), collectionViewLayout: flowLayout)
            colV.delegate = self
            colV.dataSource = self
            colV.backgroundColor = .clear
            colV.tag = i + 1
            colV.register(PronunciationCollectionViewCell.self, forCellWithReuseIdentifier: "PronunciationCollectionViewCell")
            
            colVArr.append(colV)
        }
        return colVArr
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollBGV)
        scrollBGV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollBGV.delegate = self
        scrollBGV.bounces = false
        scrollBGV.isPagingEnabled = true
        scrollBGV.showsHorizontalScrollIndicator = false
        scrollBGV.showsVerticalScrollIndicator = false
        scrollBGV.contentInsetAdjustmentBehavior = .never
        scrollBGV.contentSize = CGSize(width: 3 * SCREEN_WIDTH, height: SCREEN_HEIGHT - NavPlusStatusH - WidthScale(40))
        
        for colV in colVArr {
            scrollBGV.addSubview(colV)
        }
        
        view.addSubview(pronunciationSegmentView)
        pronunciationSegmentView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(180), height: WidthScale(40)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(WidthScale(isiPhoneX ? 60 : 40))
        }
        pronunciationSegmentView.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.5).cgColor
        pronunciationSegmentView.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        pronunciationSegmentView.layer.shadowRadius = WidthScale(5)
        pronunciationSegmentView.layer.shadowOpacity = 1.0
        
        pronunciationSegmentView.selItemBlk = {[weak self] (btn) in
            if let weakSelf = self{
                if btn.tag != weakSelf.currentIndex{
                    weakSelf.currentIndex = btn.tag
                    weakSelf.scrollBGV.setContentOffset(CGPoint(x: CGFloat(weakSelf.currentIndex) * SCREEN_WIDTH, y: 0), animated: true)
                }
            }
        }
        getData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.x / SCREEN_WIDTH) != currentIndex{
            currentIndex = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
            let btn = UIButton()
            btn.tag = currentIndex
            pronunciationSegmentView.segmentItemAction(sender: btn)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return surdArr.count + 13
        case 2:
            return dullArr.count + 11
        case 3:
            return yoonArr.count + 15
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PronunciationCollectionViewCell", for: indexPath) as! PronunciationCollectionViewCell
        switch collectionView.tag {
        case 1:
            if indexPath.item == 0{
                let model = PronunciationModel()
                model.hiragana = "    "
                model.katakana = "  "
                model.isEmpty = true
                cell.model = model
            }else if indexPath.item <= 5{
                columnLineArr1[indexPath.item].katakana = ""
                cell.model = columnLineArr1[indexPath.item]
                cell.mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(14))
            }else if indexPath.item == 6{
                let model = PronunciationModel()
                model.hiragana = "    "
                model.katakana = "  "
                model.isEmpty = true
                cell.model = model
            }else if indexPath.item % 6 == 0{
                columnLineArr1[indexPath.item / 6 + 4].katakana = ""
                cell.model = columnLineArr1[indexPath.item / 6 + 4]
                cell.mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(14))
            }else if indexPath.item == surdArr.count + 12{
                cell.model = surdArr[surdArr.count - 1]
            }
            else{
                cell.model = surdArr[indexPath.item - indexPath.item / 6 - 6]
            }
            
        case 2:
            if indexPath.item == 0{
                let model = PronunciationModel()
                model.hiragana = "    "
                model.katakana = "  "
                model.isEmpty = true
                cell.model = model
            }else if indexPath.item <= 5{
                columnLineArr2[indexPath.item].katakana = ""
                cell.model = columnLineArr2[indexPath.item]
                cell.mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(14))
            }else if indexPath.item % 6 == 0{
                columnLineArr2[indexPath.item / 6 + 5].katakana = ""
                cell.model = columnLineArr2[indexPath.item / 6 + 5]
                cell.mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(14))
            }else{
                cell.model = dullArr[indexPath.item - indexPath.item / 6 - 6]
            }
        case 3:
            cell.mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(16))
            cell.subL.font = UIFont(name: FontYuanTiBold, size: WidthScale(12))
            if indexPath.item == 0{
                let model = PronunciationModel()
                model.hiragana = "         "
                model.katakana = "        "
                model.isEmpty = true
                cell.model = model
            }else if indexPath.item <= 3{
                columnLineArr3[indexPath.item].katakana = "   "
                cell.model = columnLineArr3[indexPath.item]
                cell.mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(18))
            }else if indexPath.item % 4 == 0{
                columnLineArr3[indexPath.item / 4 + 3].katakana = ""
                cell.model = columnLineArr3[indexPath.item / 4 + 3]
                cell.mainL.font = UIFont(name: FontYuanTiBold, size: WidthScale(18))
            }else{
                cell.model = yoonArr[indexPath.item - indexPath.item / 4 - 4]
            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PronunciationCollectionViewCell{
            if !cell.model.isEmpty{
                pronunciationPreviewView.model = cell.model
                pronunciationPreviewView.pop()
            }
        }
    }
    
    func getData(){
        surdArr = SQLManager.queryPronunciation(byCategory: 1) ?? []
        dullArr = SQLManager.queryPronunciation(byCategory: 2) ?? []
        yoonArr = SQLManager.queryPronunciation(byCategory: 3) ?? []
        yoonArr.append(PronunciationModel())
        columnLineArr1 = SQLManager.queryPronunciationColumn(byCategory: 1) ?? []
        columnLineArr2 = SQLManager.queryPronunciationColumn(byCategory: 2) ?? []
        columnLineArr3 = SQLManager.queryPronunciationColumn(byCategory: 3) ?? []
        let model = PronunciationModel()
        model.hiragana = "         "
        model.katakana = "        "
        columnLineArr3.append(model)
    }

}
