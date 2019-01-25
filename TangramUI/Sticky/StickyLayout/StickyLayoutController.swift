//
//  StickyLayoutController.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2019/1/3.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class StickyLayoutController: BaseController {

    private lazy var collectionView: UICollectionView = {
        let layout = StickyLayout()
        let width = self.view.frame.width
        layout.itemSize = CGSize(width: width, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: width, height: 40)
        layout.footerReferenceSize = CGSize(width: width, height: 40)
        var rect = self.view.frame
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ExcelLayoutCell")
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footer")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func initSubviews() {
        view.addSubview(collectionView)
    }
}

extension StickyLayoutController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExcelLayoutCell", for: indexPath)
        cell.backgroundColor = indexPath.row & 1 == 0 ? .white : .groupTableViewBackground
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            footer.backgroundColor = .green
            return footer
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        header.backgroundColor = .red
        return header
    }
}
