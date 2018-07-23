//
//  CSStickyHeaderFlowLayoutMenu.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2018/7/22.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

class CSStickyHeaderFlowLayoutMenu: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            CSLockedHeaderViewController.self,
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CSStickyHeaderFlowLayoutMenu"
        
        view.addSubview(tableView)
    }
}

extension CSStickyHeaderFlowLayoutMenu: UITableViewDataSource {
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

extension CSStickyHeaderFlowLayoutMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].classForCoder())"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer { tableView.deselectRow(at: indexPath, animated: false) }
        
        let controller = data[indexPath.section][indexPath.row].init()
        controller.title = "\(controller.classForCoder)"
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
