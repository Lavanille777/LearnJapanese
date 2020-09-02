//
//  LJMainViewController.swift
//  LearnJapanese
//  首页
//  Created by 唐星宇 on 2020/5/21.
//  Copyright © 2020 唐星宇. All rights reserved.
//

import UIKit

class LJMainViewController: LJBaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UINavigationControllerDelegate{
    
    var headerView: LJMainTableHeaderView = LJMainTableHeaderView()
    
    var floatView: LJMainTableFloatView = LJMainTableFloatView()
    
    var bgImageView: UIImageView = UIImageView()
    
    var maskView: UIView = UIView()
    
    var maskLayer: CAGradientLayer = CAGradientLayer.init()
    
    var didSelectIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    //页面推进的动画
    var presentationTransition : LJPushTransitionAnimator = LJPushTransitionAnimator(duration: 0.25)
    //页面返回的动画
    var dismissionTransition : LJPopTransitionAnimator = LJPopTransitionAnimator(duration: 0.25)
    
    var replaceInteractivePopTransition: LJPopInteractiveTransitioning = LJPopInteractiveTransitioning()
    
    var isViewApear: Bool = false
    ///主视图表格
    lazy var mainTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: WidthScale(26 + (isiPhoneX ? 24 : 0)), left: 0, bottom: IPHONEX_BH + WidthScale(60), right: 0)
        tableView.backgroundColor = .clear
        tableView.register(LJMainTableViewCell.self, forCellReuseIdentifier: String(describing: LJMainTableViewCell.self))
        tableView.register(LJMainTableColVCell.self, forCellReuseIdentifier: String(describing: LJMainTableColVCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isViewApear = true
        mainTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
    
    func setupUI(){
        
        view.backgroundColor = .white
        view.addSubview(bgImageView)
        bgImageView.image = UIImage(named: "sakura")
        bgImageView.contentMode = .top
        bgImageView.isUserInteractionEnabled = true
        bgImageView.addSubview(maskView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bgImageView.addSubview(maskView)
        maskView.addSubview(mainTableView)
        bgImageView.addSubview(floatView)
        
        maskView.snp.makeConstraints { (make) in
            make.top.equalTo(floatView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        mainTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        floatView.isHidden = true
        floatView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(WidthScale(60 + (isiPhoneX ? 24 : 0)))
        }
        
        
        view.layoutIfNeeded()
        
        maskLayer.locations = [0.005, 0.025]
        maskLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        maskLayer.frame = maskView.bounds
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrooling = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrooling = true
        if scrollView is UITableView && isViewApear{
            if scrollView.contentOffset.y < -WidthScale(isiPhoneX ? 24 : 0){
                self.floatView.isHidden = true
                self.maskView.layer.mask = nil
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.headerView.title2L.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().inset(WidthScale(20))
                        make.top.equalToSuperview().inset(WidthScale(56))
                    }
                    self.floatView.title2L.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().inset(WidthScale(20))
                        make.top.equalTo(self.floatView.title1L.snp.bottom).offset(WidthScale(10))
                    }
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else if self.floatView.isHidden{
                view.layer.removeAllAnimations()
                self.floatView.isHidden = false
                self.maskView.layer.mask = self.maskLayer
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    self.floatView.title2L.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().inset(WidthScale(140))
                        make.top.equalToSuperview().offset(WidthScale(28) + WidthScale(isiPhoneX ? 24 : 0))
                    }
                    self.headerView.title2L.snp.remakeConstraints { (make) in
                        make.left.equalTo(self.headerView.title1L.snp.right).offset(WidthScale(20))
                        make.centerY.equalTo(self.headerView.title1L)
                    }
                    self.view.layoutIfNeeded()
                    self.floatView.layoutIfNeeded()
                }, completion: {(finished) in
                    if finished{
                        self.maskView.layer.mask = self.maskLayer
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LJMainTableColVCell.self), for: indexPath) as! LJMainTableColVCell
            cell.popAnimation = dismissionTransition
            cell.replaceInteractivePopTransition = replaceInteractivePopTransition
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LJMainTableViewCell.self), for: indexPath) as! LJMainTableViewCell
            
            switch indexPath.row {
            case 0:
                cell.rightImgV.image = UIImage(named: "cat1")
                cell.titleL.text = "学点儿新词"
                if cell.bgImgV.layer.sublayers == nil{
                    cell.bgImgV.addGradientLayer(colors: [HEXCOLOR(h: 0xFDF5E6, alpha: 0.25).cgColor, HEXCOLOR(h: 0xFDF5E6, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
                }
                
            case 1:
                cell.rightImgV.image = UIImage(named: "cat3")
                if cell.bgImgV.layer.sublayers == nil{
                    cell.bgImgV.addGradientLayer(colors: [HEXCOLOR(h: 0xF5DEB3, alpha: 0.25).cgColor, HEXCOLOR(h: 0xF5DEB3, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
                }
                cell.titleL.text = "温故知新"
            case 3:
                cell.rightImgV.image = UIImage(named: "cat2")
                if cell.bgImgV.layer.sublayers == nil{
                    cell.bgImgV.addGradientLayer(colors: [HEXCOLOR(h: 0xFFC0CB, alpha: 0.25).cgColor, HEXCOLOR(h: 0xFFC0CB, alpha: 1.0).cgColor], locations: [0,1], isHor: true)
                }
                cell.titleL.text = "拼写练习"
            default:
                break
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectIndexPath = indexPath
        guard let cell = tableView.cellForRow(at: indexPath) as? LJMainTableViewCell else {
            return
        }
        let rect = cell.convert(cell.bgImgV.frame, to: self.view)
        NotificationCenter.default.post(name: NSNotification.Name(MAINVIEWPUSHTOUCH), object: nil, userInfo: ["view": cell, "rect": rect])
        switch indexPath.row {
        case 0:
            if userInfo.havePlan{
                let vc = LearnNewWordViewController()
                vc.popAnimation = dismissionTransition
                vc.replaceInteractivePopTransition = replaceInteractivePopTransition
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                UIView.makeToast("需要先制定计划哦")
            }
        case 1:
            if userInfo.rememberWordsCount < 10{
                UIView.makeToast("先记几个词再来吧，至少十个哦")
            }else{
                let vc = ReviewWordsViewController()
                vc.popAnimation = dismissionTransition
                vc.replaceInteractivePopTransition = replaceInteractivePopTransition
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case 3:
            if userInfo.rememberWordsCount < 10{
                UIView.makeToast("先记几个词再来吧，至少十个哦")
            }else{
                let vc = SpellViewController()
                vc.popAnimation = dismissionTransition
                vc.replaceInteractivePopTransition = replaceInteractivePopTransition
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
            
        default:
            break
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2{
            return WidthScale(180)
        }
        return WidthScale(140)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WidthScale(80)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
    }
    
    
    //MARK: - 导航动画
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return presentationTransition
        }else if operation == .pop{
            return dismissionTransition
        }
        return nil
    }
    
}
