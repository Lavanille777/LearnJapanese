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
    
    ///主视图表格
    lazy var mainTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: WidthScale(26 + (isiPhoneX ? 24 : 0)), left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        tableView.register(LJMainTableViewCell.self, forCellReuseIdentifier: String(describing: LJMainTableViewCell.self))
        tableView.register(LJMainTableColVCell.self, forCellReuseIdentifier: String(describing: LJMainTableColVCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubview(bgImageView)
//        bgImageView.image = UIImage.init(named: "bgimg")
        bgImageView.contentMode = .scaleAspectFill
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UITableView{
            if scrollView.contentOffset.y < -WidthScale(isiPhoneX ? 24 : 0) && scrollView.contentOffset.y >= -StatusBarHeight{
                headerView.title2L.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().inset(WidthScale(20 + 6 * abs(StatusBarHeight + scrollView.contentOffset.y)))
                    make.top.equalToSuperview().inset(WidthScale(56 - 1.4 * (StatusBarHeight + scrollView.contentOffset.y)))
                }
                self.view.layoutIfNeeded()
                floatView.isHidden = true
                maskView.layer.mask = nil
            }else if scrollView.contentOffset.y < -StatusBarHeight{
                headerView.title2L.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().inset(WidthScale(20))
                    make.top.equalToSuperview().inset(WidthScale(56))
                }
                floatView.isHidden = true
                maskView.layer.mask = nil
            }else{
                headerView.title2L.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().inset(WidthScale(20 + 6 * StatusBarHeight))
                    make.top.equalToSuperview().inset(WidthScale(56 - 1.4 * StatusBarHeight))
                }
                floatView.isHidden = false
                maskView.layer.mask = maskLayer
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LJMainTableColVCell.self), for: indexPath) as! LJMainTableColVCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LJMainTableViewCell.self), for: indexPath) as! LJMainTableViewCell
            if let img = UIImage.init(named: "cell\(indexPath.row)"){
                cell.bgImgV.image = img
            }else{
                cell.bgImgV.image = UIImage.init(named: "cell0")
            }
            
            switch indexPath.row {
            case 0:
                if userInfo.havePlan{
                    cell.titleL.text = "我的计划"
                }else{
                    cell.titleL.text = "制定计划"
                }
            case 1:
                cell.titleL.text = "温故知新"
            case 3:
                cell.titleL.text = "查看进度"
            case 4:
                cell.titleL.text = "一学一练"
            default:
                break
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectIndexPath = indexPath
        let vc = MakingPlanViewController()
        
        switch indexPath.row {
        case 0:
            if userInfo.havePlan{
                vc.targetTitleL.text = "我的计划"
            }else{
                vc.targetTitleL.text = "制定计划"
            }
        case 1:
            vc.targetTitleL.text = "温故知新"
        case 3:
            vc.targetTitleL.text = "查看进度"
        case 4:
            vc.targetTitleL.text = "一学一练"
        default:
            break
        }
        vc.bgImgV.image = UIImage.init(named: "cell\(indexPath.row)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2{
            return WidthScale(170)
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
    
    //页面推进的动画
    var presentationTransition : UIViewControllerAnimatedTransitioning = LJPushTransitionAnimator(duration: 0.25)
    //页面返回的动画
    var dismissionTransition : UIViewControllerAnimatedTransitioning = LJPopTransitionAnimator(duration: 0.25)
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return presentationTransition
        }else if operation == .pop{
            return dismissionTransition
        }
        return nil
    }
    
}
