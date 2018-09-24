//
//  ReorderableTripletLayout.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/20.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

protocol ReorderableTripletLayoutDataSource: TripletLayoutDatasource {
    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath, willMoveTo toIndexPath: IndexPath)

    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath, didMoveTo toIndexPath: IndexPath)
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath)

    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath, canMoveTo toIndexPath: IndexPath) -> Bool
}

extension ReorderableTripletLayoutDataSource {
    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath, willMoveTo toIndexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) {}

    func collectionView(_ collectionView: UICollectionView, itemAt indexPath: IndexPath, canMoveTo toIndexPath: IndexPath) -> Bool { return false }
}

protocol ReorderableTripletLayoutDelegate: TripletLayoutDelegate {
    func reorderingItemAlpha(_ collectionview: UICollectionView) -> CGFloat //Default 0.

    func autoScrollTrigerEdgeInsets(_ collectionView: UICollectionView) -> UIEdgeInsets //Sorry, has not supported horizontal scroll.

    func autoScrollTrigerPadding(_ collectionView: UICollectionView) -> UIEdgeInsets
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, willBeginDraggingItemAt indexPath: IndexPath)

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, didBeginDraggingItemAt indexPath: IndexPath)

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, willEndDraggingItemAt indexPath: IndexPath)

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, didEndDraggingItemAt indexPath: IndexPath)
}

extension ReorderableTripletLayoutDelegate {
    func reorderingItemAlpha(_ collectionview: UICollectionView) -> CGFloat {
        return 0
    }
    
    func autoScrollTrigerEdgeInsets(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return .zero
    }
    
    func autoScrollTrigerPadding(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, willBeginDraggingItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, didBeginDraggingItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, willEndDraggingItemAt indexPath: IndexPath) {}

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, didEndDraggingItemAt indexPath: IndexPath) {}
}

enum RAScrollDirction {
    case none, up, down
}

class ReorderableTripletLayout: TripletLayout {
    
    public weak var reorderableTripletLayoutDelegate: ReorderableTripletLayoutDelegate? {
        set {
            collectionView?.delegate = newValue
        }
        get {
            return collectionView?.delegate as? ReorderableTripletLayoutDelegate
        }
    }

    public weak var reorderableTripletLayoutDatasource: ReorderableTripletLayoutDataSource? {
        set {
            collectionView?.dataSource = newValue
        }
        get {
            return collectionView?.dataSource as? ReorderableTripletLayoutDataSource
        }
    }

    public private(set) var longPressGesture: UILongPressGestureRecognizer!
    public private(set) var panGesture: UIPanGestureRecognizer!
    
    
    
    private var cellFakeView: UIView!
    private var displayLink: CADisplayLink?
    private var scrollDirection: RAScrollDirction = .none
    private var reorderingCellIndexPath: IndexPath?
    private var reorderingCellCenter: CGPoint = .zero
    private var cellFakeViewCenter: CGPoint = .zero
    private var panTranslation: CGPoint = .zero
    private var scrollTrigerEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    private var scrollTrigePadding: UIEdgeInsets = .zero
     
    override func prepare() {
        super.prepare()
        //gesture
        
        if longPressGesture == nil {
            longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
            longPressGesture.delegate = self

            if let gestureRecognizers = collectionView?.gestureRecognizers {
                for gestureRecognizer in gestureRecognizers where gestureRecognizer is UILongPressGestureRecognizer {
                    gestureRecognizer.require(toFail: longPressGesture)
                    break
                }
            }

            collectionView?.addGestureRecognizer(longPressGesture)
        }
        
        if panGesture == nil {
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            panGesture.delegate = self
            collectionView?.addGestureRecognizer(panGesture)
        }

        //scroll triger insets
        
        if let delegate = reorderableTripletLayoutDelegate, let collectionView = collectionView {
            scrollTrigerEdgeInsets = delegate.autoScrollTrigerEdgeInsets(collectionView)
        }

        //scroll triger padding
        if let delegate = reorderableTripletLayoutDelegate, let collectionView = collectionView {
            scrollTrigePadding = delegate.autoScrollTrigerPadding(collectionView)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.layoutAttributesForItem(at: indexPath)
        
        if attribute?.representedElementCategory == .cell, attribute?.indexPath == reorderingCellIndexPath {
            var alpha: CGFloat = 0
            if let delegate = reorderableTripletLayoutDelegate {
                alpha = delegate.reorderingItemAlpha(collectionView!)
                alpha = max(0, min(1, alpha))
            }
            attribute?.alpha = alpha
        }
        return attribute
    }
    
    private func initDisplayLink() {
        if displayLink != nil {
            return
        }

        displayLink = CADisplayLink(target: self, selector: #selector(autoScroll))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    private func deinitDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc
    private func autoScroll() {

        guard let collectionView = collectionView else { return }

        let contentOffset = collectionView.contentOffset
        let contentInset = collectionView.contentInset
        let contentSize = collectionView.contentSize
        let boundsSize = collectionView.bounds.size
        var increment: CGFloat = 0

        if scrollDirection == .down {
            let percentage = (((cellFakeView.frame.maxY - contentOffset.y) - (boundsSize.height - scrollTrigerEdgeInsets.bottom - scrollTrigePadding.bottom)) / scrollTrigerEdgeInsets.bottom)
            increment = 10 * percentage
            if increment >= 10 {
                increment = 10
            }
        }else if scrollDirection == .up {
            let percentage = (1 - ((cellFakeView.frame.minY - contentOffset.y - scrollTrigePadding.top) / scrollTrigerEdgeInsets.top))
            increment = -10 * percentage

            increment = max(-10, increment)
        }

        if contentOffset.y + increment <= -contentInset.top {
            
            UIView.animate(withDuration: 0.07, delay: 0, options: .curveEaseOut, animations: {
                let diff = -contentInset.top - contentOffset.y
                collectionView.contentOffset = CGPoint(x: contentOffset.x, y: -contentInset.top)
                self.cellFakeViewCenter.y += diff
                self.cellFakeView.center = CGPoint(x: self.cellFakeViewCenter.x + self.panTranslation.x, y: self.cellFakeViewCenter.y + self.panTranslation.y)
            }, completion: nil)
            deinitDisplayLink()
            return
        }else if contentOffset.y + increment >= contentSize.height - boundsSize.height - contentInset.bottom {
            
            UIView.animate(withDuration: 0.07, delay: 0, options: .curveEaseOut, animations: {
                let diff = contentSize.height - boundsSize.height - contentInset.bottom - contentOffset.y
                collectionView.contentOffset = CGPoint(x: contentOffset.x, y: contentSize.height - boundsSize.height - contentInset.bottom)
                self.cellFakeViewCenter.y += diff
                self.cellFakeView.center = CGPoint(x: self.cellFakeViewCenter.x + self.panTranslation.x, y: self.cellFakeViewCenter.y + self.panTranslation.y)
            }, completion: nil)
            deinitDisplayLink()
            return
        }
        
        collectionView.performBatchUpdates({ [weak collectionView] in
            cellFakeViewCenter.y += increment
            cellFakeView.center = CGPoint(x: cellFakeViewCenter.x + panTranslation.x, y: cellFakeViewCenter.y + panTranslation.y)
            collectionView?.contentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + increment)
        }, completion: nil)

        moveItemIfNeeded()
    }

    @objc
    private func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            //indexPath

            let indexPath = collectionView?.indexPathForItem(at: sender.location(in: collectionView))
            //can move

            if let datasource = reorderableTripletLayoutDatasource {
                if !datasource.collectionView!(collectionView!, canMoveItemAt: indexPath!) {
                    return
                }
            }
            //will begin dragging
            if let delegate = reorderableTripletLayoutDelegate {
                delegate.collectionView(collectionView!, layout: self, willBeginDraggingItemAt: indexPath!)
            }
            
            //indexPath
            reorderingCellIndexPath = indexPath
            //scrolls top off
            collectionView?.scrollsToTop = false
            //cell fake view
            
            let cell = collectionView?.cellForItem(at: indexPath!)
            cellFakeView = UIView(frame: cell!.frame)
            cellFakeView?.layer.shadowColor = UIColor.black.cgColor
            cellFakeView?.layer.shadowOffset = .zero
            cellFakeView?.layer.shadowOpacity = 0.5
            cellFakeView?.layer.shadowRadius = 3
            
            let cellFakeImageView = generatImageView(with: cell!.bounds)
            let highlightedImageView = generatImageView(with: cell!.bounds)
            cell?.isHighlighted = true
            highlightedImageView.setCellCopiedImage(with: cell!)
            cell?.isHighlighted = false
            cellFakeImageView.setCellCopiedImage(with: cell!)
            collectionView?.addSubview(cellFakeView)
            cellFakeView.addSubview(cellFakeImageView)
            cellFakeView.addSubview(highlightedImageView)
            //set center
            reorderingCellCenter = cell?.center ?? .zero
            cellFakeViewCenter = cellFakeView.center
            deinitDisplayLink()
            //animation
            let fakeViewRect = CGRect(x: cell!.center.x - (smallCellSize.width / 2), y: cell!.center.y - (smallCellSize.height / 2), width: smallCellSize.width, height: smallCellSize.height)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                self.cellFakeView?.center = cell!.center
                self.cellFakeView?.frame = fakeViewRect
                self.cellFakeView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                highlightedImageView.alpha = 0
            }, completion: { _ in
                highlightedImageView.removeFromSuperview()
            })
            //did begin dragging
            if let delegate = reorderableTripletLayoutDelegate {
                delegate.collectionView(collectionView!, layout: self, didBeginDraggingItemAt: indexPath!)
            }
        case .ended, .cancelled:
            let currentCellIndexPath = reorderingCellIndexPath
            //will end dragging
            if let delegate = reorderableTripletLayoutDelegate {
                delegate.collectionView(collectionView!, layout: self, willEndDraggingItemAt: currentCellIndexPath!)
            }
            //scrolls top on
            collectionView?.scrollsToTop = true
            //disable auto scroll
            deinitDisplayLink()
            //remove fake view
            let attributes = layoutAttributesForItem(at: currentCellIndexPath!)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
                self.cellFakeView.transform = .identity
                self.cellFakeView.frame = attributes!.frame
            }, completion: { finished in
                self.cellFakeView.removeFromSuperview()
                self.cellFakeView = nil
                self.reorderingCellIndexPath = nil
                self.reorderingCellCenter = .zero
                self.cellFakeViewCenter = .zero
                self.invalidateLayout()
                guard finished else { return }
                //did end dragging
                if let delegate = self.reorderableTripletLayoutDelegate {
                    delegate.collectionView(self.collectionView!, layout: self, didEndDraggingItemAt: currentCellIndexPath!)
                }
            })
        default:
            break
        }
    }
    
    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        
        guard let collectionView = collectionView else { return }
        
        switch sender.state {
        case .changed:
            //translation
            
            panTranslation = sender.translation(in: collectionView)
            cellFakeView?.center = CGPoint(x: cellFakeViewCenter.x + panTranslation.x,
                                           y: cellFakeViewCenter.y + panTranslation.y)
            //move layout
            moveItemIfNeeded()
            //scroll
            
            let y = collectionView.contentOffset.y + (collectionView.bounds.height - scrollTrigerEdgeInsets.bottom - scrollTrigePadding.bottom)

            if cellFakeView.frame.maxY >= y {
                if (ceil(collectionView.contentOffset.y) < collectionView.contentSize.height - collectionView.bounds.height) {
                    scrollDirection = .down
                    initDisplayLink()
                }
            }else if cellFakeView.frame.minY <= collectionView.contentOffset.y + scrollTrigerEdgeInsets.top + scrollTrigePadding.top {
                if collectionView.contentOffset.y > -collectionView.contentInset.top {
                    scrollDirection = .up
                    initDisplayLink()
                }
            } else {
                scrollDirection = .none
                deinitDisplayLink()
            }
        case .ended, .cancelled:
            deinitDisplayLink()
        default:
            break
        }
    }
    
    private func generatImageView(with frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return imageView
    }
    
    
    private func moveItemIfNeeded() {
        let atIndexPath = reorderingCellIndexPath
        let toIndexPath = collectionView?.indexPathForItem(at: cellFakeView.center)
        
        
        if toIndexPath == nil || atIndexPath == toIndexPath {
            return
        }
        //can move

        if let datasource = reorderableTripletLayoutDatasource {
            if !datasource.collectionView(collectionView!, itemAt: atIndexPath!, canMoveTo: toIndexPath!) {
                return
            }
        }

        //will move
        if let datasource = reorderableTripletLayoutDatasource {
            datasource.collectionView(collectionView!, itemAt: atIndexPath!, willMoveTo: toIndexPath!)
        }

        //move
        collectionView?.performBatchUpdates({
            //update cell indexPath
            reorderingCellIndexPath = toIndexPath
            collectionView?.moveItem(at: atIndexPath!, to: toIndexPath!)
            //did move
            
            if let datasource = reorderableTripletLayoutDatasource {
                datasource.collectionView(collectionView!, itemAt: atIndexPath!, didMoveTo: toIndexPath!)
            }
        }, completion: nil)
    }
}

extension ReorderableTripletLayout: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if panGesture == gestureRecognizer {
            if longPressGesture.state == .possible || longPressGesture.state == .failed {
                return false
            }
        } else if longPressGesture == gestureRecognizer {
            if collectionView?.panGestureRecognizer.state != .possible && collectionView?.panGestureRecognizer.state != .failed {
                return false
            }
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if panGesture == gestureRecognizer {
            if longPressGesture.state != .possible && longPressGesture.state != .failed {
                if longPressGesture == otherGestureRecognizer {
                    return true
                }
                return false
            }
        } else if longPressGesture == gestureRecognizer {
            if panGesture == otherGestureRecognizer {
                return true
            }
        } else if collectionView?.panGestureRecognizer == gestureRecognizer {
            if longPressGesture.state == .possible || longPressGesture.state == .failed {
                return false
            }
        }
        return true
    }
}

extension UIImageView {
    func setCellCopiedImage(with cell: UICollectionViewCell) {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 4)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = image
    }
}
