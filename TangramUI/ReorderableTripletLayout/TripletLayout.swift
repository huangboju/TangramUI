//
//  TripletLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/20.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

private let TripletLayoutStyleSquare = CGSize.zero

protocol TripletLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, sizeForLargeItemsIn section: Int) -> CGSize //Default to automaticaly grow square !

    func insets(for collectionView: UICollectionView) -> UIEdgeInsets

    func sectionSpacing(for collectionView: UICollectionView) -> CGFloat

    func minimumInteritemSpacing(for collectionView: UICollectionView) -> CGFloat

    func minimumLineSpacing(for collectionView: UICollectionView) -> CGFloat
}


extension TripletLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForLargeItemsIn section: Int) -> CGSize {
        return .zero
    }
    
    func insets(for collectionView: UICollectionView) -> UIEdgeInsets {
        return .zero
    }
    
    func sectionSpacing(for collectionView: UICollectionView) -> CGFloat {
        return 0
    }
    
    func minimumInteritemSpacing(for collectionView: UICollectionView) -> CGFloat {
        return 0
    }
    
    func minimumLineSpacing(for collectionView: UICollectionView) -> CGFloat {
        return 0
    }
}

protocol TripletLayoutDatasource: UICollectionViewDataSource {}

class TripletLayout: UICollectionViewLayout {
    public weak var delegate: TripletLayoutDelegate? {
        set {
            collectionView?.delegate = newValue
        }
        get {
            return collectionView?.delegate as? TripletLayoutDelegate
        }
    }

    public weak var datasource: TripletLayoutDatasource?
    
    public private(set)var largeCellSize: CGSize = .zero

    public private(set)var smallCellSize: CGSize = .zero

    public var contentHeight: CGFloat {
        
        guard let collectionView = collectionView else {
            return 0
        }
        
        var contentHeight: CGFloat = 0
        let numberOfSections = ceil(CGFloat(collectionView.numberOfSections))
        let collectionViewSize = collectionView.bounds.size

        let insets = delegate?.insets(for: collectionView) ?? .zero

        let sectionSpacing = delegate?.sectionSpacing(for: collectionView) ?? 0
        
        let itemSpacing = delegate?.minimumInteritemSpacing(for: collectionView) ?? 0

        let lineSpacing = delegate?.minimumLineSpacing(for: collectionView) ?? 0
        
        contentHeight += insets.top + insets.bottom + sectionSpacing * (numberOfSections - 1)

        var lastSmallCellHeight: CGFloat = 0
        for i in 0 ..< Int(numberOfSections) {

            let numberOfLines = ceil(CGFloat(collectionView.numberOfItems(inSection: i)) / 3)

            let largeCellSideLength = (2 * (collectionViewSize.width - insets.left - insets.right) - itemSpacing) / 3
            let smallCellSideLength = (largeCellSideLength - itemSpacing) / 2
            var largeCellSize = CGSize(width: largeCellSideLength, height: largeCellSideLength)
            var smallCellSize = CGSize(width: smallCellSideLength, height: smallCellSideLength)
            
            if let delegate = delegate {
                let size = delegate.collectionView(collectionView, sizeForLargeItemsIn: i)
                if size != TripletLayoutStyleSquare {
                    largeCellSize = size
                    smallCellSize = CGSize(width: collectionViewSize.width - largeCellSize.width - itemSpacing - insets.left - insets.right, height: (largeCellSize.height / 2) - (itemSpacing / 2))
                }
            }
            lastSmallCellHeight = smallCellSize.height
            let largeCellHeight = largeCellSize.height
            let lineHeight = numberOfLines * (largeCellHeight + lineSpacing) - lineSpacing
            contentHeight += lineHeight
        }

        let numberOfItemsInLastSection = collectionView.numberOfItems(inSection: Int(numberOfSections) - 1)
        if (numberOfItemsInLastSection - 1) % 3 == 0 && (numberOfItemsInLastSection - 1) % 6 != 0 {
            contentHeight -= lastSmallCellHeight + itemSpacing
        }
        
        return contentHeight
    }

    private var numberOfCells = 0
    
    private var numberOfLines: CGFloat = 0
    
    private var itemSpacing: CGFloat = 0
    
    private var lineSpacing: CGFloat = 0
    
    private var sectionSpacing: CGFloat = 0
    
    private var collectionViewSize: CGSize = .zero
    
    private var insets: UIEdgeInsets = .zero
    
    private var oldRect: CGRect = .zero
    
    private var oldAttributes: [UICollectionViewLayoutAttributes] = []
    
    private lazy var largeCellSizes: [CGSize] = []
    
    private lazy var smallCellSizes: [CGSize] = []
    
    override func prepare() {
        super.prepare()
        
        let sections = collectionView!.numberOfSections
        
        largeCellSizes = Array(repeating: .zero, count: sections)
        smallCellSizes = Array(repeating: .zero, count: sections)
        
        //collection view size
        collectionViewSize = collectionView?.bounds.size ?? .zero

        //some values
        
        guard let delegate = delegate, let collectionView = collectionView else {
            return
        }
        
        itemSpacing = delegate.minimumInteritemSpacing(for: collectionView)

        lineSpacing = delegate.minimumLineSpacing(for: collectionView)
        
        sectionSpacing = delegate.sectionSpacing(for: collectionView)
        
        insets = delegate.insets(for: collectionView)
    }
    
    override var collectionViewContentSize: CGSize {
        var contentSize = CGSize(width: collectionViewSize.width, height: 0)
        
        let sections = collectionView!.numberOfSections

        for i in 0 ..< sections {

            let numberOfLines = ceil(CGFloat(collectionView!.numberOfItems(inSection: i)) / 3)
            let lineHeight = numberOfLines * (largeCellSizes[i].height + lineSpacing) - lineSpacing
            contentSize.height += lineHeight
        }
        contentSize.height += insets.top + insets.bottom + sectionSpacing * CGFloat(sections - 1)

        let numberOfItemsInLastSection = collectionView!.numberOfItems(inSection: sections - 1)
        if (numberOfItemsInLastSection - 1) % 3 == 0 && (numberOfItemsInLastSection - 1) % 6 != 0 {
            contentSize.height -= smallCellSizes[sections - 1].height + itemSpacing
        }
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        oldRect = rect

        var attributes: [UICollectionViewLayoutAttributes] = []
        
        for section in 0 ..< collectionView!.numberOfSections {
            let rows = collectionView!.numberOfItems(inSection: section)
            for row in 0 ..< rows {
                let indexPath = IndexPath(row: row, section: section)

                guard let attribute = layoutAttributesForItem(at: indexPath) else {
                    continue
                }
                print(attribute)
                if rect.intersects(attribute.frame) {
                    attributes.append(attribute)
                }
            }
        }
        oldAttributes = attributes
        return  attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        //cellSize
        let largeCellSideLength = (2 * (collectionViewSize.width - insets.left - insets.right) - itemSpacing) / 3
        let smallCellSideLength = (largeCellSideLength - itemSpacing) / 2
        largeCellSize = CGSize(width: largeCellSideLength, height: largeCellSideLength)
        smallCellSize = CGSize(width: smallCellSideLength, height: smallCellSideLength)
        if let delegate = delegate {
            let size = delegate.collectionView(collectionView!, sizeForLargeItemsIn: indexPath.section)
            if size != TripletLayoutStyleSquare {
                largeCellSize = size
                smallCellSize = CGSize(width: collectionViewSize.width - largeCellSize.width - itemSpacing - insets.left - insets.right, height: (largeCellSize.height - itemSpacing) / 2)
            }
        }
        largeCellSizes[indexPath.section] = largeCellSize
        smallCellSizes[indexPath.section] = smallCellSize

        //section height
        var sectionHeight: CGFloat = 0
        
        for i in 0 ... max(0, indexPath.section - 1) where indexPath.section > 0 {
            let cellsCount = collectionView!.numberOfItems(inSection: i)
            let largeCellHeight = largeCellSizes[i].height
            let smallCellHeight = smallCellSizes[i].height
            let lines = ceil(CGFloat(cellsCount) / 3)
            sectionHeight += lines * (lineSpacing + largeCellHeight) + sectionSpacing
            if (cellsCount - 1) % 3 == 0 && (cellsCount - 1) % 6 != 0 {
                sectionHeight -= smallCellHeight + itemSpacing
            }
        }

        if sectionHeight > 0 {
            sectionHeight -= lineSpacing
        }
    
        let line = CGFloat(indexPath.item / 3)
        let lineSpaceForIndexPath = lineSpacing * line
        let lineOriginY = largeCellSize.height * line + sectionHeight + lineSpaceForIndexPath + insets.top
        let rightSideLargeCellOriginX = collectionViewSize.width - largeCellSize.width - insets.right
        let rightSideSmallCellOriginX = collectionViewSize.width - smallCellSize.width - insets.right

        
        let rect: CGRect
        
        if indexPath.item % 6 == 0 {
            rect = CGRect(x: insets.left, y: lineOriginY, width: largeCellSize.width, height: largeCellSize.height)
        } else if (indexPath.item + 1) % 6 == 0 {
            rect = CGRect(x: rightSideLargeCellOriginX, y: lineOriginY, width: largeCellSize.width, height: largeCellSize.height)
        } else if line.truncatingRemainder(dividingBy: 2) == 0 {
            if indexPath.item % 2 != 0 {
                rect = CGRect(x: rightSideSmallCellOriginX, y: lineOriginY, width: smallCellSize.width, height: smallCellSize.height)
            } else {
                rect = CGRect(x: rightSideSmallCellOriginX, y: lineOriginY + smallCellSize.height + itemSpacing, width: smallCellSize.width, height: smallCellSize.height)
            }
        } else {
            if indexPath.item % 2 != 0 {
                rect = CGRect(x: insets.left, y: lineOriginY, width: smallCellSize.width,  height: smallCellSize.height)
            } else {
                rect = CGRect(x: insets.left, y: lineOriginY + smallCellSize.height + itemSpacing, width: smallCellSize.width, height: smallCellSize.height)
            }
        }

        attribute.frame = rect

        return attribute
    }
}
