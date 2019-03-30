//
//  ViewController.swift
//  StretchyCollection
//
//  Created by Ryan Poolos on 1/19/16.
//  Copyright © 2016 Frozen Fire Studios, Inc. All rights reserved.
//

import UIKit

class StretchyCollectionViewLayoutVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "Stretchy Header"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.lightGray
        
        view.addSubview(collectionView)
        
        let views = ["collectionView": collectionView]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: views))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionLayout.itemSize = CGSize(width: size.width - (padding * 2.0), height: 64.0)
    }
    
    //==========================================================================
    // MARK: - UICollectionViewDataSource
    //==========================================================================
    
    private let cellIdentifier = "UniqueCellIdentifier"
    private let headerIdentifier = "UniqueHeaderIdentifier"
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath)
        return view
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    let padding: CGFloat = 8.0
    
    lazy var collectionLayout: StretchyCollectionViewLayout = { [unowned self] in
        let layout = StretchyCollectionViewLayout()
        layout.itemSpacing = self.padding
        layout.itemSize = CGSize(width: self.view.bounds.width - (self.padding * 2.0), height: 64.0)
        layout.sectionInset = UIEdgeInsets(top: self.padding, left: self.padding, bottom: 32.0, right: self.padding)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.lightGray
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        collectionView.register(StretchyHeaderView.self, forSupplementaryViewOfKind: StretchyCollectionHeaderKind, withReuseIdentifier: self.headerIdentifier)
        
        return collectionView
    }()
}

