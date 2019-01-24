//
//  JungleCupController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/26.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

/// https://github.com/joshqn/JungleCup

class JungleCupCollectionViewController: BaseController {
    
    private let teams: [Team] = [Owls(), Giraffes(), Parrots(), Tigers()]
    private let sections = ["Goalkeeper", "Defenders", "Midfielders", "Forwards"]
    private var displayedTeam = 0
    
    private let customLayout = CustomLayout()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: customLayout)
        collectionView.frame.origin.y = 64
        collectionView.frame.size.height -= 64
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(PlayerCell.self, forCellWithReuseIdentifier: CustomLayout.Element.cell.id)
        return collectionView
    }()

    override func initSubviews() {
        setupCollectionViewLayout()

        view.addSubview(UIView())
        
        view.addSubview(collectionView)
    }
    
    func setupCollectionViewLayout() {

        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: CustomLayout.Element.header.kind,
            withReuseIdentifier: CustomLayout.Element.header.id
        )
        
        
        collectionView.register(
            MenuView.self,
            forSupplementaryViewOfKind: CustomLayout.Element.menu.kind,
            withReuseIdentifier: CustomLayout.Element.menu.id
        )
        
        collectionView.register(
            JCSectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CustomLayout.Element.sectionHeader.id
        )
        
        collectionView.register(
            JCSectionFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: CustomLayout.Element.sectionFooter.id
        )

        customLayout.settings.itemSize = CGSize(width: collectionView.frame.width, height: 200)
        customLayout.settings.headerSize = CGSize(width: collectionView.frame.width, height: 300)
        customLayout.settings.menuSize = CGSize(width: collectionView.frame.width, height: 70)
        customLayout.settings.sectionsHeaderSize = CGSize(width: collectionView.frame.width, height: 50)
        customLayout.settings.sectionsFooterSize = CGSize(width: collectionView.frame.width, height: 50)
        customLayout.settings.isHeaderStretchy = true
        customLayout.settings.isAlphaOnHeaderActive = true
        customLayout.settings.headerOverlayMaxAlphaValue = 0.6
        customLayout.settings.isMenuSticky = true
        customLayout.settings.isSectionHeadersSticky = true
        customLayout.settings.isParallaxOnCellsEnabled = true
        customLayout.settings.maxParallaxOffset = 60
        customLayout.settings.minimumInteritemSpacing = 0
        customLayout.settings.minimumLineSpacing = 3
    }
}

extension JungleCupCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams[displayedTeam].playerPictures[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomLayout.Element.cell.id, for: indexPath)
        if let playerCell = cell as? PlayerCell {
            playerCell.updateView(with: UIImage(named: teams[displayedTeam].playerPictures[indexPath.section][indexPath.item]))
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomLayout.Element.sectionHeader.id, for: indexPath)
            if supplementaryView is JCSectionHeaderView {
//                sectionHeaderView.title.text = sections[indexPath.section]
            }
            return supplementaryView

        case UICollectionView.elementKindSectionFooter:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomLayout.Element.sectionFooter.id, for: indexPath)
            if supplementaryView is JCSectionFooterView {
//                sectionFooterView.mark.text = "Strength: \(teams[displayedTeam].marks[indexPath.section])"
            }
            return supplementaryView
            
        case CustomLayout.Element.header.kind:
            let topHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomLayout.Element.header.id,
                for: indexPath
            )
            return topHeaderView
            
        case CustomLayout.Element.menu.kind:
            let menuView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CustomLayout.Element.menu.id,
                for: indexPath
            )
            if menuView is MenuView {
//                menuView.delegate = self
            }
            return menuView
            
        default:
            fatalError("Unexpected element kind")
        }
    }
}
