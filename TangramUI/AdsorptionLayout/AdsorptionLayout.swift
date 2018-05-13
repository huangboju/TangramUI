//
//  AdsorptionLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/5/11.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

/// A light-weight `UICollectionViewFlowLayout` subclass that allows the first item to be retractable.
open class AdsorptionLayout: UICollectionViewFlowLayout {
    
    // MARK: - Private Properties
    
    fileprivate let firstItemIndexPath = IndexPath(item: 0, section: 0)
    
    fileprivate var lastKnownTargetContentOffset: CGPoint?
    
    // MARK: - Public Properties
    
    /// The inset of the first item's retractable area within the first item's content area. Default value is `UIEdgeInsetsZero`.
    open var firstItemRetractableAreaInset = UIEdgeInsets.zero
    
    /// A Boolean value that determines whether the retractability of the first item is enabled. Default value is `true`.
    open var isEnabledRetractabilityOfFirstItem = true
    
    // MARK: - Superclass Properties
    
    open override var scrollDirection: UICollectionViewScrollDirection {
        
        didSet {
            if scrollDirection != oldValue {
                lastKnownTargetContentOffset = nil
            }
        }
    }
    
    // MARK: - Superclass Methods
    
    open override var collectionViewContentSize: CGSize {
        
        guard isEnabledRetractabilityOfFirstItem else {
            return super.collectionViewContentSize
        }

        guard let collectionView = self.collectionView,
              let _ = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
              let firstItemLayoutAttributes = layoutAttributesForItem(at: firstItemIndexPath) else {
            return super.collectionViewContentSize
        }
        
        var collectionViewContentSize = super.collectionViewContentSize
    
        switch scrollDirection {
        case .vertical:
            collectionViewContentSize.height = max(collectionViewContentSize.height, collectionView.frame.height + firstItemLayoutAttributes.frame.height)
            return collectionViewContentSize
        case .horizontal:
            collectionViewContentSize.width = max(collectionViewContentSize.width, collectionView.frame.width + firstItemLayoutAttributes.frame.width)
            return collectionViewContentSize
        }
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard isEnabledRetractabilityOfFirstItem else {
            
            let targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            lastKnownTargetContentOffset = targetContentOffset
            
            return targetContentOffset
        }
        
        guard let _ = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
            let firstItemLayoutAttributes = layoutAttributesForItem(at: firstItemIndexPath) else {
            let targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            lastKnownTargetContentOffset = targetContentOffset
            return targetContentOffset
        }
        
        let firstItemFrame = firstItemLayoutAttributes.frame
        
        let lastKnownTargetContentOffsetY: CGFloat?
        let proposedContentOffsetX: CGFloat
        let proposedContentOffsetY: CGFloat
        let firstItemRetractableAreaInsetTop: CGFloat
        let firstItemRetractableAreaInsetBottom: CGFloat
        let firstItemFrameMinY: CGFloat
        let firstItemFrameMidY: CGFloat
        let firstItemFrameMaxY: CGFloat
        
        switch scrollDirection {
        case .vertical:
            lastKnownTargetContentOffsetY = lastKnownTargetContentOffset?.y
            proposedContentOffsetX = proposedContentOffset.x
            proposedContentOffsetY = proposedContentOffset.y
            firstItemRetractableAreaInsetTop = self.firstItemRetractableAreaInset.top
            firstItemRetractableAreaInsetBottom = self.firstItemRetractableAreaInset.bottom
            firstItemFrameMinY = firstItemFrame.minY
            firstItemFrameMidY = firstItemFrame.midY
            firstItemFrameMaxY = firstItemFrame.maxY
            
        case .horizontal:
            lastKnownTargetContentOffsetY = lastKnownTargetContentOffset?.x
            proposedContentOffsetX = proposedContentOffset.y
            proposedContentOffsetY = proposedContentOffset.x
            firstItemRetractableAreaInsetTop = self.firstItemRetractableAreaInset.left
            firstItemRetractableAreaInsetBottom = self.firstItemRetractableAreaInset.right
            firstItemFrameMinY = firstItemFrame.minX
            firstItemFrameMidY = firstItemFrame.midX
            firstItemFrameMaxY = firstItemFrame.maxX
        }
        
        guard proposedContentOffsetY > firstItemFrameMinY && proposedContentOffsetY < firstItemFrameMaxY else {
            
            let targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            lastKnownTargetContentOffset = targetContentOffset
            
            return targetContentOffset
        }
        
        var targetContentOffset: CGPoint
        if let lastKnownTargetContentOffsetY = lastKnownTargetContentOffsetY {
            
            if lastKnownTargetContentOffsetY > proposedContentOffsetY {
                
                if proposedContentOffsetY > firstItemFrameMaxY - firstItemRetractableAreaInsetBottom {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMaxY)
                }
                else {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMinY)
                }
            }
            else {
                
                if proposedContentOffsetY < firstItemRetractableAreaInsetTop {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMinY)
                }
                else {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMaxY)
                }
            }
        }
        else {
            
            if velocity.y > 0.0 {
                
                targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMaxY)
            }
            else if velocity.y < 0.0 {
                
                targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMinY)
            }
            else {
                
                if proposedContentOffsetY > firstItemFrameMidY {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMaxY)
                }
                else {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMinY)
                }
            }
        }
        
        switch scrollDirection {
        case .horizontal:
            targetContentOffset = CGPoint(x: targetContentOffset.y, y: targetContentOffset.x)
        default:
            break
        }
        lastKnownTargetContentOffset = targetContentOffset
        return targetContentOffset
    }
}
