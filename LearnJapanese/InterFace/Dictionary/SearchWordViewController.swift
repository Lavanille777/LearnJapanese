//
//  SearchWordViewController.swift
//  LearnJapanese
//  查单词列表
//  Created by 唐星宇 on 2020/7/23.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class SearchWordViewController: LJBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var bgImageView: UIImageView = UIImageView()
    ///搜索框
    var searchV: UIView = UIView()
    var searchBGV: UIView = UIView()
    var searchTF: UITextField = UITextField()
    var searchIconImgV: UIImageView = UIImageView()
    
    var wordBGView: UIView = UIView()
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
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: WidthScale(10), left: 0, bottom: IPHONEX_BH + WidthScale(80), right: 0)
        tableView.register(SearchWordTbCell.self, forCellReuseIdentifier: String(describing: SearchWordTbCell.self))
        return tableView
    }()
    
    ///单词数据源
    var wordModelArr: [WordModel] = []{
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
        
//        view.addSubview(bgImageView)
//        bgImageView.image = UIImage(named: "sakura")
//        bgImageView.contentMode = .top
//        bgImageView.isUserInteractionEnabled = true
//        bgImageView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        view.addSubview(searchV)
        searchV.backgroundColor = .clear
        searchV.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(NavPlusStatusH)
        }
        
        searchV.addSubview(searchBGV)
        searchBGV.backgroundColor = HEXCOLOR(h: 0xe6e6e6, alpha: 1.0)
        searchBGV.layer.masksToBounds = true
        searchBGV.layer.cornerRadius = WidthScale(10)
        searchBGV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(WidthScale(20))
            make.bottom.equalToSuperview().inset(WidthScale(5))
            make.height.equalTo(WidthScale(35))
        }
        
        searchBGV.addSubview(searchIconImgV)
        searchIconImgV.image = UIImage(named: "search")
        searchIconImgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(5)
            make.width.height.equalTo(WidthScale(25))
            make.centerY.equalToSuperview()
        }
        
        searchBGV.addSubview(searchTF)
        searchTF.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        searchTF.delegate = self
        searchTF.backgroundColor = .clear
        searchTF.placeholder = "在这里输入要查的词"
        searchTF.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        searchTF.font = UIFont.systemFont(ofSize: WidthScale(16))
        searchTF.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(35))
            make.right.equalToSuperview().inset(WidthScale(10))
            make.centerY.equalToSuperview().inset(WidthScale(10))
            make.height.equalTo(WidthScale(30))
        }
        
        view.addSubview(wordBGView)
        wordBGView.snp.makeConstraints { (make) in
            make.top.equalTo(searchV.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        wordBGView.addSubview(wordTableView)
        wordTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.layoutIfNeeded()
        
        let maskLayer: CAGradientLayer = CAGradientLayer.init()
        maskLayer.locations = [0, 0.04]
        maskLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        maskLayer.frame = wordBGView.bounds
        wordBGView.layer.mask = maskLayer
        
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
        return WidthScale(100)
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
