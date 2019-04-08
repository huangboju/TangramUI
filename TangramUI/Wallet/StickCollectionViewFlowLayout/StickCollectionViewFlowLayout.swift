//
//  StickCollectionViewFlowLayout.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2018/12/29.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

import UIKit

class StickCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var firstItemTransform: CGFloat = 0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let oldItems = super.layoutAttributesForElements(in: rect) else { return nil }
        var headerAttributes: UICollectionViewLayoutAttributes?
        var result: [UICollectionViewLayoutAttributes] = []
        for obj in oldItems {
            guard let arrt = obj.copy() as? UICollectionViewLayoutAttributes else { continue }
            if arrt.representedElementKind == UICollectionView.elementKindSectionHeader {
                headerAttributes = arrt
            } else {
                updateCellAttributes(arrt, withSectionHeader: headerAttributes)
            }
            result.append(arrt)
        }

        return result
    }
    
    private func updateCellAttributes(_ attributes: UICollectionViewLayoutAttributes, withSectionHeader headerAttributes: UICollectionViewLayoutAttributes?) {
        let top = collectionView!.realContentInset.top

        let minY = collectionView!.bounds.minY + top
        let maxY = attributes.frame.minY - (headerAttributes?.bounds.height ?? 0)
        let finalY = max(minY, maxY)

        if firstItemTransform > 0 {
            let deltaY = (finalY - attributes.frame.minY) / attributes.frame.height
            attributes.transform = CGAffineTransform(scaleX: 1 - deltaY * firstItemTransform, y: 1 - deltaY * firstItemTransform)
        }
        attributes.frame.origin.y = finalY
        attributes.zIndex = attributes.indexPath.row
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
