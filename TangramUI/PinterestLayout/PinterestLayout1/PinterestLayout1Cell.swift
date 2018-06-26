//
//  PinterestLayout1Cell.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/26.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import FLAnimatedImage

class PinterestLayout1Cell: UICollectionViewCell {
    
//    private lazy var imageView: FLAnimatedImageView = {
//        let imageView = FLAnimatedImageView()
//        imageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
//        return imageView
//    }()
    
    private lazy var imageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return _imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }

    var url: String? {
        didSet {
            imageView.sd_imageTransition = .fade
            imageView.sd_setImage(with: URL(string: url ?? ""), placeholderImage: nil, options: .cacheMemoryOnly, completed: nil)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
