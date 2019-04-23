//
//  HeaderView.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/26.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class HeaderView: UICollectionReusableView {
    
    private lazy var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black
        return overlayView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "header"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(overlayView)
        overlayView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        overlayView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    // MARK: - Life Cycle
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let customFlowLayoutAttributes = layoutAttributes as? CustomLayoutAttributes else {
            return
        }

        overlayView.alpha = customFlowLayoutAttributes.headerOverlayAlpha
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
