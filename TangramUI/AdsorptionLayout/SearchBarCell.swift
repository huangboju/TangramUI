//
//  SearchBarCell.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/5/13.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class SearchBarCell: UICollectionViewCell {
    let searchBar = UISearchBar()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(searchBar)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = CGRect(origin: .zero, size: contentView.bounds.size)
    }

    override class var requiresConstraintBasedLayout: Bool {
        return false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
