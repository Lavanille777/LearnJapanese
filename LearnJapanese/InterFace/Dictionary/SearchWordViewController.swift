//
//  SearchWordViewController.swift
//  LearnJapanese
//  查单词列表
//  Created by 唐星宇 on 2020/7/23.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class SearchWordViewController: LJBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    ///搜索框
    var searchV: UIView = UIView()
    var searchTF: UITextField = UITextField()
    var searchIconImgV: UIImageView = UIImageView()
    
    ///单词表
    lazy var wordTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(SearchWordTbCell.self, forCellReuseIdentifier: String(describing: SearchWordTbCell.self))
        return tableView
    }()
    
    ///单词数据源
    var wordModelArr: [wordModel] = []{
        didSet{
            wordTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupUI(){
        
        view.addSubview(searchV)
        searchV.backgroundColor = HEXCOLOR(h: 0x101010, alpha: 0.3)
        searchV.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(NavPlusStatusH)
        }
        
        searchV.addSubview(searchTF)
        searchTF.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        searchTF.delegate = self
        searchTF.backgroundColor = .white
        searchTF.placeholder = "在这里输入要查的词"
        searchTF.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        searchTF.font = UIFont.systemFont(ofSize: WidthScale(16))
        searchTF.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(20))
            make.bottom.equalToSuperview().inset(WidthScale(10))
            make.height.equalTo(WidthScale(30))
        }
        
        view.addSubview(wordTableView)
        wordTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchV.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    @objc func textChanged(){
        if let text = searchTF.text, text.count > 0, let arr = SQLManager.queryWordsByString(text){
            wordModelArr = arr
        }else{
            wordModelArr = []
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WidthScale(60)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchWordTbCell.self), for: indexPath) as! SearchWordTbCell
        
        cell.model = wordModelArr[indexPath.row]
        
        return cell
    }
    
}
