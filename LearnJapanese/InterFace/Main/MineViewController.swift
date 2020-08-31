//
//  MineViewController.swift
//  LearnJapanese
//  我的页面
//  Created by 唐星宇 on 2020/7/31.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit
import TZImagePickerController

class MineViewController: LJBaseViewController, TZImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    
    ///圆角背景
    var roundCornerBgV: UIView = UIView()
    ///头像
    var avatarV: UIView = UIView()
    var avatarImgV: UIImageView = UIImageView()
    ///昵称
    var nickNameL: UILabel = UILabel()
    ///修改昵称按钮
    var changeNameBtn: UIButton = UIButton()
    ///卡片
    var cardV: UIView = UIView()
    ///卡片占位
    var placeholderBtn: UIButton = UIButton()
    ///单词环形进度条
    var wordsProgressView: LJCycleProgressView = LJCycleProgressView.init(withWidth: WidthScale(10), radious: WidthScale(45), trackColor: HEXCOLOR(h: 0xe6e6e6, alpha: 1.0), progressStartColor: HEXCOLOR(h: 0x00BFFF, alpha: 0.2), progressEndColor: HEXCOLOR(h: 0x6495ED, alpha: 1.0))
    var wordsNumL: UILabel = UILabel()
    var wordsTitleL: UILabel = UILabel()
    
    ///今日记忆进度条
    var todaysProgressView: LJCycleProgressView = LJCycleProgressView.init(withWidth: WidthScale(10), radious: WidthScale(45), trackColor: HEXCOLOR(h: 0xe6e6e6, alpha: 1.0), progressStartColor: HEXCOLOR(h: 0xFFC125, alpha: 0.2), progressEndColor: HEXCOLOR(h: 0xFFC125, alpha: 1.0))
    var todaysNumL: UILabel = UILabel()
    var todaysTitleL: UILabel = UILabel()
    
    ///考试环形进度条
    var targetProgressView: LJCycleProgressView = LJCycleProgressView.init(withWidth: WidthScale(10), radious: WidthScale(45), trackColor: HEXCOLOR(h: 0xe6e6e6, alpha: 1.0), progressStartColor: HEXCOLOR(h: 0xcc0000, alpha: 0.2), progressEndColor: HEXCOLOR(h: 0xcc0000, alpha: 1.0))
    var targetDaysL: UILabel = UILabel()
    var targetTitleL: UILabel = UILabel()
    
    ///设置面板
    lazy var mineCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: WidthScale(60), height: WidthScale(85))
        flowLayout.minimumInteritemSpacing = WidthScale(20)
        flowLayout.minimumLineSpacing = WidthScale(20)
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(MineCollectionViewCell.self, forCellWithReuseIdentifier: "MineCollectionViewCell")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = HEXCOLOR(h: 0xfbfafb, alpha: 1.0)
        
        view.addSubview(roundCornerBgV)
        roundCornerBgV.backgroundColor = HEXCOLOR(h: 0x6495ED, alpha: 1.0)
        roundCornerBgV.layer.cornerRadius = WidthScale(40)
        roundCornerBgV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(-WidthScale(40))
            make.left.right.equalToSuperview()
            make.height.equalTo(WidthScale(347))
        }
        
        view.addSubview(cardV)
        cardV.backgroundColor = HEXCOLOR(h: 0xFFFFF0, alpha: 1.0)
        cardV.layer.cornerRadius = WidthScale(20)
        cardV.layer.shadowRadius = WidthScale(10)
        cardV.layer.shadowColor = HEXCOLOR(h: 0x101010, alpha: 0.3).cgColor
        cardV.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        cardV.layer.shadowOpacity = 1.0
        cardV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: WidthScale(335), height: WidthScale(260)))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(WidthScale(90))
        }
        
        cardV.addSubview(avatarV)
        avatarV.backgroundColor = .white
        avatarV.layer.cornerRadius = WidthScale(44)
        avatarV.layer.shadowColor = HEXCOLOR(h: 0x483D8B, alpha: 0.8).cgColor
        avatarV.layer.shadowOffset = CGSize(width: WidthScale(2), height: WidthScale(2))
        avatarV.layer.shadowRadius = WidthScale(3)
        avatarV.layer.shadowOpacity = 1.0
        avatarV.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(88))
            make.top.left.equalToSuperview().inset(WidthScale(20))
        }
        
        avatarV.addSubview(avatarImgV)
        avatarImgV.layer.cornerRadius = WidthScale(44)
        avatarImgV.contentMode = .scaleAspectFill
        avatarImgV.isUserInteractionEnabled = true
        avatarImgV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarTapAction)))
        avatarImgV.layer.masksToBounds = true
        do {
            try avatarImgV.image = UIImage(data: Data(contentsOf: URL.init(fileURLWithPath: "\(docPath)\(userInfo.avatarURL)")))
        } catch let error {
            Dprint("头像读取失败===\(error)")
            avatarImgV.image = UIImage(named: "avatar")
        }
        avatarImgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        cardV.addSubview(placeholderBtn)
        placeholderBtn.setTitle("快去制定计划吧", for: .normal)
        placeholderBtn.titleLabel?.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(20))
        placeholderBtn.setTitleColor(HEXCOLOR(h: 0x303030, alpha: 1.0), for: .normal)
        placeholderBtn.addPressAnimation()
        placeholderBtn.layer.cornerRadius = WidthScale(10)
        placeholderBtn.addTarget(self, action: #selector(placeholderAction), for: .touchUpInside)
        placeholderBtn.backgroundColor = HEXCOLOR(h: 0x87CEFA, alpha: 1)
        placeholderBtn.layer.shadowColor = HEXCOLOR(h: 0x949494, alpha: 0.5).cgColor
        placeholderBtn.layer.shadowOffset = CGSize(width: WidthScale(5), height: WidthScale(5))
        placeholderBtn.layer.shadowRadius = WidthScale(5)
        placeholderBtn.layer.shadowOpacity = 1.0
        placeholderBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(WidthScale(60))
            make.size.equalTo(CGSize(width: WidthScale(220), height: WidthScale(40)))
            make.centerX.equalToSuperview()
        }
        
        cardV.addSubview(nickNameL)
        nickNameL.text = userInfo.userName
        nickNameL.font = UIFont.init(name: FontYuanTiBold, size: WidthScale(24))
        nickNameL.textColor = HEXCOLOR(h: 0x303030, alpha: 1.0)
        nickNameL.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgV.snp.right).offset(WidthScale(20))
            make.right.lessThanOrEqualToSuperview().inset(WidthScale(30))
            make.centerY.equalTo(avatarImgV)
        }
        
        cardV.addSubview(changeNameBtn)
        changeNameBtn.setImage(UIImage(named: "pen"), for: .normal)
        changeNameBtn.addTarget(self, action: #selector(changeNameAction), for: .touchUpInside)
        changeNameBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nickNameL.snp.right).offset(WidthScale(10))
            make.centerY.equalTo(nickNameL)
            make.width.height.equalTo(WidthScale(40))
        }
        
        cardV.addSubview(wordsProgressView)
        wordsProgressView.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(90))
            make.left.equalToSuperview().inset(WidthScale(15))
            make.bottom.equalToSuperview().inset(WidthScale(40))
        }
        
        cardV.addSubview(wordsNumL)
        wordsNumL.textColor = HEXCOLOR(h: 0x66ccff, alpha: 1.0)
        wordsNumL.font = UIFont(name: FontYuanTiBold, size: WidthScale(18))
        wordsNumL.snp.makeConstraints { (make) in
            make.center.equalTo(wordsProgressView)
        }
        
        cardV.addSubview(wordsTitleL)
        wordsTitleL.textColor = HEXCOLOR(h: 0x66ccff, alpha: 1.0)
        wordsTitleL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(12))
        wordsTitleL.snp.makeConstraints { (make) in
            make.centerX.equalTo(wordsProgressView)
            make.top.equalTo(wordsProgressView.snp.bottom).offset(WidthScale(5))
        }
        
        cardV.addSubview(todaysProgressView)
        todaysProgressView.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(90))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(WidthScale(40))
        }
        
        cardV.addSubview(todaysNumL)
        todaysNumL.textColor = HEXCOLOR(h: 0xFFC125, alpha: 1.0)
        todaysNumL.font = UIFont(name: FontYuanTiBold, size: WidthScale(18))
        todaysNumL.snp.makeConstraints { (make) in
            make.center.equalTo(todaysProgressView)
        }
        
        cardV.addSubview(todaysTitleL)
        todaysTitleL.textColor = HEXCOLOR(h: 0xFFC125, alpha: 1.0)
        todaysTitleL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(12))
        todaysTitleL.snp.makeConstraints { (make) in
            make.centerX.equalTo(todaysProgressView)
            make.top.equalTo(todaysProgressView.snp.bottom).offset(WidthScale(5))
        }
        
        cardV.addSubview(targetProgressView)
        targetProgressView.snp.makeConstraints { (make) in
            make.width.height.equalTo(WidthScale(90))
            make.right.equalToSuperview().inset(WidthScale(15))
            make.bottom.equalToSuperview().inset(WidthScale(40))
        }
        
        cardV.addSubview(targetDaysL)
        targetDaysL.textColor = HEXCOLOR(h: 0x66ccff, alpha: 1.0)
        targetDaysL.font = UIFont(name: FontYuanTiBold, size: WidthScale(18))
        targetDaysL.snp.makeConstraints { (make) in
            make.center.equalTo(targetProgressView)
        }
        
        cardV.addSubview(targetTitleL)
        targetTitleL.textColor = HEXCOLOR(h: 0xcc0000, alpha: 1.0)
        targetTitleL.font = UIFont(name: FontYuanTiRegular, size: WidthScale(12))
        targetTitleL.snp.makeConstraints { (make) in
            make.centerX.equalTo(targetProgressView)
            make.top.equalTo(targetProgressView.snp.bottom).offset(WidthScale(5))
        }
        
        view.addSubview(mineCollectionView)
        mineCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(cardV.snp.bottom).offset(WidthScale(40))
            make.left.right.equalToSuperview().inset(WidthScale(25))
            make.height.equalTo(WidthScale(300))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userInfo.havePlan ? 3 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mineCollectionView.dequeueReusableCell(withReuseIdentifier: "MineCollectionViewCell", for: indexPath) as! MineCollectionViewCell
        switch indexPath.item {
        case 0:
            cell.titleL.text = "收藏夹"
            cell.imgV.image = UIImage(named: "notebook")
        case 1:
            cell.titleL.text = "错词本"
            cell.imgV.image = UIImage(named: "wrongbook")
        case 2:
            cell.titleL.text = "清除记录"
            cell.imgV.image = UIImage(named: "clear")
        default:
            break
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self.navigationController?.pushViewController(WordsBookViewController(WithStyle: .markBook), animated: true)
        case 1:
            self.navigationController?.pushViewController(WordsBookViewController(WithStyle: .wrongBook), animated: true)
        case 2:
            clenBtnAciton()
        default:
            break
        }
    }
    
    @objc func placeholderAction(){
        let vc = MakingPlanViewController(isFromLogin: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clenBtnAciton(){
        let alert = LJAlertViewController(withTitle: "确定要清除计划吗", alert: "所有记录将被清空", confirmTitle: "确定", cancelTitle: "再想想", confirmed: { (alert) in
            userInfo.targetLevel = 0
            userInfo.targetDate = Date()
            userInfo.todayWordsCount = 0
            userInfo.rememberWordsCount = 0
            userInfo.havePlan = false
            if SQLManager.updateUser(userInfo){
                SQLManager.refreshWordTable()
                self.mineCollectionView.reloadData()
                self.refreshState()
                Dprint("更新成功")
            }else{
                Dprint("更新失败")
            }
        }, canceled: nil)

        alert.show()
        
    }
    
    @objc func changeNameAction(){
        let alert = LJAlertViewController(withInputPlaceHolder: "起个好听的昵称吧", title: "确定要修改昵称吗", confirmTitle: "确认", cancelTitle: "再想想", confirmed: { (alert) in
            if let name = alert.inputTF.text, name.count > 0{
                if name.count > 10{
                    UIView.makeToast("昵称不能超过十个字哦")
                }else{
                    userInfo.userName = name
                    self.nickNameL.text = name
                    if SQLManager.updateUser(userInfo) {
                        Dprint("用户数据更新成功")
                    }else{
                        Dprint("用户数据更新失败")
                    }
                }
            }else{
                UIView.makeToast("昵称不能为空哦")
            }
        }, canceled: nil)
        alert.show()
    }
    
    
    @objc func avatarTapAction(){
        let imgPickerVC: TZImagePickerController = TZImagePickerController(maxImagesCount: 1, columnNumber: 5, delegate: self, pushPhotoPickerVc: true)
        imgPickerVC.allowCrop = true
        imgPickerVC.allowPickingVideo = false
        imgPickerVC.cropRect = CGRect(x: 0, y: imgPickerVC.view.frame.midY - SCREEN_WIDTH/2, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        imgPickerVC.didFinishPickingPhotosHandle = {[weak self](imgs, asset, isSelectOriginalPhoto) in
            if let weakSelf = self{
                weakSelf.avatarImgV.image = imgs?[0]
                if let avatarImg = imgs?[0], let data = avatarImg.jpegData(compressionQuality: 1.0), let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last{
                    let url = URL.init(fileURLWithPath: "\(path)/avatar_\(userInfo.id).jpeg")
                    do {
                        try data.write(to: url)
                        userInfo.avatarURL = "/avatar_\(userInfo.id).jpeg"
                        if SQLManager.updateUser(userInfo) {
                            Dprint("用户数据更新成功")
                        }else{
                            Dprint("用户数据更新失败")
                        }
                    } catch let error {
                        Dprint("头像存储失败\(error)")
                    }
                }
            }
        }
        
        let alert = LJAlertViewController(withTitle: "确定要修改头像吗", alert: nil, confirmTitle: nil, cancelTitle: nil, confirmed: {(alert) in
            self.present(imgPickerVC, animated: true, completion: nil)
        }, canceled: nil)
        
        alert.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        mineCollectionView.reloadData()
        refreshState()
    }
    
    func refreshState(){
        if userInfo.havePlan{
            placeholderBtn.isHidden = true
            wordsProgressView.isHidden = false
            todaysProgressView.isHidden = false
            targetProgressView.isHidden = false
            wordsNumL.isHidden = false
            wordsTitleL.isHidden = false
            todaysNumL.isHidden = false
            todaysTitleL.isHidden = false
            targetDaysL.isHidden = false
            targetTitleL.isHidden = false
            
            wordsProgressView.setProgress(progress: 0, time: 0, animate: false)
            todaysProgressView.setProgress(progress: 0, time: 0, animate: false)
            targetProgressView.setProgress(progress: 0, time: 0, animate: false)
            
            wordsNumL.text = "\(userInfo.rememberWordsCount)"
            wordsTitleL.text = "还剩\(userInfo.wordsCount - userInfo.rememberWordsCount)个词"
            todaysNumL.text = "\(userInfo.todayWordsCount)"
            todaysTitleL.text = "推荐每天记\(userInfo.averageWordsCount)个词"
            targetDaysL.text = "\(Int((Date().timeIntervalSince1970 - userInfo.ensureTargetDate.timeIntervalSince1970) / 86400))"
            targetTitleL.text = "还剩\(Int((userInfo.targetDate.timeIntervalSince1970 - Date().timeIntervalSince1970) / 86400))天"
        }else{
            placeholderBtn.isHidden = false
            wordsProgressView.isHidden = true
            todaysProgressView.isHidden = true
            targetProgressView.isHidden = true
            wordsNumL.isHidden = true
            wordsTitleL.isHidden = true
            todaysNumL.isHidden = true
            todaysTitleL.isHidden = true
            targetDaysL.isHidden = true
            targetTitleL.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userInfo.havePlan{
            wordsProgressView.setProgress(progress: CGFloat(userInfo.rememberWordsCount) / CGFloat(userInfo.wordsCount), time: 1, animate: true)
            todaysProgressView.setProgress(progress: min(CGFloat(userInfo.todayWordsCount) / CGFloat(userInfo.averageWordsCount), 1) , time: 1, animate: true)
            let days = max(CGFloat((Date().timeIntervalSince1970 - userInfo.ensureTargetDate.timeIntervalSince1970) / 86400), 1)
            targetProgressView.setProgress(progress: days / CGFloat((userInfo.targetDate.timeIntervalSince1970 - userInfo.ensureTargetDate.timeIntervalSince1970) / 86400), time: 1, animate: true)
        }
    }
    
}
