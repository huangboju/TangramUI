//
//  CenterLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/1.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class CenterLayout: UICollectionViewFlowLayout {
    var attrCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    override func prepare() {
        attrCache.removeAll(keepingCapacity: true)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var updatedAttributes: [UICollectionViewLayoutAttributes] = []
        
        
        let sections = collectionView?.numberOfSections ?? 0
        for section in 0 ..< sections {

            let rows = collectionView?.numberOfItems(inSection: section) ?? 0
            for row in 0 ..< rows {

                let indexPath = IndexPath(row: row, section: section)

                if let attrs = layoutAttributesForItem(at: indexPath), attrs.frame.intersects(rect) {
                    updatedAttributes.append(attrs)
                }

                if let headerAttrs =  super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath), headerAttrs.frame.intersects(rect) {
                    updatedAttributes.append(headerAttrs)
                }
                
                if let footerAttrs =  super.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: indexPath), footerAttrs.frame.intersects(rect) {
                    updatedAttributes.append(footerAttrs)
                }
            }
        }
        
        return updatedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attr = attrCache[indexPath] {
            return attr
        }
        
        // Find the other items in the same "row"
        var rowBuddies: [UICollectionViewLayoutAttributes] = []
        
        // Calculate the available width to center stuff within
        // sectionInset is NOT applicable here because a) we're centering stuff
        // and b) Flow layout has arranged the cells to respect the inset. We're
        // just hijacking the X position.
        let collectionViewWidth = collectionView!.bounds.width -
            collectionView!.contentInset.left -
            collectionView!.contentInset.right
        
        // To find other items in the "row", we need a rect to check intersects against.
        // Take the item attributes frame (from vanilla flow layout), and stretch it out
        
        var rowTestFrame = super.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
        rowTestFrame.origin.x = 0
        rowTestFrame.size.width = collectionViewWidth

        let totalRows = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0
        
        // From this item, work backwards to find the first item in the row
        // Decrement the row index until a) we get to 0, b) we reach a previous row
        var rowStartIDX = indexPath.row
        while true {
            let prevIDX = rowStartIDX - 1
            
            if prevIDX < 0 {
                break
            }

            let prevPath = IndexPath(item: prevIDX, section: indexPath.section)
            let prevFrame = super.layoutAttributesForItem(at: prevPath)?.frame ?? .zero
            
            // If the item intersects the test frame, it's in the same row
            
            if prevFrame.intersects(rowTestFrame) {
                rowStartIDX = prevIDX
            } else {
                // Found previous row, escape!
                break
            }
        }
        
        // Now, work back UP to find the last item in the row
        // For each item in the row, add it's attributes to rowBuddies
        var buddyIDX = rowStartIDX
        while true {
            if buddyIDX > totalRows - 1 {
                break
            }

            let buddyPath = IndexPath(row: buddyIDX, section: indexPath.section)

            

            if let buddyAttributes = super.layoutAttributesForItem(at: buddyPath),
                buddyAttributes.frame.intersects(rowTestFrame) {
                // If the item intersects the test frame, it's in the same row
                rowBuddies.append(buddyAttributes.copy() as! UICollectionViewLayoutAttributes)
                buddyIDX += 1
            } else {
                break
            }
        }

        let flowDelegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout

        // x-x-x-x ... sum up the interim space
        var interitemSpacing = minimumInteritemSpacing

        // Check for minimumInteritemSpacingForSectionAtIndex support
        if rowBuddies.count > 0 {
            if let spacing = flowDelegate?.collectionView?(collectionView!, layout: self, minimumLineSpacingForSectionAt: indexPath.section) {
                interitemSpacing = spacing
            }
        }

        let aggregateInteritemSpacing = interitemSpacing * CGFloat(rowBuddies.count - 1)

        // Sum the width of all elements in the row
        var aggregateItemWidths: CGFloat = 0
        for itemAttributes in rowBuddies {
            aggregateItemWidths += itemAttributes.frame.width
        }
        
        // Build an alignment rect
        // |  |x-x-x-x|  |
        let alignmentWidth = aggregateItemWidths + aggregateInteritemSpacing
        let alignmentXOffset = (collectionViewWidth - alignmentWidth) / 2
        
        // Adjust each item's position to be centered
        var previousFrame = CGRect.zero
        for itemAttributes in rowBuddies {
            var itemFrame = itemAttributes.frame
            
            if previousFrame == .zero {
                itemFrame.origin.x = alignmentXOffset
            } else {
                itemFrame.origin.x = previousFrame.maxX + interitemSpacing
            }
            
            itemAttributes.frame = itemFrame
            previousFrame = itemFrame

            // Finally, add it to the cache
            attrCache[itemAttributes.indexPath] = itemAttributes
        }

        return attrCache[indexPath]
    }
}
