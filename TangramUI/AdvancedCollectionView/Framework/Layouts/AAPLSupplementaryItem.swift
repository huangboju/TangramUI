//
//  AAPLSupplementaryItem.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/12/16.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

typealias AAPLSupplementaryItemConfigurationBlock = (UICollectionReusableView, AAPLDataSource<Any>, IndexPath) -> Void

class AAPLSupplementaryItem {
    /// The class to use when dequeuing an instance of this supplementary view
    var supplementaryViewClass = UIView.self
    
    /// Optional reuse identifier. If not specified, this will be inferred from the class of the supplementary view.
    var reuseIdentifier = ""

    /// A block that can be used to configure the supplementary view after it is created.
    var configureView: AAPLSupplementaryItemConfigurationBlock?

    init(kind: String) {
        
    }
}
