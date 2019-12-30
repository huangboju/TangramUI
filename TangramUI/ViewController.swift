//
//  ViewController.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/11/17.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

// http://martiancraft.com/blog/2017/05/collection-view-layouts/

class ViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            ServiceLayoutController.self,
            ReverseLayoutController.self,
            ReorderableTripletLayoutController.self,
            JungleCupCollectionViewController.self,
            ExcelMenu.self,
            StretchyLayoutMenu.self,
            GridLayoutController.self,
            PinterestLayoutMenu.self,
            ExpandingLayoutController.self,
            AdsorptionController.self,
            CenterLayoutController.self,
            WaterFallLayoutMenu.self,
            MosaicLayoutController.self,
            AKPFlowLayoutController.self,
            WalletMenu.self,
            StickyLayoutMenu.self,
            TableFlowLayoutVC.self,
            VegaScrollFlowLayoutVC.self,
            CardsCollectionViewLayoutVC.self
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UICollectionView"

        view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDataSource {
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

extension ViewController: UITableViewDelegate {
    
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

