//
//  ExcelLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/27.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ExcelLayoutController: BaseController {
    
    private lazy var collectionView: UICollectionView = {
        let excelLayout = ExcelLayout()
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: excelLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(ExcelLayoutCell.self, forCellWithReuseIdentifier: "cellId")
        return collectionView
    }()
    
    override func initSubviews() {
        
        view.addSubview(collectionView)
    }
}

extension ExcelLayoutController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId",
                                                      for: indexPath) as! ExcelLayoutCell

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.updateView(with: "Date")
            } else {
                cell.updateView(with: "Section")
            }
        } else {
            if indexPath.row == 0 {
                cell.updateView(with: "\(indexPath.section)")
            } else {
                cell.updateView(with: "Content")
            }
        }
        
        return cell
    }
}


class ExcelLayoutCell: UICollectionViewCell {
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        return textLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(textLabel)

        textLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }

    func updateView(with text: String?) {
        textLabel.text = text
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let indexPath = layoutAttributes.indexPath
        if indexPath.section % 2 != 0 {
            backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
        } else {
            backgroundColor = UIColor.white
        }
        if indexPath == IndexPath(item: 0, section: 0) {
            backgroundColor = .red
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
