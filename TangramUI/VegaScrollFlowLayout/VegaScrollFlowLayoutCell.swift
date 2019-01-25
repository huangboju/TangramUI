//
//  VegaScrollFlowLayoutCell.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2019/1/25.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class VegaScrollFlowLayoutCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
