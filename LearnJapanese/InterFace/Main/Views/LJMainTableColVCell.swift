//
//  LJMainTableColVCell.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/20.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainTableColVCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LJMainCollectionViewCell", for: indexPath) as! LJMainCollectionViewCell
        
        return cell
    }
    
    lazy var tableColV: LJMainCollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = WidthScale(20)
        flowLayout.itemSize = CGSize(width: WidthScale(160), height: WidthScale(140))
        flowLayout.scrollDirection = .horizontal
        let tableColV: LJMainCollectionView = LJMainCollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
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

}
