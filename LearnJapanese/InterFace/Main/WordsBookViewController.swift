//
//  WordsBookViewController.swift
//  LearnJapanese
//  收藏夹
//  Created by 唐星宇 on 2020/8/18.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

enum WordBookSyle {
    case markBook
    case wrongBook
}

class WordsBookViewController: LJBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var style: WordBookSyle = .markBook
    
    var wordPreview: WordsPreview = WordsPreview()
    ///收藏单词
    var wordArr: [WordModel] = []{
        didSet{
            
        }
    }
    
    lazy var wordTableView: UITableView = {
        let tableV: UITableView = UITableView(frame: .zero, style: .plain)
        tableV.register(SearchWordTbCell.self, forCellReuseIdentifier: "SearchWordTbCell")
        tableV.delegate = self
        tableV.dataSource = self
        tableV.separatorStyle = .none
        return tableV
    }()
    
    init(WithStyle style: WordBookSyle) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.createNavbar(navTitle: style == .markBook ? "收藏夹" : "错词本", leftIsImage: false, leftStr: "返回", rightIsImage: false, rightStr: nil, leftAction: nil, ringhtAction: #selector(editModeAction))
        getBookMarkWords()
    }
    
    @objc func editModeAction(){
        self.navgationBarV.rightBtn.isSelected = !self.navgationBarV.rightBtn.isSelected
        wordTableView.setEditing(self.navgationBarV.rightBtn.isSelected, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WidthScale(100)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        wordPreview.model = wordArr[indexPath.row]
        wordPreview.pop()
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) {
            (action, view, completionHandler) in
            if self.style == .markBook{
                self.wordArr[indexPath.row].bookMark = false
            }else{
                self.wordArr[indexPath.row].wrongMark = false
            }
            if SQLManager.updateWord(self.wordArr[indexPath.row]){
                Dprint("取消收藏成功")
            }else{
                Dprint("取消收藏失败")
            }
            self.wordArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            completionHandler(true)
        }
        delete.image = UIImage(named: "delete")
        delete.backgroundColor = .white
         
        //返回所有的事件按钮
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        
        return configuration
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(wordTableView)
        wordTableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(NavPlusStatusH)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchWordTbCell", for: indexPath) as! SearchWordTbCell
        cell.model = wordArr[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func getBookMarkWords(){
        wordArr = style == .markBook ? SQLManager.queryBookMarkWord() ?? [] : SQLManager.queryWrongMarkWord() ?? []
        wordTableView.reloadData()
    }

}
