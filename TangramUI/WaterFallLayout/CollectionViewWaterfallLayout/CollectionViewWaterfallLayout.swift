//
//  CollectionViewWaterfallLayout.swift
//  CollectionViewWaterfallLayout
//
//  Created by Eric Cerney on 7/21/14.
//  Based on CHTCollectionViewWaterfallLayout by Nelson Tai
//  Copyright (c) 2014 Eric Cerney. All rights reserved.
//

public let CollectionViewWaterfallElementKindSectionHeader = "CollectionViewWaterfallElementKindSectionHeader"
public let CollectionViewWaterfallElementKindSectionFooter = "CollectionViewWaterfallElementKindSectionFooter"

@objc public protocol CollectionViewWaterfallLayoutDelegate: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    @objc optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, heightForHeaderInSection section: Int) -> CGFloat
    
    @objc optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, heightForFooterInSection section: Int) -> CGFloat
    
    @objc optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSection section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, insetForHeaderInSection section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, insetForFooterInSection section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSection section: Int) -> CGFloat
    
}

public class CollectionViewWaterfallLayout: UICollectionViewLayout {
    
    //MARK: Private constants
    /// How many items to be union into a single rectangle
    private let unionSize = 20;
    
    //MARK: Public Properties
    public var columnCount: Int = 2 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: columnCount)
        }
    }
    public var minimumColumnSpacing: CGFloat = 10.0 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: minimumColumnSpacing)
        }
    }
    public var minimumInteritemSpacing: CGFloat = 10.0 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: minimumInteritemSpacing)
        }
    }
    public var headerHeight: CGFloat = 0.0 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: headerHeight)
        }
    }
    public var footerHeight: CGFloat = 0.0 {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: footerHeight)
        }
    }
    public var headerInset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: headerInset)
        }
    }
    public var footerInset:UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: footerInset)
        }
    }
    public var sectionInset:UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIfNotEqual(oldValue, newValue: sectionInset)
        }
    }
    
    //MARK: Private Properties
    private weak var delegate: CollectionViewWaterfallLayoutDelegate?  {
        get {
            return collectionView?.delegate as? CollectionViewWaterfallLayoutDelegate
        }
    }
    private var columnHeights = [CGFloat]()
    private var sectionItemAttributes = [[UICollectionViewLayoutAttributes]]()
    private var allItemAttributes = [UICollectionViewLayoutAttributes]()
    private var headersAttribute = [Int: UICollectionViewLayoutAttributes]()
    private var footersAttribute = [Int: UICollectionViewLayoutAttributes]()
    private var unionRects = [CGRect]()
    
    
    //MARK: UICollectionViewLayout Methods
    override public func prepare() {
        super.prepare()
        
        let numberOfSections = collectionView?.numberOfSections ?? 0
        
        if numberOfSections == 0 {
            return
        }
        
        assert(delegate!.conforms(to: CollectionViewWaterfallLayoutDelegate.self), "UICollectionView's delegate should conform to WaterfallLayoutDelegate protocol")
        assert(columnCount > 0, "WaterfallFlowLayout's columnCount should be greater than 0")
        
        // Initialize variables
        headersAttribute.removeAll(keepingCapacity: false)
        footersAttribute.removeAll(keepingCapacity: false)
        unionRects.removeAll(keepingCapacity: false)
        columnHeights.removeAll(keepingCapacity: false)
        allItemAttributes.removeAll(keepingCapacity: false)
        sectionItemAttributes.removeAll(keepingCapacity: false)
        
        for _ in 0 ..< columnCount {
            columnHeights.append(0)
        }
        
        // Create attributes
        var top: CGFloat = 0
        var attributes: UICollectionViewLayoutAttributes
        
        for section in 0 ..< numberOfSections {
            /*
            * 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
            */
            let minimumInteritemSpacing: CGFloat
            if let height = delegate?.collectionView?(collectionView: collectionView!, layout: self, minimumInteritemSpacingForSection: section) {
                minimumInteritemSpacing = height
            } else {
                minimumInteritemSpacing = self.minimumInteritemSpacing
            }
            
            let sectionInset: UIEdgeInsets
            if let inset = delegate?.collectionView?(collectionView: collectionView!, layout: self, insetForSection: section) {
                sectionInset = inset
            } else {
                sectionInset = self.sectionInset
            }
            
            let width = collectionView!.frame.width - sectionInset.left - sectionInset.right
            let itemWidth = floor((width - CGFloat(columnCount - 1) * minimumColumnSpacing) / CGFloat(columnCount))
            
            /*
            * 2. Section header
            */
            let headerHeight: CGFloat
            if let height = delegate?.collectionView?(collectionView: collectionView!, layout: self, heightForHeaderInSection: section) {
                headerHeight = height
            } else {
                headerHeight = self.headerHeight
            }
            
            let headerInset: UIEdgeInsets
            if let inset = delegate?.collectionView?(collectionView: collectionView!, layout: self, insetForHeaderInSection: section) {
                headerInset = inset
            } else {
                headerInset = self.headerInset
            }
            
            top += headerInset.top
            
            if headerHeight > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: headerInset.left, y: CGFloat(top), width: collectionView!.frame.width - (headerInset.left + headerInset.right), height: headerHeight)

                headersAttribute[section] = attributes
                allItemAttributes.append(attributes)
                
                top = attributes.frame.maxY + headerInset.bottom
            }
            
            top += sectionInset.top
            
            for idx in 0 ..< columnCount {
                columnHeights[idx] = top
            }
            
            
            /*
            * 3. Section items
            */
            let itemCount = collectionView!.numberOfItems(inSection: section)
            var itemAttributes = [UICollectionViewLayoutAttributes]()
            
            // Item will be put into shortest column.
            for idx in 0..<itemCount {
                let indexPath = IndexPath(row: idx, section: section)
                let columnIndex = shortestColumnIndex()
                
                let xOffset = sectionInset.left + (itemWidth + minimumColumnSpacing) * CGFloat(columnIndex)
                let yOffset = columnHeights[columnIndex]
                let itemSize = delegate?.collectionView(collectionView: collectionView!, layout: self, sizeForItemAt: indexPath) ?? .zero
                var itemHeight: CGFloat = 0.0
                if itemSize.height > 0 && itemSize.width > 0 {
                    itemHeight = itemSize.height * itemWidth / itemSize.width
                }

                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[columnIndex] = attributes.frame.maxY + minimumInteritemSpacing
            }
            
            sectionItemAttributes.append(itemAttributes)
            
            /*
            * 4. Section footer
            */
            var footerHeight: CGFloat
            let columnIndex = longestColumnIndex()
            top = columnHeights[columnIndex] - minimumInteritemSpacing + sectionInset.bottom

            if let height = delegate?.collectionView?(collectionView: collectionView!, layout: self, heightForFooterInSection: section) {
                footerHeight = height
            } else {
                footerHeight = self.footerHeight
            }
            
            var footerInset: UIEdgeInsets
            if let inset = delegate?.collectionView?(collectionView: collectionView!, layout: self, insetForFooterInSection: section) {
                footerInset = inset
            }
            else {
                footerInset = self.footerInset
            }
            
            top += footerInset.top
            
            if footerHeight > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: footerInset.left, y: top, width: collectionView!.frame.width - (footerInset.left + footerInset.right), height: footerHeight)
                
                footersAttribute[section] = attributes
                allItemAttributes.append(attributes)
                
                top = attributes.frame.maxY + footerInset.bottom
            }
            
            for idx in 0..<columnCount {
                columnHeights[idx] = top
            }
        }
        
        // Build union rects
        var idx = 0
        let itemCounts = allItemAttributes.count
        
        while idx < itemCounts {
            let rect1 = allItemAttributes[idx].frame
            idx = min(idx + unionSize, itemCounts) - 1
            let rect2 = allItemAttributes[idx].frame
            unionRects.append(rect1.union(rect2))
            idx += 1
        }
    }
    
    public override var collectionViewContentSize: CGSize {

        let numberOfSections = collectionView?.numberOfSections
        if numberOfSections == 0 {
            return CGSize.zero
        }
        
        var contentSize = collectionView?.bounds.size
        contentSize?.height = CGFloat(columnHeights[0])
        
        return contentSize!
    }
    
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= sectionItemAttributes.count {
            return nil
        }
        
        if indexPath.item >= sectionItemAttributes[indexPath.section].count {
            return nil
        }
        
        return sectionItemAttributes[indexPath.section][indexPath.item]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attribute: UICollectionViewLayoutAttributes?
        
        if elementKind == CollectionViewWaterfallElementKindSectionHeader {
            attribute = headersAttribute[indexPath.section]
        }
        else if elementKind == CollectionViewWaterfallElementKindSectionFooter {
            attribute = footersAttribute[indexPath.section]
        }
        
        return attribute
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var begin:Int = 0
        var end: Int = unionRects.count
        var attrs = [UICollectionViewLayoutAttributes]()
        
        for i in 0 ..< unionRects.count {
            if rect.intersects(unionRects[i]) {
                begin = i * unionSize
                break
            }
        }
        for i in (0..<unionRects.count).reversed() {
            if rect.intersects(unionRects[i]) {
                end = min((i+1) * unionSize, allItemAttributes.count)
                break
            }
        }
        for idx in begin ..< end {
            let attr = allItemAttributes[idx]
            if rect.intersects(attr.frame) {
                attrs.append(attr)
            }
        }
        
        return attrs
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds
        if newBounds.width != oldBounds?.width {
            return true
        }
        
        return false
    }
    
    //MARK: Private Methods
    private func shortestColumnIndex() -> Int {
        var index: Int = 0
        var shortestHeight = CGFloat.infinity
        
        for (idx, height) in columnHeights.enumerated() {
            if height < shortestHeight {
                shortestHeight = height
                index = idx
            }
        }
        
        return index
    }
    
    private func longestColumnIndex() -> Int {
        var index: Int = 0
        var longestHeight: CGFloat = 0

        for (idx, height) in columnHeights.enumerated() {
            if height > longestHeight {
                longestHeight = height
                index = idx
            }
        }

        return index
    }
    
    private func invalidateIfNotEqual<T: Equatable>(_ oldValue: T, newValue: T) {
        if oldValue != newValue {
            invalidateLayout()
        }
    }
}
