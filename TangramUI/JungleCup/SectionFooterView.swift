//
//  SectionFooterView.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/26.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

final class JCSectionFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class JCSectionHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
