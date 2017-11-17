//
//  UIColor+Extension.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class var random: UIColor {
        let red = ( CGFloat(arc4random()).truncatingRemainder(dividingBy: 255) / 255.0 )
        let green = ( CGFloat(arc4random()).truncatingRemainder(dividingBy: 255) / 255.0 )
        let blue = ( CGFloat(arc4random()).truncatingRemainder(dividingBy: 255) / 255.0 )
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
