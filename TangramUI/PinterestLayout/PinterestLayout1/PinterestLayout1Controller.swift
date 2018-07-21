//
//  PinterestLayout1Controller.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/3.
//  Copyright © 2018 黄伯驹. All rights reserved.
// 

class PinterestLayout1Controller: BaseController {
    let layout = PinterestLayout1()
    
    var photos = Photo.gifLink
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PinterestLayout1Cell.self, forCellWithReuseIdentifier: "AnnotatedPhotoCell")
        return collectionView
    }()
    
    override func initSubviews() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        
        view.addSubview(collectionView)
    }
}

extension PinterestLayout1Controller: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
        if let annotateCell = cell as? PinterestLayout1Cell {
            annotateCell.url = photos[indexPath.item]
        }
        return cell
    }
}


//MARK: - PINTEREST LAYOUT DELEGATE
extension PinterestLayout1Controller: PinterestLayoutDelegate1 {
    
    // 1. Returns the photo height
    func collectionView(collectionView: UICollectionView,
                        heightForImageAt indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(200) + 30)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAt indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return 20
    }
    
}
