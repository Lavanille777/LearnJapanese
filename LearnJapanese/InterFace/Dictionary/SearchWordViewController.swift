//
//  SearchWordViewController.swift
//  LearnJapanese
//  查单词列表
//  Created by 唐星宇 on 2020/7/23.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

struct RequestWordModel: Codable {
    
    struct TranslateResult: Codable{
        var src: String?
        
        var tgt: String?
    }
    
    var type: String?
    
    var errorCode: Int?
    
    var elapsedTime: Int64?
    
    var translateResult: [[TranslateResult]]?
    
}

class SearchWordViewController: LJBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var bgImageView: UIImageView = UIImageView()
    ///搜索框
    var searchV: UIView = UIView()
    var searchBGV: UIView = UIView()
    var searchTF: UITextField = UITextField()
    var searchIconImgV: UIImageView = UIImageView()
    
    var wordBGView: UIView = UIView()
    
    var wordPreview: WordsPreview = WordsPreview()
    
    var placeHoldImgV: UIImageView = UIImageView()
    
    var noResultV: UIView = UIView()
    var noResultL: UILabel = UILabel()
    var ctojBtn: UIButton = UIButton()
    var jtocBtn: UIButton = UIButton()
    
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
            noResultV.isHidden = wordModelArr.count != 0 || searchTF.text == ""
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
        
        
        wordBGView.addSubview(placeHoldImgV)
        placeHoldImgV.image = UIImage(named: "cat3")
        placeHoldImgV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WidthScale(150), height: WidthScale(142)))
        }
        
        let maskLayer: CAGradientLayer = CAGradientLayer.init()
        maskLayer.locations = [0, 0.02]
        maskLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        maskLayer.frame = wordBGView.bounds
        wordBGView.layer.mask = maskLayer
        
        wordBGView.addSubview(noResultV)
        noResultV.isHidden = true
        noResultV.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(200))
        }
        
        noResultV.addSubview(noResultL)
        noResultL.text = "没有结果哦，要搜索网络吗"
        noResultL.font = UIFont(name: FontYuanTiBold, size: WidthScale(16))
        noResultL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        noResultL.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(WidthScale(20))
        }
        
        noResultV.addSubview(ctojBtn)
        ctojBtn.setTitle("中译日", for: .normal)
        ctojBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1.0), for: .normal)
        ctojBtn.titleLabel?.font = UIFont(name: FontYuanTiRegular, size: WidthScale(20))
        ctojBtn.layer.cornerRadius = WidthScale(10)
        ctojBtn.titleLabel?.textAlignment = .center
        ctojBtn.layer.masksToBounds = true
        ctojBtn.addOncePressAnimation()
        ctojBtn.addTarget(self, action: #selector(requestYouDao), for: .touchUpInside)
        ctojBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(WidthScale(40))
            make.size.equalTo(CGSize(width: WidthScale(120), height: WidthScale(40)))
            make.centerY.equalToSuperview()
        }
        
        noResultV.addSubview(jtocBtn)
        jtocBtn.setTitle("日译中", for: .normal)
        jtocBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1.0), for: .normal)
        jtocBtn.titleLabel?.font = UIFont(name: FontYuanTiRegular, size: WidthScale(20))
        jtocBtn.addTarget(self, action: #selector(requestYouDao), for: .touchUpInside)
        jtocBtn.layer.cornerRadius = WidthScale(10)
        jtocBtn.addOncePressAnimation()
        jtocBtn.titleLabel?.textAlignment = .center
        jtocBtn.layer.masksToBounds = true
        jtocBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(WidthScale(40))
            make.size.equalTo(CGSize(width: WidthScale(120), height: WidthScale(40)))
            make.centerY.equalToSuperview()
        }
        
        view.layoutIfNeeded()
        
        ctojBtn.addGradientLayer(colors: [HEXCOLOR(h: 0x66ccff, alpha: 0.3).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
        jtocBtn.addGradientLayer(colors: [HEXCOLOR(h: 0x66ccff, alpha: 0.3).cgColor, HEXCOLOR(h: 0x66ccff, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
               
    }
    
    @objc func textChanged(){
        if let text = searchTF.text, text.count > 0, let arr = SQLManager.queryWordsByString(text){
                wordModelArr = arr
            placeHoldImgV.isHidden = true
        }else{
            placeHoldImgV.isHidden = false
            wordModelArr = []
        }
    }
    
    @objc func requestYouDao(sender: UIButton){

        let jtoc = "https://fanyi.youdao.com/translate?&doctype=json&type=JA2ZH_CN&i=\(searchTF.text ?? "")"
        
        let ctoj = "https://fanyi.youdao.com/translate?&doctype=json&type=ZH_CN2JA&i=\(searchTF.text ?? "")"
        
        let url : URL =  URL.initPercent(string: sender == ctojBtn ? ctoj : jtoc)
        let request = URLRequest(url: url as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, respons, error) in
            Dprint(error as Any)
            if data == nil {
                UIView.makeToast("网络查询太频繁啦，等会儿再试试吧")
                return
            }
            if respons == nil {return}
            
            let str = String(data: data!, encoding: .utf8)
            let decoder = JSONDecoder()
            var model = RequestWordModel()
            do{
                model = try decoder.decode(RequestWordModel.self, from: data!)
                let wordModel = WordModel()
                if let translateResult = model.translateResult?.first?.first{
                    wordModel.japanese = sender == self.ctojBtn ? translateResult.tgt ?? "" : translateResult.src ?? ""
                    wordModel.pronunciation = "翻译结果来自有道"
                    wordModel.chinese = sender == self.jtocBtn ? translateResult.tgt ?? "" : translateResult.src ?? ""
                    DispatchQueue.main.async {
                        self.wordModelArr = [wordModel]
                    }
                }
            }catch let err{
                print(err)
            }
            
            Dprint(str as Any)
            Dprint(respons!)
        }
        dataTask.resume()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        wordPreview.model = wordModelArr[indexPath.row]
        wordPreview.pop()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension URL{
    
    static func initPercent(string:String) -> URL
    {
        let urlwithPercentEscapes = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let url = URL.init(string: urlwithPercentEscapes!)
        return url!
    }
}
