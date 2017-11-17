//
//  ServiceLeftPicCell.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ServiceLeftPicCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ser_zl02"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(r: 51, g: 51, b: 51)
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.text = "商标注册"
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        drawBorder(borderWidth: 0.5, color: UIColor(r: 235, g: 235, b: 235))
        
        contentView.backgroundColor = UIColor.random
        
//        contentView.addSubview(textLabel)
//
//
//        contentView.addSubview(imageView)
//
//        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: kBaseLine(25)).isActive = true
//        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: kBaseLine(34)).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: kBaseLine(32)).isActive = true
//
//
//        textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: kBaseLine(19)).isActive = true
//        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
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
