//
//  AdsorptionController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/5/13.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class AdsorptionController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = AdsorptionLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.firstItemRetractableAreaInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        var rect = self.view.frame
        rect.origin.y = 64
        rect.size.height -= 64
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    fileprivate var filteredNames: [String]!
    
    fileprivate var readyForPresentation = false

    fileprivate let colors: [String: UIColor] = [
        "Emma":     UIColor(r: 81, g: 81, b: 79),
        "Oliver":   UIColor(r: 242, g: 94, b: 92),
        "Jack":     UIColor(r: 242, g: 167, b: 92),
        "Olivia":   UIColor(r: 229, g: 201, b: 91),
        "Harry":    UIColor(r: 35, g: 123, b: 160),
        "Sophia":   UIColor(r: 112, g: 193, b: 178)
    ]
    
    fileprivate let names = ["Emma", "Oliver", "Jack", "Olivia", "Harry", "Sophia"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredNames = names

        collectionView.register(SearchBarCell.self, forCellWithReuseIdentifier: "SearchBarCell")
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")

        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
}

extension AdsorptionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return filteredNames.count
        default:
            assert(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchBarCell", for: indexPath) as! SearchBarCell

            cell.searchBar.searchBarStyle = .minimal
            cell.searchBar.placeholder = "Search - \(self.names.count) names"
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell

            let name = self.filteredNames[indexPath.item]

            cell.colorLayer.backgroundColor = self.colors[name]?.cgColor

            cell.textLabel.textColor = UIColor.white
            cell.textLabel.textAlignment = .center
            cell.textLabel.text = name

            return cell
            
        default:
            assert(false)
        }
    }
}

extension AdsorptionController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
            
        case 0:
            return UIEdgeInsets.zero
            
        case 1:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            
        default:
            assert(false)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            let itemWidth = collectionView.frame.width
            let itemHeight: CGFloat = 44.0
            
            return CGSize(width: itemWidth, height: itemHeight)
            
        case 1:

            return CGSize(width: 80, height: 80)
            
        default:
            assert(false)
        }
    }
}
