//
//  StretchyCollectionViewLayout.swift
//  StretchyCollection
//
//  Created by Ryan Poolos on 1/19/16.
//  Copyright © 2016 Frozen Fire Studios, Inc. All rights reserved.
//

import UIKit

let StretchyCollectionHeaderKind = "StretchyCollectionHeaderKind"

class StretchyCollectionViewLayout: UICollectionViewLayout {
    
    let startingHeaderHeight: CGFloat = 128.0
    
    var sectionInset = UIEdgeInsets.zero
    var itemSize = CGSize.zero
    var itemSpacing: CGFloat = 0.0
    
    var attributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        
        // Start with a fresh array of attributes
        attributes = []
        
        // Can't do much without a collectionView.
        guard let collectionView = collectionView else {
            return
        }
        
        let numberOfSections = collectionView.numberOfSections
        
        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                if let attribute = layoutAttributesForItem(at: indexPath) {
                    attributes.append(attribute)
                }
            }
        }

        let headerIndexPath = IndexPath(item: 0, section: 0)
        if let headerAttribute = layoutAttributesForSupplementaryView(ofKind: StretchyCollectionHeaderKind, at: headerIndexPath) {
            attributes.append(headerAttribute)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let visibleAttributes = attributes.filter { attribute -> Bool in
            return rect.contains(attribute.frame) || rect.intersects(attribute.frame)
        }
        
        // Check for our Stretchy Header
        // We want to find a collectionHeader and stretch it while scrolling.
        // But first lets make sure we've scrolled far enough.
        let offset = collectionView?.contentOffset ?? CGPoint.zero
        let minY = -sectionInset.top
        if offset.y < minY {
            let extraOffset = abs(offset.y - minY)
            
            // Find our collectionHeader and stretch it while scrolling.
            let stretchyHeader = visibleAttributes.filter { attribute -> Bool in
                return attribute.representedElementKind == StretchyCollectionHeaderKind
            }.first
            
            if let collectionHeader = stretchyHeader {
                let headerSize = collectionHeader.frame.size
                collectionHeader.frame.size.height = max(minY, headerSize.height + extraOffset)
                collectionHeader.frame.origin.y = collectionHeader.frame.origin.y - extraOffset
            }
        }
        
        return visibleAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }

        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        var sectionOriginY = startingHeaderHeight + sectionInset.top
        
        if indexPath.section > 0 {
            let previousSection = indexPath.section - 1
            let lastItem = collectionView.numberOfItems(inSection: previousSection) - 1
            let previousCell = layoutAttributesForItem(at: IndexPath(item: lastItem, section: previousSection))
            sectionOriginY = (previousCell?.frame.maxY ?? 0) + sectionInset.bottom
        }
        
        let itemOriginY = sectionOriginY + CGFloat(indexPath.item) * (itemSize.height + itemSpacing)
        
        attribute.frame = CGRect(x: sectionInset.left, y: itemOriginY, width: itemSize.width, height: itemSize.height)
        
        return attribute
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }
        
        let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: StretchyCollectionHeaderKind, with: indexPath)
        attribute.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: startingHeaderHeight)
        return attribute
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }
        
        let numberOfSections = collectionView.numberOfSections
        let lastSection = numberOfSections - 1
        let numberOfItems = collectionView.numberOfItems(inSection: lastSection)
        let lastItem = numberOfItems - 1
        
        guard let lastCell = layoutAttributesForItem(at: IndexPath(item: lastItem, section: lastSection)) else {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.frame.width, height: lastCell.frame.maxY + sectionInset.bottom)
    }
}
