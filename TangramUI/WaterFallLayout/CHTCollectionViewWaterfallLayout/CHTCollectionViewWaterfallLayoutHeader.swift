//
//  CHTCollectionViewWaterfallLayoutHeader.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2019/4/8.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

class CHTCollectionViewWaterfallLayoutHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: 0x7DD1F0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
