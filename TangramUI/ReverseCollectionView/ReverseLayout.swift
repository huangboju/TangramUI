//
//  ReverseLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/18.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class ReverseLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Do we need to stick cells to the bottom or not
        var shiftDownNeeded = false

        // Size of all cells without modifications
        let allContentSize = super.collectionViewContentSize

        // If there are not enough cells to fill collection view vertically we shift them down
        let diff = self.collectionView!.bounds.height - allContentSize.height

        if Double(diff) > Double.ulpOfOne {
            shiftDownNeeded = true
        }
        
        // Ask for common attributes
        let attributes = super.layoutAttributesForElements(in: rect)

        if let attributes = attributes, shiftDownNeeded {
            for element in attributes {
                let frame = element.frame
                // shift all the cells down by the difference of heights
                element.frame = frame.offsetBy(dx: 0, dy: diff)
            }
        }
        
        return attributes
    }
}
