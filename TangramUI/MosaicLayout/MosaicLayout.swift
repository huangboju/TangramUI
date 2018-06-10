//
//  MosaicLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/6/10.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class MosaicLayout: UICollectionViewLayout {
    
    var contentBounds: CGRect = .zero
    var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: cv.bounds.size)
        
        createAttributes()
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else { return false }
        return newBounds.size != cv.bounds.size
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        guard let firstMatchIndex = binarySearchAttributes(range: 0...cachedAttributes.endIndex, rect: rect) else {
            return attributesArr
        }
        
        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArr.append(attributes)
        }
        
        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArr.append(attributes)
        }

        return attributesArr
    }
    
    func createAttributes() {
        
    }
    
    func binarySearchAttributes(range: CountableClosedRange<Int>, rect: CGRect) -> Int? {
//        var lowerBound = 0
//        var upperBound = range.count
//        while lowerBound < upperBound {
//            let midIndex = lowerBound + (upperBound - lowerBound) / 2
//            if cachedAttributes[midIndex].frame == rect {
//                return midIndex
//            } else if cachedAttributes[midIndex] < rect {
//                lowerBound = midIndex + 1
//            } else {
//                upperBound = midIndex
//            }
//        }
        return nil
    }
}
