//
//  BaseController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import SafariServices

class BaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "github", style: .plain, target: self, action: #selector(barButtonClicked))

        view.backgroundColor = UIColor.white
        
        initSubviews()
    }
    
    func initSubviews() {}
    
    
    var githubUrl: String {
        fatalError()
    }
    
    @objc
    func barButtonClicked() {
        guard let url = URL(string: githubUrl) else { return }
        present(SFSafariViewController(url: url), animated: true, completion: nil)
    }
}
