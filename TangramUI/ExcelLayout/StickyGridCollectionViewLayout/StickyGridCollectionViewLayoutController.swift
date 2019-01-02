//
//  StickyGridCollectionViewLayoutController.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2019/1/2.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class StickyGridCollectionViewLayoutController: BaseController {

    let layout = StickyGridCollectionViewLayout()
    
    
    private lazy var collectionView: UICollectionView = {
        layout.stickyRowsCount = 1
        layout.stickyColumnsCount = 1
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        var rect = self.view.frame
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.register(ExcelLayoutCell.self, forCellWithReuseIdentifier: "ExcelLayoutCell")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func initSubviews() {
        view.addSubview(collectionView)
    }
}

extension StickyGridCollectionViewLayoutController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExcelLayoutCell", for: indexPath)
        (cell as? ExcelLayoutCell)?.updateView(with: indexPath.description)
        cell.backgroundColor = layout.isItemSticky(at: indexPath) ? .groupTableViewBackground : .white
        return cell
    }
}
