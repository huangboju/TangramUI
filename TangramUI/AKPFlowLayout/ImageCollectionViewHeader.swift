//
//  ImageCollectionViewHeader.swift
//  SwiftNetworkImages
//
//  Created by Arseniy on 4/5/16.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.
//

import UIKit


/// A custom UICollectionReusableView section header


class ImageCollectionViewHeader: UICollectionReusableView {
    private lazy var sectionHeaderLabel: UILabel = {
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        sectionHeaderLabel.text = "Section Header"
        sectionHeaderLabel.textAlignment = .center
        sectionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        return sectionHeaderLabel
    }()
    
    var sectionHeaderText: String? {
        didSet {
            sectionHeaderLabel.text = sectionHeaderText
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sectionHeaderLabel)

        backgroundColor = .lightGray
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension ImageCollectionViewHeader {
    // MARK: - 📐Constraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            sectionHeaderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            sectionHeaderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
}


