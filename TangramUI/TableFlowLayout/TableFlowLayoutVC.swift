//
//  TableFlowLayout.swift
//  TangramUI
//
//  Created by xiAo_Ju on 2019/1/24.
//  Copyright © 2019 黄伯驹. All rights reserved.
//

import UIKit

class TableFlowLayoutVC: UITabBarController {

    private let simpleViewController = SimpleViewController()
    
    private let complexViewController = PlaceDetailViewController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        simpleViewController.tabBarItem = UITabBarItem(title: "Simple", image: #imageLiteral(resourceName: "first"), tag: 1)
        complexViewController.tabBarItem = UITabBarItem(title: "Complex", image: #imageLiteral(resourceName: "second"), tag: 2)
        
        viewControllers = [
            complexViewController,
            simpleViewController,
            ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
