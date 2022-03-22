//
//  SplitLayoutMenu.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2022/3/22.
//  Copyright © 2022 黄伯驹. All rights reserved.
//

import UIKit

class SplitLayoutMenu: BaseController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            SectionDividedCollectionViewController.self,
            EmojiCollectionViewController.self,
            BasicCollectionViewController.self
        ]
    ]
    
    override func initSubviews() {
        title = "UICollectionViewSplitLayout"
        
        view.addSubview(tableView)
    }
    
    override var githubUrl: String {
        "https://github.com/yahoojapan/UICollectionViewSplitLayout"
    }
}

extension SplitLayoutMenu: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
}

extension SplitLayoutMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].classForCoder())"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer { tableView.deselectRow(at: indexPath, animated: false) }
        
        let controller = data[indexPath.section][indexPath.row].init()
        controller.title = "\(controller.classForCoder)"
        controller.hidesBottomBarWhenPushed = true
        show(controller, sender: nil)
    }
}
