//
//  GridLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/28.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

private let reuseIdentifier = "Cell"
private let headerFooterIdentifier = "headerFooter"

class GridLayoutController: BaseController {
    
    let layout = GridLayout()
    
    private lazy var collectionView: UICollectionView = {

        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.numberOfItemsPerLine = 3
        layout.headerReferenceLength = 20
        layout.footerReferenceLength = 20

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(GridLayoutHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerFooterIdentifier)
        collectionView.register(GridLayoutHeaderFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: headerFooterIdentifier)
        return collectionView
    }()

    override func initSubviews() {
        view.addSubview(collectionView)
    }
}

extension GridLayoutController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        if indexPath.section % 2 == 1 {
            cell.contentView.backgroundColor = .blue
        } else {
            cell.contentView.backgroundColor = .red
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerFooterIdentifier, for: indexPath) as! GridLayoutHeaderFooterView
        
        view.textLabel.text = kind

        return view
    }
}

extension GridLayoutController: UICollectionViewDelegate {}

extension GridLayoutController: GridLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = CGFloat((section + 1) * 10)
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, interitemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat((section + 1) * 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, lineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat((section + 1) * 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceLengthForHeaderInSection section: Int) -> CGFloat {
        return CGFloat((section + 1) * 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceLengthForFooterInSection section: Int) -> CGFloat {
        return CGFloat((section + 1) * 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, numberItemsPerLineForSectionAt section: Int) -> Int {
        return self.layout.numberOfItemsPerLine + (section * 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, aspectRatioForItemsInSectionAt section: Int) -> CGFloat {
        return CGFloat(1 + section)
    }
}
