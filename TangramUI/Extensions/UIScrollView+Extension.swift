//
//  UIScrollView+Extension.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2019/4/8.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

extension UIScrollView {
    var realContentInset: UIEdgeInsets {
        if #available(iOS 11, *) {
            return adjustedContentInset
        }
        return contentInset
    }
}
