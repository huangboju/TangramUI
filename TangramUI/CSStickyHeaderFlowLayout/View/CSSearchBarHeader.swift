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
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        
        addSubview(searchBar)
        searchBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
