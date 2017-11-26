//
//  MenuView.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/26.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

protocol MenuViewDelegate {
    func reloadCollectionViewDataWithTeamIndex(_ index: Int)
}

class MenuView: UICollectionReusableView {
    
    // MARK: - Properties
    var delegate: MenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.9, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        delegate = nil
    }
}
