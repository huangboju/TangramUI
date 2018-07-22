//
//  CSStickyHeaderFlowLayoutAttributes.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/7/21.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class CSStickyHeaderFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    var progressiveness: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        (copy as? CSStickyHeaderFlowLayoutAttributes)?.progressiveness = progressiveness
        return copy;
    }
    
    override var zIndex: Int {
        didSet {
            transform3D = CATransform3DMakeTranslation(0, 0, zIndex == 1 ? -1 : 0)
        }
    }
}
