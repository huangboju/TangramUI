//
//  CHTCollectionViewWaterfallLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/2.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class CHTCollectionViewWaterfallLayoutController: BaseController {
    
    private lazy var stickyView: UIView = {
        let stickyView = UIView(frame: CGRect(x: 10, y: 0, width: self.view.frame.width - 20, height: 50))
        stickyView.backgroundColor = .red
        return stickyView
    }()
    
    lazy var cellSizes: [CGSize] = {
        var _cellSizes = [CGSize]()
        
        for _ in 0...20 {
            let random = Int(arc4random_uniform((UInt32(100))))
            _cellSizes.append(CGSize(width: 140, height: 50 + random))
        }
        
        return _cellSizes
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerHeight = 50
//        layout.footerHeight = 20
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CHTCollectionViewWaterfallLayoutHeader.self, forSupplementaryViewOfKind: CHTCollectionViewWaterfallLayout.sectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func initSubviews() {
        view.addSubview(collectionView)
        view.addSubview(stickyView)
    }
}

extension CHTCollectionViewWaterfallLayoutController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 2 : cellSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.layer.cornerRadius = 8
        cell.layer.backgroundColor = UIColor.random.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: CHTCollectionViewWaterfallLayout.sectionHeader, withReuseIdentifier: "header", for: indexPath)
    }
}

extension CHTCollectionViewWaterfallLayoutController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 50)
        }
        return cellSizes[indexPath.row]
    }
    
    func collectionView (_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         columnCountForSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let attr = collectionView.layoutAttributesForItem(at: IndexPath(item: 1, section: 0)) else {
            return
        }
        
        stickyView.frame.origin.y = max(attr.frame.minY - collectionView.contentOffset.y, collectionView.realContentInset.top)
    }
}
