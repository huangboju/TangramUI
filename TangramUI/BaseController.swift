//
//  BaseController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

class BaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        initSubviews()
    }
    
    func initSubviews() {}
}
