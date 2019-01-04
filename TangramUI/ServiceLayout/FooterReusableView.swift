//
//  FooterReusableView.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class FooterReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
