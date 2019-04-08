//
//  StretchyHeaderLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/28.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class StretchyHeaderLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let top = collectionView?.realContentInset.top ?? 0
        let offset = collectionView?.contentOffset ?? .zero
        let minY = -top

        let attributes = super.layoutAttributesForElements(in: rect)

        if offset.y < minY {
            let headerSize = headerReferenceSize
            let  deltaY = abs(offset.y - minY)
            collectionView?.scrollIndicatorInsets.top = headerSize.height

            guard let att = attributes else {
                return attributes
            }
            for attrs in att where attrs.representedElementKind == UICollectionView.elementKindSectionHeader {
                attrs.frame.size.height = max(minY, headerSize.height + deltaY)
                attrs.frame.origin.y = attrs.frame.minY - deltaY
                break
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
