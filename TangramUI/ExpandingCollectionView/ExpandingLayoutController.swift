//
//  ExpandingLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/12/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ExpandingLayoutController: BaseController {
    
    let inspirations = Inspiration.allInspirations()

    private lazy var collectionView: UICollectionView = {
        
        let layout = ExpandingLayout()

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(InspirationCell.self, forCellWithReuseIdentifier: "InspirationCell")
        return collectionView
    }()

    override func initSubviews() {
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }

        view.addSubview(collectionView)
    }
}

extension ExpandingLayoutController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inspirations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InspirationCell", for: indexPath) as! InspirationCell
        cell.inspiration = inspirations[indexPath.item]
        return cell
    }
}

extension ExpandingLayoutController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = collectionView.collectionViewLayout as! ExpandingLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
}
