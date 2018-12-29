//
//  SCCornerViewController.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2018/12/29.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

class SCCornerCollectionViewCell: UICollectionViewCell {
    
    private lazy var bgColorView: UIView = {
        let bgColorView = UIView()
        bgColorView.layer.cornerRadius = 12
        return bgColorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bgColorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgColorView.frame = bounds
    }
    
    var colorValue: Int = 0xEE5464 {
        didSet {
            bgColorView.layer.backgroundColor = UIColor(hex: colorValue).cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SCCornerViewController: BaseController {
    
    let colorsArray = [
        0xEE5464,
        0xDC4352,
        0xFD6D50,
        0xEA583F,
        0xF6BC43,
        0x8DC253,
        0x4FC2E9,
        0x3CAFDB,
        0x5D9CEE,
        0x4B89DD,
        0xAD93EE,
        0x977BDD,
        0xEE87C0,
        0xD971AE,
        0x903FB1,
        0x9D56B9,
        0x227FBD,
        0x2E97DE
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = StickCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = -20
        var rect = self.view.frame
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.register(SCCornerCollectionViewCell.self, forCellWithReuseIdentifier: "SCCornerCollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func initSubviews() {
        view.addSubview(collectionView)
    }
}

extension SCCornerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCCornerCollectionViewCell", for: indexPath)
        (cell as? SCCornerCollectionViewCell)?.colorValue = colorsArray[indexPath.item]
        return cell
    }
}

