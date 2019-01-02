//
//  CHTCollectionViewWaterfallLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/2.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

@objc public protocol CHTCollectionViewDelegateWaterfallLayout: UICollectionViewDelegate {
    
    func collectionView (_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    
    @objc optional func collectionView (_ collectionView: UICollectionView,
                                        layout collectionViewLayout: UICollectionViewLayout,
                                        heightForHeaderInSection section: Int) -> CGFloat
    
    @objc optional func collectionView (_ collectionView: UICollectionView,
                                        layout collectionViewLayout: UICollectionViewLayout,
                                        heightForFooterInSection section: Int) -> CGFloat
    
    @objc optional func collectionView (_ collectionView: UICollectionView,
                                        layout collectionViewLayout: UICollectionViewLayout,
                                        insetForSectionAtIndex section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView (_ collectionView: UICollectionView,
                                        layout collectionViewLayout: UICollectionViewLayout,
                                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    
    @objc optional func collectionView (_ collectionView: UICollectionView,
                                        layout collectionViewLayout: UICollectionViewLayout,
                                        columnCountForSection section: Int) -> Int
}

public enum CHTCollectionViewWaterfallLayoutItemRenderDirection: Int {
    case shortestFirst
    case leftToRight
    case rightToLeft
}

public let CHTCollectionElementKindSectionHeader = "CHTCollectionElementKindSectionHeader"
public let CHTCollectionElementKindSectionFooter = "CHTCollectionElementKindSectionFooter"


public class CHTCollectionViewWaterfallLayout: UICollectionViewLayout {
    public var columnCount: Int = 2 {
        didSet {
            invalidateLayout()
        }}
    
    public var minimumColumnSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }
    
    public var minimumInteritemSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }
    
    public var headerHeight: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }
    
    public var footerHeight: CGFloat = 0 {
        didSet {
            invalidateLayout()
        }
    }
    
    public var sectionInset: UIEdgeInsets = .zero {
        didSet {
            invalidateLayout()
        }
    }
    
    
    public var itemRenderDirection: CHTCollectionViewWaterfallLayoutItemRenderDirection = .shortestFirst {
        didSet {
            invalidateLayout()
        }
    }
    
    
    //    private property and method above.
    public weak var delegate: CHTCollectionViewDelegateWaterfallLayout? {
        return self.collectionView!.delegate as? CHTCollectionViewDelegateWaterfallLayout
    }
    public var columnHeights: [[CGFloat]] = []
    public var sectionItemAttributes: [[UICollectionViewLayoutAttributes]] = []
    public var allItemAttributes: [UICollectionViewLayoutAttributes] = []
    public var headersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    public var footersAttributes: [Int: UICollectionViewLayoutAttributes] = [:]
    public var unionRects: [CGRect] = []
    public let unionSize = 20
    
    public func columnCountForSection (_ section: Int) -> Int {
        if let columnCount = self.delegate?.collectionView?(self.collectionView!, layout: self, columnCountForSection: section) {
            return columnCount
        } else {
            return self.columnCount
        }
    }
    
    public func itemWidthInSectionAtIndex (_ section: Int) -> CGFloat {
        var insets: UIEdgeInsets
        if let sectionInsets = self.delegate?.collectionView?(self.collectionView!, layout: self, insetForSectionAtIndex: section) {
            insets = sectionInsets
        } else {
            insets = self.sectionInset
        }
        let width: CGFloat = self.collectionView!.bounds.size.width - insets.left - insets.right
        let columnCount = self.columnCountForSection(section)
        let spaceColumCount: CGFloat = CGFloat(columnCount - 1)
        return floor((width - (spaceColumCount * self.minimumColumnSpacing)) / CGFloat(columnCount))
    }
    
    override public func prepare() {
        super.prepare()
        
        let numberOfSections = self.collectionView!.numberOfSections
        if numberOfSections == 0 {
            return
        }
        
        headersAttributes = [:]
        footersAttributes = [:]
        unionRects = []
        columnHeights = []
        allItemAttributes = []
        sectionItemAttributes = []
        
        for section in 0 ..< numberOfSections {
            let columnCount = columnCountForSection(section)
            var sectionColumnHeights: [CGFloat] = []
            for idx in 0 ..< columnCount {
                sectionColumnHeights.append(CGFloat(idx))
            }
            self.columnHeights.append(sectionColumnHeights)
        }
        
        var top: CGFloat = 0.0
        var attributes = UICollectionViewLayoutAttributes()
        
        for section in 0 ..< numberOfSections {
            /*
             * 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
             */
            var minimumInteritemSpacing: CGFloat
            if let miniumSpaceing = delegate?.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAtIndex: section) {
                minimumInteritemSpacing = miniumSpaceing
            } else {
                minimumInteritemSpacing = self.minimumColumnSpacing
            }
            
            var sectionInsets = self.sectionInset
            if let insets = delegate?.collectionView?(self.collectionView!, layout: self, insetForSectionAtIndex: section) {
                sectionInsets = insets
            }
            
            let width = collectionView!.bounds.width - sectionInsets.left - sectionInsets.right
            let columnCount = columnCountForSection(section)
            let spaceColumCount = CGFloat(columnCount - 1)
            let itemWidth = floor((width - (spaceColumCount * minimumColumnSpacing)) / CGFloat(columnCount))
            
            /*
             * 2. Section header
             */
            var heightHeader = self.headerHeight
            if let height = delegate?.collectionView?(collectionView!, layout: self, heightForHeaderInSection: section) {
                heightHeader = height
            }
            
            if heightHeader > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CHTCollectionElementKindSectionHeader, with: IndexPath(row: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: collectionView!.bounds.width, height: heightHeader)
                headersAttributes[section] = attributes
                allItemAttributes.append(attributes)
                
                top = attributes.frame.maxY
            }
            top += sectionInsets.top
            for idx in 0 ..< columnCount {
                columnHeights[section][idx]=top
            }
            
            /*
             * 3. Section items
             */
            let itemCount = collectionView!.numberOfItems(inSection: section)
            var itemAttributes: [UICollectionViewLayoutAttributes] = []
            
            // Item will be put into shortest column.
            for idx in 0 ..< itemCount {
                let indexPath = IndexPath(item: idx, section: section)
                
                let columnIndex = nextColumnIndexForItem(idx, section: section)
                let xOffset = sectionInsets.left + (itemWidth + minimumColumnSpacing) * CGFloat(columnIndex)

                let yOffset = columnHeights[section][columnIndex]
                let itemSize = delegate?.collectionView(self.collectionView!, layout: self, sizeForItemAtIndexPath: indexPath) ?? .zero
                var itemHeight: CGFloat = 0.0
                if itemSize.height > 0 && itemSize.width > 0 {
                    itemHeight = floor(itemSize.height * itemWidth / itemSize.width)
                }
                
                attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                allItemAttributes.append(attributes)
                
                columnHeights[section][columnIndex] = attributes.frame.maxY + minimumInteritemSpacing
                
            }
            self.sectionItemAttributes.append(itemAttributes)
            
            /*
             * 4. Section footer
             */
            var footerHeight = self.footerHeight
            let columnIndex  = longestColumnIndexInSection(section)
            top = columnHeights[section][columnIndex] - minimumInteritemSpacing + sectionInsets.bottom
            
            if let height = delegate?.collectionView?(collectionView!, layout: self, heightForFooterInSection: section) {
                footerHeight = height
            }
            
            if footerHeight > 0 {
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CHTCollectionElementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: collectionView!.bounds.size.width, height: footerHeight)
                footersAttributes[section] = attributes
                allItemAttributes.append(attributes)
                top = attributes.frame.maxY
            }
            
            for idx in 0 ..< columnCount {
                columnHeights[section][idx] = top
            }
        }
        
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
    
    override public var collectionViewContentSize: CGSize {
        let numberOfSections = collectionView!.numberOfSections
        if numberOfSections == 0 {
            return CGSize.zero
        }
        
        var contentSize = collectionView!.bounds.size
        
        if columnHeights.count > 0 {
            if let height = columnHeights[columnHeights.count - 1].first {
                contentSize.height = height
                return contentSize
            }
        }
        return CGSize.zero
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section >= sectionItemAttributes.count {
            return nil
        }
        let list = sectionItemAttributes[indexPath.section]
        if indexPath.item >= list.count {
            return nil
        }
        return list[indexPath.item]
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        var attribute: UICollectionViewLayoutAttributes?
        if elementKind == CHTCollectionElementKindSectionHeader {
            attribute = headersAttributes[indexPath.section]
        } else if elementKind == CHTCollectionElementKindSectionFooter {
            attribute = footersAttributes[indexPath.section]
        }
        guard let returnAttribute = attribute else {
            return UICollectionViewLayoutAttributes()
        }
        return returnAttribute
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var begin = 0, end = unionRects.count
        var attrs: [UICollectionViewLayoutAttributes] = []
        
        for i in 0 ..< end {
            let unionRect = unionRects[i]
            if rect.intersects(unionRect) {
                begin = i * unionSize
                break
            }
        }
        for i in (0 ..< unionRects.count).reversed() {
            let unionRect = unionRects[i]
            if rect.intersects(unionRect) {
                end = min((i + 1) * unionSize, allItemAttributes.count)
                break
            }
        }
        for i in begin ..< end {
            let attr = allItemAttributes[i]
            if rect.intersects(attr.frame) {
                attrs.append(attr)
            }
        }
        return attrs
    }
    
    override public func shouldInvalidateLayout (forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = collectionView!.bounds
        if newBounds.width != oldBounds.width {
            return true
        }
        return false
    }
    
    
    /**
     *  Find the shortest column.
     *
     *  @return index for the shortest column
     */
    public func shortestColumnIndexInSection (_ section: Int) -> Int {
        var index = 0
        var shorestHeight = CGFloat.greatestFiniteMagnitude
        for (idx, height) in columnHeights[section].enumerated() {
            if height < shorestHeight {
                shorestHeight = height
                index = idx
            }
        }
        return index
    }
    
    /**
     *  Find the longest column.
     *
     *  @return index for the longest column
     */
    
    public func longestColumnIndexInSection (_ section: Int) -> Int {
        var index = 0
        var longestHeight: CGFloat = 0.0
        
        for (idx, height) in columnHeights[section].enumerated() {
            if height > longestHeight {
                longestHeight = height
                index = idx
            }
        }
        return index
        
    }
    
    /**
     *  Find the index for the next column.
     *
     *  @return index for the next column
     */
    public func nextColumnIndexForItem (_ item: Int, section: Int) -> Int {
        var index = 0
        let columnCount = columnCountForSection(section)
        switch itemRenderDirection {
        case .shortestFirst:
            index = shortestColumnIndexInSection(section)
        case .leftToRight:
            index = (item%columnCount)
        case .rightToLeft:
            index = (columnCount - 1) - (item % columnCount)
        }
        return index
    }
}
