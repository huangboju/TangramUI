//
//  ServiceLeftPicCell.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ServiceLeftPicCell: UICollectionViewCell {
    private lazy var imgView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(r: 51, g: 51, b: 51)
        textLabel.font = UIFont.systemFont(ofSize: 13)
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        drawBorder(borderWidth: 0.5, color: UIColor(r: 235, g: 235, b: 235))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UICollectionViewCell {
    func drawBorder(borderWidth: CGFloat, color: UIColor) {
        contentView.layer.borderWidth = borderWidth
        contentView.layer.borderColor = color.cgColor
    }
}
