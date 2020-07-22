//
//  LJMainCollectionView.swift
//  LearnJapanese
//
//  Created by 唐星宇 on 2020/7/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(LJMainCollectionViewCell.self, forCellWithReuseIdentifier: "LJMainCollectionViewCell")
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "LJMainCollectionViewCell", for: indexPath)
        return cell
    }
    
    
}
