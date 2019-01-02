//
//  CHTCollectionViewWaterfallLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/2.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class CHTCollectionViewWaterfallLayoutController: BaseController {
    
    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for _ in 0...100 {
            let random = Int(arc4random_uniform((UInt32(100))))
            _cellSizes.append(CGSize(width: 140, height: 50 + random))
        }
        
        return _cellSizes
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerHeight = 50
        layout.footerHeight = 20
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
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

extension CHTCollectionViewWaterfallLayoutController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.layer.cornerRadius = 8
        cell.layer.backgroundColor = UIColor.random.cgColor
        
        return cell
    }
}

extension CHTCollectionViewWaterfallLayoutController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.row]
    }
}
