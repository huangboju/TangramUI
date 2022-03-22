//
//  VegaScrollFlowLayoutVC.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2019/1/25.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

// MARK: - Configurable constants
private let itemHeight: CGFloat = 84
private let lineSpacing: CGFloat = 20
private let xInset: CGFloat = 20
private let topInset: CGFloat = 10

class VegaScrollFlowLayoutVC: BaseController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = VegaScrollFlowLayout()
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.contentInset.bottom = itemHeight
        collectionView.register(VegaScrollFlowLayoutCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func initSubviews() {
        view.addSubview(collectionView)
    }
    
    override var githubUrl: String {
        "https://github.com/ApplikeySolutions/VegaScroll"
    }
}

extension VegaScrollFlowLayoutVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}
