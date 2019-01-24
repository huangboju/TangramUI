//
//  UltravisualLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/12/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

/* The heights are declared as constants outside of the class so they can be easily referenced elsewhere */
struct UltravisualLayoutConstants {
    struct Cell {
        /* The height of the non-featured cell */
        static let standardHeight: CGFloat = 100
        /* The height of the first visible cell */
        static let featuredHeight: CGFloat = 280
    }
}

class ExpandingLayout: UICollectionViewLayout {
    
    // MARK: Properties and Variables
    
    /* The amount the user needs to scroll before the featured cell changes */
    let dragOffset: CGFloat = 180.0

    var cache = [UICollectionViewLayoutAttributes]()
    
    /* Returns the item index of the currently featured cell */
    var featuredItemIndex: Int {
        /* Use max to make sure the featureItemIndex is never < 0 */
        return max(0, Int(contentOffsetY / dragOffset))
    }

    /* Returns a value between 0 and 1 that represents how close the next cell is to becoming the featured cell */
    var nextItemPercentageOffset: CGFloat {
        return (contentOffsetY / dragOffset) - CGFloat(featuredItemIndex)
    }

    var contentOffsetY: CGFloat {
        return collectionView?.contentOffset.y ?? 0
    }

    /* Returns the width of the collection view */
    var width: CGFloat {
        return collectionView?.bounds.width ?? 0
    }
    
    /* Returns the height of the collection view */
    var height: CGFloat {
        return collectionView?.bounds.height ?? 0
    }
    
    /* Returns the number of items in the collection view */
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    // MARK: UICollectionViewLayout
    
    /* Return the size of all the content in the collection view */
    
    override var collectionViewContentSize: CGSize{
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0 ..< numberOfItems {
            // 1
            let indexPath = IndexPath(item: item, section:0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 2
            attributes.zIndex = item
            var height = standardHeight
            
            // 3
            if item == featuredItemIndex {
                // 4
                let yOffset = standardHeight * nextItemPercentageOffset
                y = contentOffsetY - yOffset
                height = featuredHeight
            } else if item == (featuredItemIndex + 1) && item != numberOfItems {
                // 5
                let maxY = y + standardHeight
                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                y = maxY - height
            }
            
            // 6
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            y = frame.maxY
        }
    }
    
    /* Return all attributes in the cache whose frame intersects with the rect passed to the method */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        guard let firstMatchIndex = binarySearchAttributes(range: 0...cache.endIndex, rect: rect) else {
            return attributesArr
        }

        for attributes in cache[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArr.insert(attributes, at: 0)
        }

        for attributes in cache[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArr.append(attributes)
        }
        return attributesArr
    }
    
    private func binarySearchAttributes(range: CountableClosedRange<Int>, rect: CGRect) -> Int? {
        var lowerBound = 0
        var upperBound = range.count - 1
        while lowerBound < upperBound {
            let midIndex = lowerBound + (upperBound - lowerBound) / 2
            if cache[midIndex].frame.intersects(rect) {
                return midIndex
            } else if cache[midIndex].frame.maxY < rect.minY {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return nil
    }
    
    /* Return true so that the layout is continuously invalidated as the user scrolls */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = itemIndex * dragOffset
        return CGPoint(x: 0, y: yOffset)
    }
}

extension CGRect {
    func isRectIntersect(_ b: CGRect) -> Bool {
        let centerX1 = b.midX
        let centerY1 = b.midY
        let centerX2 = midX
        let centerY2 = midY
        return (abs(centerX1 - centerX2) <= (b.width + width) / 2) && (abs(centerY1 - centerY2) <= (b.height + height) / 2)
    }
}
