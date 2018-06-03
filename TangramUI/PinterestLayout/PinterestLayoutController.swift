//
//  PinterestLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/29.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class PinterestLayoutController: BaseController {
    let layout = PinterestLayout()

    var photos = Photo.allPhotos()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AnnotatedPhotoCell.self, forCellWithReuseIdentifier: "AnnotatedPhotoCell")
        return collectionView
    }()

    override func initSubviews() {

        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }

        view.addSubview(collectionView)
    }
}

extension PinterestLayoutController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
        if let annotateCell = cell as? AnnotatedPhotoCell {
            annotateCell.photo = photos[indexPath.item]
        }
        return cell
    }
    
}

//MARK: - PINTEREST LAYOUT DELEGATE
extension PinterestLayoutController: PinterestLayoutDelegate {

    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath) -> CGFloat {
        return photos[indexPath.item].image.size.height
    }   
}

class AnnotatedPhotoCell: UICollectionViewCell {
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(r: 12, g: 92, b: 42)
        return containerView
    }()
    
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(r: 12, g: 92, b: 42)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var captionLabel: UILabel = {
        let captionLabel = UILabel()
        captionLabel.font = UIFont.boldSystemFont(ofSize: 12)
        captionLabel.textColor = .white
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        return captionLabel
    }()

    private lazy var commentLabel: UILabel = {
        let commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: 10)
        commentLabel.textColor = .white
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.numberOfLines = 0
        return commentLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // !!! 这里用contentView约束会不对
        
        addSubview(containerView)

        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        containerView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        
        containerView.addSubview(captionLabel)
        captionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4).isActive = true
        captionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        captionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true

        containerView.addSubview(commentLabel)
        commentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4).isActive = true
        commentLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        commentLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 2).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }

    
    var photo: Photo? {
        didSet {
            imageView.image = photo?.image
            captionLabel.text = photo?.caption
            commentLabel.text = photo?.comment
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
