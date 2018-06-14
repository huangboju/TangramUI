//
//  AKPFlowLayoutController.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2018/6/14.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class AKPFlowLayoutController: BaseController {
    var layoutOptions: AKPLayoutConfigOptions = [
        .firstSectionIsGlobalHeader,
        .firstSectionStretchable,
        .sectionsPinToGlobalHeaderOrVisibleBounds
    ]

    private lazy var collectionView: UICollectionView = {
        let layout = AKPFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        layout.layoutOptions = layoutOptions
        layout.firsSectionMaximumStretchHeight = self.view.bounds.width

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "AnnotatedPhotoCell")
        collectionView.register(ImageCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(ImageCollectionViewGlobalHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "globalHeader")
        return collectionView
    }()
    
    override func initSubviews() {
        view.addSubview(collectionView)
    }
    
    @objc
    func showLayoutConfigOptions(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "First Section Is Global Header", style: .default) { action in
            
        }
        alert.addAction(action1)

        let action2 = UIAlertAction(title: "First Section Stretchable", style: .default) { action in
            
        }
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: "cancel", style: .cancel) { action in }
        alert.addAction(action3)
    
        present(alert, animated: true, completion: nil)
    }
}

extension AKPFlowLayoutController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
        cell.backgroundColor = UIColor.random
//        (cell as? ImageCollectionViewCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "globalHeader", for: indexPath)
            return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            (header as? ImageCollectionViewHeader)?.sectionHeaderText = "今天天气很好"
            return header
        }
    }
}

extension AKPFlowLayoutController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSize.zero }
        let sectionInsetWidth = self.collectionView(collectionView, layout: layout,
                                                    insetForSectionAt: indexPath.section).left
        let width = collectionView.bounds.width / 2 - layout.minimumInteritemSpacing / 2 - sectionInsetWidth
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        if section == 0 {
            return CGSize(width: width, height: 80)
        } else {
            return CGSize(width: width, height: 35)
        }
    }
}
