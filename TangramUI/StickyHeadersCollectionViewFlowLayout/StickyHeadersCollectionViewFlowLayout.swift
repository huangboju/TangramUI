//
//  StickyHeadersCollectionViewFlowLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/7/21.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class StickyHeadersCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Collection View Flow Layout Methods
    
    override func prepare() {
        super.prepare()
        if #available(iOS 10, *) {
            collectionView?.isPrefetchingEnabled = false
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // Helpers
        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for layoutAttributesSet in layoutAttributes {
            if layoutAttributesSet.representedElementCategory == .cell {
                // Add Layout Attributes
                newLayoutAttributes.append(layoutAttributesSet)
                
                // Update Sections to Add
                let indexPath = IndexPath(item: 0, section: layoutAttributesSet.indexPath.section)
                
                if let sectionAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                    newLayoutAttributes.append(sectionAttributes)
                }
                
            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
                // Update Sections to Add
                let indexPath = IndexPath(item: 0, section: layoutAttributesSet.indexPath.section)
                
                if let sectionAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                    newLayoutAttributes.append(sectionAttributes)
                }
            }
        }
        
        return newLayoutAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
        let boundaries = self.boundaries(forSection: indexPath.section)
        guard let collectionView = collectionView else { return layoutAttributes }
        
        // Helpers
        
        var top = collectionView.contentInset.top
        if #available(iOS 11, *) {
            top = collectionView.adjustedContentInset.top
        }
        
        let contentOffsetY = collectionView.contentOffset.y + top
        var frameForSupplementaryView = layoutAttributes.frame
        
        let minimum = boundaries.minimum - frameForSupplementaryView.height
        let maximum = boundaries.maximum - frameForSupplementaryView.height

        if contentOffsetY < minimum {
            frameForSupplementaryView.origin.y = minimum
        } else if contentOffsetY > maximum {
            frameForSupplementaryView.origin.y = maximum
        } else {
            frameForSupplementaryView.origin.y = contentOffsetY
        }
        
        layoutAttributes.frame = frameForSupplementaryView
        
        return layoutAttributes
    }
    
    // MARK: - Helper Methods
    
    func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat) {
        // Helpers
        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
        
        // Exit Early
        guard let collectionView = collectionView else { return result }
        
        // Fetch Number of Items for Section
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        
        // Exit Early
        guard numberOfItems > 0 else { return result }
        
        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
            let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
            result.minimum = firstItem.frame.minY
            result.maximum = lastItem.frame.maxY
            
            // Take Header Size Into Account
            result.minimum -= headerReferenceSize.height
            result.maximum -= headerReferenceSize.height
            
            // Take Section Inset Into Account
            result.minimum -= sectionInset.top
            result.maximum += (sectionInset.top + sectionInset.bottom)
        }
        
        return result
    }
    
}
