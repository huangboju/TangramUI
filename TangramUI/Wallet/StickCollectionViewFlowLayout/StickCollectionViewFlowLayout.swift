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
    
        for obj in oldItems {
            if obj.representedElementKind == UICollectionView.elementKindSectionHeader {
                headerAttributes = obj
            } else {
                updateCellAttributes(obj, withSectionHeader: headerAttributes)
                
            }
        }

        return oldItems
    }
    
    private func updateCellAttributes(_ attributes: UICollectionViewLayoutAttributes, withSectionHeader headerAttributes: UICollectionViewLayoutAttributes?) {
        var top = collectionView!.contentInset.top
        if #available(iOS 11, *) {
            top = collectionView!.adjustedContentInset.top
        }

        let minY = collectionView!.bounds.minY + top
        let maxY = attributes.frame.minY - (headerAttributes?.bounds.height ?? 0)
        let finalY = max(minY, maxY)
        
        let deltaY = (finalY - attributes.frame.minY) / attributes.frame.height
        
        if firstItemTransform > 0 {
            attributes.transform = CGAffineTransform(scaleX: 1 - deltaY * firstItemTransform, y: 1 - deltaY * firstItemTransform)
        }
        
        attributes.frame.origin.y = finalY
        attributes.zIndex = attributes.indexPath.row
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
