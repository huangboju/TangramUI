//
//  ServiceLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

let SCREEN_WIDTH = UIScreen.main.bounds.width

protocol ServiceLayoutDelegate: class {

    func heightOfSectionHeader(for indexPath: IndexPath) -> CGFloat

    func heightOfSectionFooter(for indexPath: IndexPath) -> CGFloat
}

extension ServiceLayoutDelegate {

    func heightOfSectionHeader(for indexPath: IndexPath) -> CGFloat { return 0 }

    func heightOfSectionFooter(for indexPath: IndexPath) -> CGFloat { return 0 }
}

class ServiceLayout: UICollectionViewLayout {
    
    weak var delegate: ServiceLayoutDelegate?
    
    private var totalHeight: CGFloat = 0

    private var attributesArr: [UICollectionViewLayoutAttributes] = []

    override func prepare() {
        super.prepare()
        
        
        guard let collectionView = collectionView else { return }
        
        let sectionCount = collectionView.numberOfSections

        for i in 0 ..< sectionCount {
            
            let indexPath = IndexPath(index: i)

            if let attr = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
                attributesArr.append(attr)
            }

            let itemCount = collectionView.numberOfItems(inSection: i)
            
            for j in 0 ..< itemCount {
                let indexPath = IndexPath(item: j, section: i)
                guard let attrs = layoutAttributesForItem(at: indexPath) else { continue }
                attributesArr.append(attrs)
            }

            if let attr1 = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: indexPath) {
                attributesArr.append(attr1)
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: totalHeight)
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let layoutAttrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        var height: CGFloat = 0
        
        if elementKind == UICollectionElementKindSectionHeader {
            height = delegate?.heightOfSectionHeader(for: indexPath) ?? 0
        } else {
            height = delegate?.heightOfSectionFooter(for: indexPath) ?? 0
        }
        layoutAttrs.frame = CGRect(x: 0, y: totalHeight, width: SCREEN_WIDTH, height: height)
        totalHeight += height
        return layoutAttrs
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArr
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        switch indexPath.section {
        case 0:
            layoutAttributesForServiceLayout(with: layoutAttributes, at: indexPath)
        case 1:
            layoutAttributesForCopyRightlayout(with: layoutAttributes, at: indexPath)
        case 2:
            layoutAttributesForPatentLayout(with: layoutAttributes, at: indexPath)
        case 3:
            layoutAttributesForCaseLayout(with: layoutAttributes, at: indexPath)
        default:
            break
        }
        return layoutAttributes
    }
    
    /// 服务
    private func layoutAttributesForServiceLayout(with layoutAttributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath) {
        let y = totalHeight
        if indexPath.item == 0 {
            layoutAttributes.frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH, height: kBaseLine(85))
            totalHeight += kBaseLine(85)
        } else {
            if indexPath.item > 6 { return }
            let row = CGFloat(indexPath.item - 1).truncatingRemainder(dividingBy: 3)
            let width = SCREEN_WIDTH / 3.0
            layoutAttributes.frame = CGRect(x: row * width, y: y, width: width, height: kBaseLine(100))
            if indexPath.item == 3 || indexPath.item == collectionView!.numberOfItems(inSection: indexPath.section) - 1 {
                self.totalHeight += kBaseLine(100)
            }
        }
    }

    /// 版权
    func layoutAttributesForCopyRightlayout(with layoutAttributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath) {
        let y = self.totalHeight
        let width = SCREEN_WIDTH / 2.0
        let height = kBaseLine(160)
        switch (indexPath.item) {
        case 0:
            layoutAttributes.frame = CGRect(x: 0, y: y, width: width, height: height)
        case 1:
            layoutAttributes.frame = CGRect(x: width, y: y, width: width, height: height / 2.0)
        case 2:
            layoutAttributes.frame = CGRect(x: width, y: (height / 2.0) + y, width: width, height: height / 2.0)
        default:
            break
        }

        if indexPath.item == collectionView!.numberOfItems(inSection: indexPath.section) - 1 {
            totalHeight += height
        }
    }
    
    /// 专利
    func layoutAttributesForPatentLayout(with layoutAttributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath) {
        let y = totalHeight
        var height: CGFloat = 0
        switch (indexPath.item) {
        case 0:
            layoutAttributes.frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH, height: kBaseLine(85))
            height = kBaseLine(85)
        case 1:
            layoutAttributes.frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH / 2.0, height: kBaseLine(80))
            height = kBaseLine(80)
        case 2:
            layoutAttributes.frame = CGRect(x: SCREEN_WIDTH / 2.0, y: y, width: SCREEN_WIDTH / 2.0, height: kBaseLine(80))
            height = kBaseLine(80)
        default:
            break
        }

        if indexPath.item == 0 || indexPath.item == collectionView!.numberOfItems(inSection: indexPath.section) - 1 {
            totalHeight += height
        }
    }
    
    /// 案件
    func layoutAttributesForCaseLayout(with layoutAttributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath)  {
        let y = totalHeight
        switch indexPath.item {
        case 0:
            layoutAttributes.frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH / 2.0, height: kBaseLine(80))
            totalHeight += kBaseLine(80)
        case 1:
            layoutAttributes.frame = CGRect(x: 0, y: y, width: SCREEN_WIDTH/2.0, height: kBaseLine(80))
            totalHeight += kBaseLine(80)
        case 2:
            layoutAttributes.frame = CGRect(x: SCREEN_WIDTH/2.0, y: y - kBaseLine(160), width: SCREEN_WIDTH/2.0, height: kBaseLine(160))
        default:
            break
        }
    }
}


let kBaseLine: (CGFloat) -> CGFloat = { $0 * SCREEN_WIDTH / 375.0 }

