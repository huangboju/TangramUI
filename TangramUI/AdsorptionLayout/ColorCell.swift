//
//  ColorCell.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/5/13.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class ColorCell: UICollectionViewCell {
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        return textLabel
    }()
    
    private lazy var colorLayer: CALayer = {
       let colorLayer = CALayer()
        colorLayer.cornerRadius = 10
        return colorLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.addSublayer(colorLayer)
        contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = CGRect(origin: .zero, size: contentView.bounds.size)
        colorLayer.frame = CGRect(origin: .zero, size: contentView.bounds.size)
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
