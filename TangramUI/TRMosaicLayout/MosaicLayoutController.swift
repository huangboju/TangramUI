//
//  MosaicLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/3.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

private let reuseIdentifier = "TRMosaicCell"

class MosaicLayoutCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}

class MosaicLayoutController: BaseController, UICollectionViewDataSource {

    let photos = Photo.allPhotos()
    
    private lazy var collectionView: UICollectionView = {
        let layout = TRMosaicLayout()

        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(MosaicLayoutCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func initSubviews() {
        
        view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        (cell as? MosaicLayoutCell)?.image = photos[indexPath.item % photos.count].image
        return cell
    }
}

extension MosaicLayoutController: TRMosaicLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, mosaicCellSizeTypeAt indexPath:IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? .big : .small
    }

    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout: TRMosaicLayout, insetAtSection: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }

    func heightForSmallMosaicCell() -> CGFloat {
        return 150
    }
}
