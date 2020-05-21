//
//  LJMainViewController.swift
//  LearnJapanese
//  首页
//  Created by 唐星宇 on 2020/5/21.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainViewController: LJBaseViewController, UITableViewDelegate, UITableViewDataSource{
    var headerView: LJMainTableHeaderView = LJMainTableHeaderView()
    
    ///主视图表格
    lazy var mainTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 11
        tableView.layer.masksToBounds = true
        tableView.register(LJMainTableViewCell.self, forCellReuseIdentifier: String(describing: LJMainTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LJMainTableViewCell.self), for: indexPath) as! LJMainTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WidthScale(140)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WidthScale(80)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
}
