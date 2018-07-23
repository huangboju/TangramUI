//
//  CSSearchBarHeader.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/7/23.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class CSSearchBarHeader: UICollectionReusableView {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(searchBar)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
