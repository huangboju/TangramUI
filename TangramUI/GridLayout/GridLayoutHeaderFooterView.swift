//
//  HeaderFooterView.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/28.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class GridLayoutHeaderFooterView: UICollectionReusableView {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
