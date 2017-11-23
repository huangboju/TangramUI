//
//  ServiceLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ServiceLayoutController: BaseController {
    
    private let cells: [(UICollectionViewCell.Type, String)] = [
        (ServiceNormalCell.self, "ServiceNormalCell"),
        (ServiceOnePicCell.self, "ServiceOnePicCell"),
        (ServicePicTwoTitleCell.self, "ServicePicTwoTitleCell"),
        (ServiceLeftPicCell.self, "ServiceLeftPicCell")
    ]
    
    private lazy var collectionView: UICollectionView = {

        let layout = ServiceLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self

        cells.forEach { collectionView.register($0.0, forCellWithReuseIdentifier: $0.1) }
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.classForCoder())")
        collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "\(FooterReusableView.classForCoder())")
        
        return collectionView
    }()

    override func initSubviews() {
        view.addSubview(collectionView)
    }
}

extension ServiceLayoutController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.item == 0 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceOnePicCell", for: indexPath)
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceNormalCell", for: indexPath)
            }
        case 1:
            if indexPath.item == 0 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ServicePicTwoTitleCell", for: indexPath)
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceLeftPicCell", for: indexPath)
            }
        case 2:
            if indexPath.item == 0 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceOnePicCell", for: indexPath)
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceLeftPicCell", for: indexPath)
            }
        case 3:
            if indexPath.item == 2 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ServicePicTwoTitleCell", for: indexPath)
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceLeftPicCell", for: indexPath)
            }
        default:
            fatalError("检查section")
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.classForCoder())", for: indexPath)
            return headerView
        } else {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(FooterReusableView.classForCoder())", for: indexPath)
            return footerView
        }
    }
}

extension ServiceLayoutController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension ServiceLayoutController: ServiceLayoutDelegate {
    func heightOfSectionFooter(for indexPath: IndexPath) -> CGFloat {
        return 15
    }

    func heightOfSectionHeader(for indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
