//
//  GridLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/28.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//


@objc
public protocol GridLayoutDelegate: NSObjectProtocol {
    /**
     Asks the delegate for the margins to apply to content in the specified section.
     
     @param collectionView       The collection view object displaying the grid layout.
     @param collectionViewLayout The layout object requesting the information.
     @param section              The index number of the section whose insets are needed.
     
     @return The margins to apply to items in the section.
     
     @discussion The return value of this method is applied to it's desired section in the same way as UICollectionViewFlowLayout uses it (applies it to section items only, not headers and footers).
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets

    /**
     Asks the delegate for the amount of spacing between lines that the given section should have.
     
     @param collectionView       The collection view object displaying the grid layout.
     @param collectionViewLayout The layout object requesting the information.
     @param section              The index number of the section whose line spacing is needed.
     
     @return The line spacing the layout should use between lines of cells in the section at the given index.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, lineSpacingForSectionAt section: Int) -> CGFloat

    /**
     Asks the delegate for the amount of spacing between cells on the sanme line that the given section should have.
     
     @param collectionView       The collection view object displaying the grid layout.
     @param collectionViewLayout The layout object requesting the information.
     @param section              The index number of the section whose inter-item spacing is needed.
     
     @return The inter-item spacing the layout should use between cells on the same line in the section at the given index
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, interitemSpacingForSectionAt section: Int) -> CGFloat

    /**
     Asks the delegate for the number of columns the given section should have.
     
     @param collectionView       The collection view object displaying the grid layout.
     @param collectionViewLayout The layout object requesting the information.
     @param section              The index number of the section whose column count is needed
     
     @return The number of columns the layout should use for the section at the given index.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, numberItemsPerLineForSectionAt section: Int) -> Int

    /**
     Asks the delegate for the aspect ratio that items in the given section should have
     
     @param collectionView       The collection view object displaying the grid layout.
     @param collectionViewLayout The layout object requesting the information.
     @param section              The index number of the section whose item aspect ratio is needed
     
     @return The aspect ratio the layout should use for items in the section at the given index.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, aspectRatioForItemsInSectionAt section: Int) -> CGFloat
    
    /**
     Asks the delegate for the length of the header in the given section.
     
     @param collectionView       The collection view object displaying the grid layout.
     @param collectionViewLayout The layout object requesting the information.
     @param section              The index number of the section whose header length is needed.
     
     @return The length of the header for the section at the given index. A length of 0 prevents the header from being created.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceLengthForHeaderIn section: Int) -> CGFloat
    
    /**
     Asks the delegate for the length of the footer in the given section.
     
     @param collectionView       The collection view object displaying the grid layout.
     @param collectionViewLayout The layout object requesting the information.
     @param section              The index number of the section whose footer length is needed.
     
     @return The length of the footer for the section at the given index. A length of 0 prevents the header from being created.
     */
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceLengthForFooterIn section: Int) -> CGFloat
}

class GridLayout: UICollectionViewLayout {

    /**
     Controls whether or not the user scrolls vertically or horizontally.
     If vertical, cells lay out left to right and new lines lay out below.
     If horizontal, cells lay out top to bottom and new lines lay out to the right.
     Defaults to vertical.
     */
    @IBInspectable
    public var scrollDirection: UICollectionViewScrollDirection = .vertical {
        didSet {
            invalidateLayout()
        }
    }

    /**
     If specified, each section will have a border around it defined by these insets.
     Defaults to UIEdgeInsetsZero.
     */
    @IBInspectable
    public var sectionInset: UIEdgeInsets = .zero {
        didSet {
            invalidateLayout()
        }
    }

    /**
     How much space the layout should place between items on the same line.
     Defaults to 10.
     */
    @IBInspectable
    public var interitemSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }

    /**
     How much space the layout should place between lines.
     Defaults to 10.
     */
    @IBInspectable
    public var lineSpacing: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }

    /**
     How many items the layout should place on a single line.
     Defaults to 10.
     */
    @IBInspectable
    public var numberOfItemsPerLine = 10 {
        didSet {
            invalidateLayout()
        }
    }

    /**
     The ratio of every item's width to its height (regardless of scroll direction).
     Defaults to 1 (square).
     */
    @IBInspectable
    public var aspectRatio: CGFloat = 1 {
        didSet {
            invalidateLayout()
        }
    }

    /**
     The length of a header for all sections. Defaults to 0.
     If scrollDirection is vertical, this length represents the height. If scrollDirection is horizontal, this length represents the width.
     If the length is zero, no header is created.
     */
    @IBInspectable
    public var headerReferenceLength: CGFloat = 0

    /**
     The length of a footer for all sections. Defaults to 0.
     If scrollDirection is vertical, this length represents the height. If scrollDirection is horizontal, this length represents the width.
     If the length is zero, no footer is created.
     */
    @IBInspectable
    public var footerReferenceLength: CGFloat = 0
    
    
    private var collectionViewContentLength: CGFloat = 0
    
    private var cellAttributesBySection: [[UICollectionViewLayoutAttributes]] = []
    private var supplementaryAttributes: [String: [IndexPath: UICollectionViewLayoutAttributes]] = [:]
    
    private var numberOfSections: Int {
        return collectionView?.numberOfSections ?? 0
    }

    override func prepare() {
        calculateContentSize()
        calculateLayoutAttributes()
    }
    
    override var collectionViewContentSize: CGSize {
        if scrollDirection == .vertical {
            return CGSize(width: collectionView!.bounds.width, height: collectionViewContentLength)
        } else {
            return CGSize(width: collectionViewContentLength, height: collectionView!.bounds.height)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributes: [UICollectionViewLayoutAttributes] = []
        for sectionAttributes in cellAttributesBySection {
            for attributes in sectionAttributes where rect.intersects(attributes.frame) {
                visibleAttributes.append(attributes)
            }
        }

        for attributesDict in supplementaryAttributes {
            for attribute in attributesDict.value.values where rect.intersects(attribute.frame) {
                visibleAttributes.append(attribute)
            }
        }

        return visibleAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributesBySection[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return supplementaryAttributes[elementKind]?[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.size != collectionView!.bounds.size
    }

    private func calculateContentSize() {
        var contentLength: CGFloat = 0

        guard let sections = collectionView?.numberOfSections else { return }

        for section in 0 ..< sections {
            contentLength += self.contentLength(for: section)
        }

        collectionViewContentLength = contentLength
    }
    
    private func contentLength(for section: Int) -> CGFloat {
        let rowsInSection = CGFloat(rows(in: section))

        var contentLength = (rowsInSection - 1) * lineSpacing(for: section)
        contentLength += lengthwiseInsetLength(in: section)

        let cellSize = self.cellSize(in: section)
        if scrollDirection == .vertical {
            contentLength += rowsInSection * cellSize.height
        } else {
            contentLength += rowsInSection * cellSize.width
        }

        contentLength += headerLength(for: section)
        contentLength += footerLength(for: section)

        return contentLength
    }
    
    private func rows(in section: Int) -> Int {
        guard let itemsInSection = collectionView?.numberOfItems(inSection: section) else {
            return 0
        }

        let numberOfItemsPerLine = self.numberOfItemsPerLine(for: section)
        let rowsInSection = itemsInSection / numberOfItemsPerLine + (itemsInSection % numberOfItemsPerLine > 0 ? 1 : 0)
        return rowsInSection
    }
    
    private func lengthwiseInsetLength(in section: Int) -> CGFloat {
        let sectionInset = self.sectionInset(for: section)
        if scrollDirection == .vertical {
            return sectionInset.veticalValue
        } else {
            return sectionInset.horizontalValue
        }
    }

    private func headerAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let section = indexPath.section
        let headerReferenceLength = headerLength(for: section)
        if headerReferenceLength == 0 {
            return nil
        }

        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)

        var frame: CGRect = .zero
        
        if scrollDirection == .vertical {
            frame.size.width = collectionViewContentSize.width
            frame.size.height = headerReferenceLength
            frame.origin.x = 0
            frame.origin.y = start(of: section)
        } else {
            frame.size.width = headerReferenceLength
            frame.size.height = collectionViewContentSize.height
            frame.origin.x = start(of: section)
            frame.origin.y = 0
        }

        attributes.frame = frame
        return attributes
    }
    
    private func footerAttributes(for indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let section = indexPath.section
        let footerReferenceLength = footerLength(for: section)
        if footerReferenceLength == 0 {
            return nil
        }
        
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
        
        var frame: CGRect = .zero
        
        
        
        let sectionStart = self.start(of: section)
        let sectionLength = self.contentLength(for: section)
        
        var footerStart = sectionStart + sectionLength
        if footerReferenceLength > 0 {
            footerStart -= footerReferenceLength
        }
        
        if scrollDirection == .vertical {
            frame.size.width = collectionViewContentSize.width
            frame.size.height = footerReferenceLength
            frame.origin.x = 0
            frame.origin.y = footerStart
        } else {
            frame.size.width = footerReferenceLength
            frame.size.height = collectionViewContentSize.height
            frame.origin.x = footerStart
            frame.origin.y = 0
        }
        
        attributes.frame = frame
        
        return attributes
    }
    
    private func calculateLayoutAttributes() {
        cellAttributesBySection.removeAll(keepingCapacity: true)
        
        supplementaryAttributes[UICollectionElementKindSectionHeader] = [:]
        supplementaryAttributes[UICollectionElementKindSectionFooter] = [:]
        
        for section in  0 ..< numberOfSections {
            
            let headerFooterPath = IndexPath(row: 0, section: section)

            if let headerAttributes = self.headerAttributes(for: headerFooterPath) {
                supplementaryAttributes[UICollectionElementKindSectionHeader]?[headerFooterPath] = headerAttributes
            }
            
            cellAttributesBySection.append(layoutAttributesForItems(in: section))

            if let footerAttributes = footerAttributes(for: headerFooterPath) {
                supplementaryAttributes[UICollectionElementKindSectionFooter]?[headerFooterPath] = footerAttributes
            }
        }
    }

    private func numberOfItemsPerLine(for section: Int) -> Int {
        if let delegate = collectionView?.delegate as? GridLayoutDelegate {
            return delegate.collectionView?(collectionView!, layout: self, numberItemsPerLineForSectionAt: section) ?? numberOfItemsPerLine
        } else {
            return numberOfItemsPerLine
        }
    }
    
    private func lineSpacing(for section: Int) -> CGFloat {
        if let delegate = collectionView?.delegate as? GridLayoutDelegate {
            return delegate.collectionView?(collectionView!, layout: self, lineSpacingForSectionAt: section) ?? lineSpacing
        } else {
            return lineSpacing
        }
    }

    private func sectionInset(for section: Int) -> UIEdgeInsets {
        if let delegate = collectionView?.delegate as? GridLayoutDelegate {
            return delegate.collectionView?(collectionView!, layout: self, insetForSectionAt: section) ?? sectionInset
        } else {
            return sectionInset
        }
    }
    
    private func cellSize(in section: Int) -> CGSize {

        let usableSpace = self.usableSpace(in: section)
        let cellLength = usableSpace / CGFloat(numberOfItemsPerLine(for: section))
        let aspectRatio = self.aspectRatio(for: section)

        if scrollDirection == .vertical {
            return CGSize(width: cellLength,
                          height: cellLength * (1.0 / aspectRatio))
        } else {
            return CGSize(width: cellLength * aspectRatio,
                          height: cellLength)
        }
    }

    private func headerLength(for section: Int) -> CGFloat {
        if let delegate = collectionView?.delegate as? GridLayoutDelegate {
            return delegate.collectionView?(collectionView!, layout: self, referenceLengthForHeaderIn: section) ?? headerReferenceLength
        } else {
            return headerReferenceLength
        }
    }

    private func footerLength(for section: Int) -> CGFloat {
        if let delegate = collectionView?.delegate as? GridLayoutDelegate {
            return delegate.collectionView?(collectionView!, layout: self, referenceLengthForFooterIn: section) ?? footerReferenceLength
        } else {
            return footerReferenceLength
        }
    }
    
    private func layoutAttributesForItems(in section: Int) -> [UICollectionViewLayoutAttributes] {
        return (0 ..< collectionView!.numberOfItems(inSection: section)).map {
            layoutAttributesForCell(at: IndexPath(row: $0, section: section))
        }
    }
    
    private func usableSpace(in section: Int) -> CGFloat {
        let sectionInset = self.sectionInset(for: section)
        let interitemSpacing = self.interitemSpacing(for: section)
        let numberOfItemsPerLine = self.numberOfItemsPerLine(for: section)

        if scrollDirection == .vertical {
            return (collectionViewContentSize.width
                - sectionInset.horizontalValue
                - (CGFloat(numberOfItemsPerLine - 1) * interitemSpacing))
        } else {
            return (collectionViewContentSize.height
                - sectionInset.veticalValue
                - (CGFloat(numberOfItemsPerLine - 1) * interitemSpacing))
        }
    }
    
    private func interitemSpacing(for section: Int) -> CGFloat {
        if let delegate = collectionView?.delegate as? GridLayoutDelegate {
            return delegate.collectionView?(collectionView!, layout: self, interitemSpacingForSectionAt: section) ?? interitemSpacing
        } else {
            return interitemSpacing
        }
    }
    
    private func aspectRatio(for section: Int) -> CGFloat {
        if let delegate = collectionView?.delegate as? GridLayoutDelegate {
            return delegate.collectionView?(collectionView!, layout: self, aspectRatioForItemsInSectionAt: section) ?? aspectRatio
        } else {
            return aspectRatio
        }
    }

    private func start(of section: Int) -> CGFloat {
        var startOfSection: CGFloat = 0
        for currentSection in 0 ..< section {
            startOfSection += contentLength(for: currentSection)
        }
        return startOfSection
    }

    private func layoutAttributesForCell(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        attributes.frame = frameForItem(at: indexPath)

        return attributes
    }
    
    private func frameForItem(at indexPath: IndexPath) -> CGRect {
        
        let section = indexPath.section
        
        let cellSize = self.cellSize(in: section)
        
        let numberOfItemsPerLine = CGFloat(self.numberOfItemsPerLine(for: section))
        let rowOfItem = CGFloat(indexPath.row / Int(numberOfItemsPerLine))
        let locationInRowOfItem = CGFloat(indexPath.row).truncatingRemainder(dividingBy: numberOfItemsPerLine)

        var frame: CGRect = .zero

        var sectionStart = start(of: section)
        let headerReferenceLength = headerLength(for: section)
        if headerReferenceLength > 0 {
            sectionStart += headerReferenceLength
        }

        let sectionInset = self.sectionInset(for: section)
        let lineSpacing = self.lineSpacing(for: section)
        let interitemSpacing = self.interitemSpacing(for: section)

        if scrollDirection == .vertical {
            frame.origin.x = sectionInset.left + (locationInRowOfItem * cellSize.width) + (interitemSpacing * locationInRowOfItem)
            frame.origin.y = sectionStart + sectionInset.top + rowOfItem * (cellSize.height + lineSpacing)
        } else {
            frame.origin.x = sectionStart + sectionInset.left + (cellSize.width + lineSpacing) * rowOfItem
            frame.origin.y = sectionInset.top + (locationInRowOfItem * cellSize.height) + (interitemSpacing * locationInRowOfItem)
        }
        frame.size = cellSize
        
        return frame
    }
}

extension UIEdgeInsets {
    var veticalValue: CGFloat {
        return top + bottom
    }
    
    var horizontalValue: CGFloat {
        return left + right
    }
}
