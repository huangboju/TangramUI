//
//  ServiceNormalCell.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ServiceNormalCell: UICollectionViewCell {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawBorder(borderWidth: 0.5, color: UIColor(r: 235, g: 235, b: 235))
        
        contentView.backgroundColor = UIColor.random
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
