//
//  ReorderableTripletLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/23.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ReorderableTripletLayoutCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
}



class ReorderableTripletLayoutController: BaseController {
    
    private var images: [UIImage] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = ReorderableTripletLayout()
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReorderableTripletLayoutCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "headerCell")
        return collectionView
    }()

    override func initSubviews() {
        view.addSubview(collectionView)
        
        images = (1 ... 20).compactMap { UIImage(named: "\($0).jpg") }
    }
}

extension ReorderableTripletLayoutController: ReorderableTripletLayoutDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath)
            cell.backgroundColor = .red
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
            (cell as? ReorderableTripletLayoutCell)?.image = images[indexPath.row]
            cell.backgroundColor = .blue
            return cell
        }
    }
}

extension ReorderableTripletLayoutController: ReorderableTripletLayoutDelegate {
    func sectionSpacing(for collectionView: UICollectionView) -> CGFloat {
        return 5
    }

    func minimumInteritemSpacing(for collectionView: UICollectionView) -> CGFloat {
        return 5
    }
    
    func minimumLineSpacing(for collectionView: UICollectionView) -> CGFloat {
        return 5
    }

    func insets(for collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, sizeForLargeItemsIn section: Int) -> CGSize {
        return section == 0 ? CGSize(width: 320, height: 200) : .zero
    }

    func autoScrollTrigerEdgeInsets(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
    }
    
    func autoScrollTrigerPadding(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }

    func reorderingItemAlpha(_ collectionview: UICollectionView) -> CGFloat {
        return 0.3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, didEndDraggingItemAt indexPath: IndexPath) {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {
        
        let image = images[indexPath.item]
        images.remove(at: indexPath.item)
        images.insert(image, at: toIndexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath, canMoveTo toIndexPath: IndexPath) -> Bool {
        return toIndexPath.section != 0
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        if images.count == 1 {
            return
        }
        collectionView.performBatchUpdates({
            images.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }, completion: { _ in
            collectionView.reloadData()
        })
    }
}
