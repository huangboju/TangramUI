//
//  StretchyHeaderLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/28.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class StretchyHeaderLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let insets = collectionView?.contentInset ?? .zero
        let offset = collectionView?.contentOffset ?? .zero
        let minY = -insets.top

        let attributes = super.layoutAttributesForElements(in: rect)

        if offset.y < minY {
            let headerSize = headerReferenceSize
            let  deltaY = abs(offset.y - minY)

            if let attributes = attributes {
                for attrs in attributes {
                    if attrs.representedElementKind == UICollectionView.elementKindSectionHeader  {
                        var headerRect = attrs.frame
                        headerRect.size.height = max(minY, headerSize.height + deltaY)
                        headerRect.origin.y = headerRect.origin.y - deltaY
                        attrs.frame = headerRect
                        break
                    }
                }
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
