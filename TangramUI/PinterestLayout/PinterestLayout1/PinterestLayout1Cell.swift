//
//  PinterestLayout1Cell.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/26.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import FLAnimatedImage
import Nuke

class PinterestLayout1Cell: UICollectionViewCell {
    
    private lazy var imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return imageView
    }()
    
//    private lazy var imageView: UIImageView = {
//        let _imageView = UIImageView()
//        _imageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
//        return _imageView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }

    var url: String? {
        didSet {
            
            let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.25))
            imageView.loadImage(with: URL(string: url ?? "")!, options: options)
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
