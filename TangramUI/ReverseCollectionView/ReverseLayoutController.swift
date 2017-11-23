//
//  ReverseLayoutController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/18.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ReverseLayoutController: BaseController {
    
    var numberOfItems = 3

    private lazy var collectionView: UICollectionView = {
        let layout = ReverseLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: 44)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(ReverseLayoutCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    override func initSubviews() {
        view.addSubview(collectionView)
        
        let stepper = UIStepper()
        stepper.minimumValue = Double(numberOfItems)
        stepper.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        navigationItem.titleView = stepper
    }
    
    @objc
    private func valueChanged(_ sender: UIStepper) {
        numberOfItems = Int(sender.value)
        collectionView.reloadData()
    }
}

extension ReverseLayoutController: UICollectionViewDataSource {
    // MARK - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.lightGray
        (cell as? ReverseLayoutCell)?.updateCell(with: "\(indexPath.row)")
        return cell
    }
}

class ReverseLayoutCell: UICollectionViewCell {
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func updateCell(with text: String) {
        textLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
