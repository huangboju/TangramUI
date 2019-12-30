//
//  CardsCollectionViewLayoutVC.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2019/12/30.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class CardsCollectionViewLayoutVC: BaseController {
    
    var colors: [UIColor]  = [
      UIColor(r: 237, g: 37, b: 78),
      UIColor(r: 249, g: 220, b: 92),
      UIColor(r: 194, g: 234, b: 189),
      UIColor(r: 1, g: 25, b: 54),
      UIColor(r: 255, g: 184, b: 209)
    ]
    
    private lazy var collectionView: UICollectionView = {
        let excelLayout = CardsCollectionViewLayout()
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: excelLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        return collectionView
    }()
    
    override func initSubviews() {
        
        view.addSubview(collectionView)
    }
}

extension CardsCollectionViewLayoutVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.layer.cornerRadius = 7.0
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
}
