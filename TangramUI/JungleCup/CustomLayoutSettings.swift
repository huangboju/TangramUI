//
//  CustomLayoutAttributes.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/26.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//


struct CustomLayoutSettings {
    
    // Elements sizes
    var itemSize: CGSize?
    var headerSize: CGSize?
    var menuSize: CGSize?
    var sectionsHeaderSize: CGSize?
    var sectionsFooterSize: CGSize?
    
    // Behaviours
    var isHeaderStretchy: Bool
    var isAlphaOnHeaderActive: Bool
    var headerOverlayMaxAlphaValue: CGFloat
    var isMenuSticky: Bool
    var isSectionHeadersSticky: Bool
    var isParallaxOnCellsEnabled: Bool
    
    // Spacing
    var minimumInteritemSpacing: CGFloat
    var minimumLineSpacing: CGFloat
    var maxParallaxOffset: CGFloat
}

extension CustomLayoutSettings {
    
    init() {
        itemSize = nil
        headerSize = nil
        menuSize = nil
        sectionsHeaderSize = nil
        sectionsFooterSize = nil
        isHeaderStretchy = false
        isAlphaOnHeaderActive = true
        headerOverlayMaxAlphaValue = 0
        isMenuSticky = false
        isSectionHeadersSticky = false
        isParallaxOnCellsEnabled = false
        maxParallaxOffset = 0
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
}

