//
//  InspirationCell.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/12/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class InspirationCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 38)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        return titleLabel
    }()

    private lazy var timeAndRoomLabel: UILabel = {
        let timeAndRoomLabel = UILabel()
        timeAndRoomLabel.translatesAutoresizingMaskIntoConstraints = false
        timeAndRoomLabel.textAlignment = .center
        timeAndRoomLabel.textColor = .white
        return timeAndRoomLabel
    }()
    
    private lazy var speakerLabel: UILabel = {
        let speakerLabel = UILabel()
        speakerLabel.translatesAutoresizingMaskIntoConstraints = false
        speakerLabel.textAlignment = .center
        speakerLabel.textColor = .white
        return speakerLabel
    }()

    private lazy var imageCoverView: UIView = {
        let imageCoverView = UIView()
        imageCoverView.translatesAutoresizingMaskIntoConstraints = false
        imageCoverView.backgroundColor = .black
        return imageCoverView
    }()
    
    var inspiration:Inspiration? {
        didSet{
            if let inspiration = inspiration{
                imageView.image = inspiration.backgroundImage
                titleLabel.text = inspiration.title
                timeAndRoomLabel.text = inspiration.roomAndTime
                speakerLabel.text = inspiration.speaker
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive
        = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true


        addSubview(imageCoverView)
        imageCoverView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageCoverView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive
            = true
        imageCoverView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageCoverView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        imageCoverView.addSubview(timeAndRoomLabel)
        imageCoverView.leadingAnchor.constraint(equalTo: timeAndRoomLabel.leadingAnchor).isActive = true
        imageCoverView.centerXAnchor.constraint(equalTo: timeAndRoomLabel.centerXAnchor).isActive = true
        
        
        imageCoverView.addSubview(speakerLabel)
        imageCoverView.trailingAnchor.constraint(equalTo: speakerLabel.trailingAnchor).isActive = true
        imageCoverView.leadingAnchor.constraint(equalTo: speakerLabel.leadingAnchor).isActive = true
        speakerLabel.topAnchor.constraint(equalTo: timeAndRoomLabel.bottomAnchor).isActive = true


        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: timeAndRoomLabel.topAnchor, constant: -11).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        // 1
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight

        // 2
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))
        
        // 3
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        timeAndRoomLabel.alpha = delta
        speakerLabel.alpha = delta
    }
}
