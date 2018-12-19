//
//  CSStickyHeaderFlowLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/7/21.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

let CSStickyHeaderParallaxHeader = "CSStickyHeaderParallexHeader"

class CSStickyHeaderFlowLayout: UICollectionViewFlowLayout {
    
    static let kHeaderZIndex = 1024
    
    var parallaxHeaderReferenceSize: CGSize = .zero {
        didSet {
            invalidateLayout()
        }
    }
    var parallaxHeaderMinimumReferenceSize: CGSize = .zero
    var parallaxHeaderAlwaysOnTop = false
    var disableStickyHeaders = false
    var disableStretching = false

    override func prepare() {
        super.prepare()
    }
    
    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
        
        if elementKind == CSStickyHeaderParallaxHeader {
            // sticky header do not need to offset
            return nil
        } else {
            // offset others

            attributes?.frame.origin.y += parallaxHeaderReferenceSize.height
        }
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == CSStickyHeaderParallaxHeader {
             let attribute = layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath) as? CSStickyHeaderFlowLayoutAttributes
            
            updateParallaxHeaderAttribute(attribute)
            return attribute
        } else {
            return super.finalLayoutAttributesForDisappearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        if attributes == nil && elementKind == CSStickyHeaderParallaxHeader {
            attributes = CSStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        }
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard collectionView?.dataSource != nil else {
            return nil
        }
        // The rect should compensate the header size
        var adjustedRect = rect
        adjustedRect.origin.y -= parallaxHeaderReferenceSize.height
        
        print(adjustedRect)
        
        var allItems: [UICollectionViewLayoutAttributes] = []
        if let originalAttributes = super.layoutAttributesForElements(in: adjustedRect) {
            allItems = originalAttributes.compactMap { $0.copy() as? UICollectionViewLayoutAttributes }
        }
        
        var headers: [Int: UICollectionViewLayoutAttributes] = [:]
        var lastCells: [Int: UICollectionViewLayoutAttributes] = [:]
        
        var visibleParallexHeader = false
        
        for obj in allItems {

            obj.frame.origin.y += parallaxHeaderReferenceSize.height
            
            let indexPath = obj.indexPath

            let isHeader = obj.representedElementKind == UICollectionView.elementKindSectionHeader
            let isFooter = obj.representedElementKind == UICollectionView.elementKindSectionFooter
            
            if isHeader {
                headers[indexPath.section] = obj
            } else if isFooter {
                // Not implemeneted
            } else {

                let currentAttribute = lastCells[indexPath.section]
                
                // Get the bottom most cell of that section
                if currentAttribute == nil || (indexPath.row > currentAttribute!.indexPath.row && indexPath.section == currentAttribute!.indexPath.section) {
                    lastCells[indexPath.section] = obj
                }
                
                if indexPath == IndexPath(item: 0, section: 0) {
                    visibleParallexHeader = true
                }
            }
            
            if isHeader {
                obj.zIndex = CSStickyHeaderFlowLayout.kHeaderZIndex
            } else {
                // For iOS 7.0, the cell zIndex should be above sticky section header
                obj.zIndex = 1
            }
        }
        
        // when the visible rect is at top of the screen, make sure we see
        // the parallex header
        if rect.minY <= 0 {
            visibleParallexHeader = true
        }
        
        if parallaxHeaderAlwaysOnTop {
            visibleParallexHeader = true
        }
        
        
        // This method may not be explicitly defined, default to 1
        // https://developer.apple.com/library/ios/documentation/uikit/reference/UICollectionViewDataSource_protocol/Reference/Reference.html#jumpTo_6
        //    NSUInteger numberOfSections = [self.collectionView.dataSource
        //                                   respondsToSelector:@selector(numberOfSectionsInCollectionView:)]
        //                                ? [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView]
        //                                : 1
        
        // Create the attributes for the Parallex header
        if visibleParallexHeader && parallaxHeaderReferenceSize != .zero {

            let currentAttribute = CSStickyHeaderFlowLayoutAttributes(forSupplementaryViewOfKind: CSStickyHeaderParallaxHeader, with: IndexPath(index: 0))
            updateParallaxHeaderAttribute(currentAttribute)
            print(currentAttribute.frame)
            allItems.append(currentAttribute)
        }
        
        if !disableStickyHeaders {
            for element in lastCells {
                let indexPath = element.value.indexPath
                let indexPathKey = indexPath.section
                
                var header = headers[indexPathKey]
                // CollectionView automatically removes headers not in bounds
                if header == nil && visibleParallexHeader {

                    header = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPathKey))

                    if header!.frame.size != .zero {
                        allItems.append(header!)
                    }
                }
                if header != nil && header!.frame.size != .zero {
                    updateHeaderAttributes(header!, lastCellAttributes: lastCells[indexPathKey])
                }
            }
        }
        
        return allItems
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
        attributes?.frame.origin.y += parallaxHeaderReferenceSize.height
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        if collectionView?.superview == nil {
            return CGSize.zero
        }
        var size = super.collectionViewContentSize
        size.height += parallaxHeaderReferenceSize.height
        return size
    }
    
    override class var layoutAttributesClass: AnyClass {
        return CSStickyHeaderFlowLayoutAttributes.self
    }

    private func updateHeaderAttributes(_ attributes: UICollectionViewLayoutAttributes, lastCellAttributes: UICollectionViewLayoutAttributes?) {
        let currentBounds = collectionView?.bounds ?? .zero
        
        guard let lastCellAttributes = lastCellAttributes else { return }
        
        attributes.zIndex = CSStickyHeaderFlowLayout.kHeaderZIndex
        attributes.isHidden = false
        
        let sectionMaxY = lastCellAttributes.frame.maxY - attributes.frame.height
        var y = currentBounds.maxY - currentBounds.size.height + collectionView!.contentInset.top

        if parallaxHeaderAlwaysOnTop {
            y += parallaxHeaderMinimumReferenceSize.height
        }
        
        let maxY = min(max(y, attributes.frame.minY), sectionMaxY)

        attributes.frame.origin.y = maxY
    }
    
    private func updateParallaxHeaderAttribute(_ currentAttribute: CSStickyHeaderFlowLayoutAttributes?) {
        
        guard let collectionView = collectionView else { return }
        
        currentAttribute?.frame.size.width = parallaxHeaderReferenceSize.width
        currentAttribute?.frame.size.height = parallaxHeaderReferenceSize.height

        let bounds = collectionView.bounds
        let maxY = currentAttribute?.frame.maxY ?? 0
        
        let insetTop = collectionView.contentInset.top
        
        // make sure the frame won't be negative values
        var y = min(maxY - parallaxHeaderMinimumReferenceSize.height, bounds.minY + insetTop)
        let height = max(0, -y + maxY)
        
        
        let maxHeight = parallaxHeaderReferenceSize.height
        let minHeight = parallaxHeaderMinimumReferenceSize.height
        let progressiveness = (height - minHeight) / (maxHeight - minHeight)
        currentAttribute?.progressiveness = progressiveness
        
        // if zIndex < 0 would prevents tap from recognized right under navigation bar
        currentAttribute?.zIndex = 0
        
        // When parallaxHeaderAlwaysOnTop is enabled, we will check when we should update the y position
        if parallaxHeaderAlwaysOnTop && height <= parallaxHeaderMinimumReferenceSize.height {
            
            // Always stick to top but under the nav bar
            y = collectionView.contentOffset.y + insetTop
            currentAttribute?.zIndex = 2000
        }

        currentAttribute?.frame.origin.y = y
        currentAttribute?.frame.size.height = disableStretching && height > maxHeight ? maxHeight : height
    }
}
