//
//  WaterfallLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/2.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class WaterfallLayoutController: BaseController {
    
    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for _ in 0...100 {
            let random = Int(arc4random_uniform((UInt32(100))))
            _cellSizes.append(CGSize(width: 140, height: 50 + random))
        }
        
        return _cellSizes
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerInset = UIEdgeInsetsMake(20, 0, 0, 0)
        layout.headerHeight = 50
        layout.footerHeight = 20
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader,
                                withReuseIdentifier: "Header")

        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter,
                                withReuseIdentifier: "Footer")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func initSubviews() {
        view.addSubview(collectionView)
    }
}

extension WaterfallLayoutController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        cell.layer.cornerRadius = 8
        cell.layer.backgroundColor = UIColor.random.cgColor

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)

            headerView.backgroundColor = UIColor.red
            return headerView
        } else if kind == CollectionViewWaterfallElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footerView.backgroundColor = UIColor.blue
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension WaterfallLayoutController: CollectionViewWaterfallLayoutDelegate {
    // MARK: WaterfallLayoutDelegate
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}
