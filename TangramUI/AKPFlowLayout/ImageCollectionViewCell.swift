//
//  ImageCollectionViewCell.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2018/6/14.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import Kingfisher
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        textLabel.text = "Image Caption"
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.setContentHuggingPriority(.required, for: .vertical)
        textLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        return textLabel
    }()

    var url: String? {
        didSet {
            imageView.sd_imageTransition = .fade
            imageView.sd_setImage(with: URL(string: url ?? ""), placeholderImage: nil, options: .cacheMemoryOnly, completed: nil)
//            imageView.kf.setImage(with: URL(string: url ?? ""), options: [.transition(.fade(0.25)), .cacheMemoryOnly, .backgroundDecode])
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor,
                                              multiplier: 0.90),

            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
