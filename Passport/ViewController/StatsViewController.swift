//
//  FirstViewController.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Toast_Swift

class StatsViewController: BaseUIViewController {
    
    var snapShotTableView: UITableView?
    var snapShot = false
    
    var stats: StatsModel?
    let shareButton = UIButton.init(type: UIButton.ButtonType.custom).then {
        $0.setImage(UIImage(named: "icon_share"), for: .normal)
    }
    let moreButton = UIButton.init(type: UIButton.ButtonType.custom).then {
        $0.setImage(UIImage(named: "icon_more"), for: .normal)
    }
    let tableView = StatsViewController.createTableView()
    let tableHeaderView = StatsViewController.createHeaderView()
    
    static func createTableView() -> UITableView {
        return UITableView(frame: .zero, style: .plain).then {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .none
            $0.register(StatsGazeWorldCell.self, forCellReuseIdentifier: String(describing: StatsGazeWorldCell.self))
            $0.register(StatsPoetryDistanceCell.self, forCellReuseIdentifier: String(describing: StatsPoetryDistanceCell.self))
            $0.register(StatsDataInsightCell.self, forCellReuseIdentifier: String(describing: StatsDataInsightCell.self))
            $0.register(StatsTomorrowCell.self, forCellReuseIdentifier: String(describing: StatsTomorrowCell.self))
            if #available(iOS 11.0, *) {
                $0.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    static func createHeaderView() -> StatsProfileHeaderView {
        return StatsProfileHeaderView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 280))
    }
    
    
    
    
    override func hideNavigationBar() -> Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        edgesForExtendedLayout = []
        fetchStatsInfo()
        setupActions()
    }
    
    func setupSubviews() {
        automaticallyAdjustsScrollViewInsets = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        view.addSubview(shareButton)
        view.addSubview(moreButton)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        moreButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIDevice.current.isX ? (SafeArea.iPhoneXInsets.top + 32) : 32)
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(24)
        }
        shareButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIDevice.current.isX ? (SafeArea.iPhoneXInsets.top + 32) : 32)
            make.right.equalTo(moreButton.snp.left).offset(-15)
            make.width.height.equalTo(24)
        }
    }
    
    func setupActions() {
        shareButton.addTarget(self, action: #selector(clickShareButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(clickMoreButton), for: .touchUpInside)
        ForchTouchManager.add3DTouch(self, view: tableView)
    }
    
    @objc func clickShareButton() {
        SVProgressHUD.show()
        
        self.snapShot = true
        let tableView = StatsViewController.createTableView()
        let headerView = StatsViewController.createHeaderView()
        if let stats = self.stats {
            headerView.updateUIWithData(stats)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        tableView.frame = CGRect.init(x: 0, y: 0, width: self.tableView.width, height: self.tableView.contentSize.height)
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        let scale = min(2, UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(tableView.frame.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        self.snapShotTableView = tableView
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) { [weak self] in
            guard let strongSelf = self else {return}
            tableView.layer.render(in: context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let items = [image]
            let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            strongSelf.present(ac, animated: true)
            strongSelf.snapShot = false
            SVProgressHUD.dismiss()
        }
        
    }
    
    @objc func clickMoreButton() {
        let alertSheet = KEPUIAlertController.actionSheet(withTitle: nil)
        let alertAction = UIAlertAction(title: "删除账号", style: .default) { (action) in
            AccountManager.logout()
            SVProgressHUD.showInfo(withStatus: "账号已退出")
            let welcomeViewController = ResourceUtil.mainSB().instantiateViewController(withIdentifier: "PassportNavigationController") as! UINavigationController
            UIApplication.shared.delegate?.window?!.rootViewController = welcomeViewController
        }
        let cacelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertSheet.addAction(alertAction)
        alertSheet.addAction(cacelAction)
        KEPUIAlertController.showActionSheet(alertSheet, arrowDirection: .up, sender: nil, controller: self)
    }
    
    func fetchStatsInfo() {
        SVProgressHUD.show(withStatus: "Loading..")
        StatsRequester.fetchStatsInfo { [weak self] (success, dict) in
            if success {
                guard let _ = self, let dictionary = dict as? Dictionary<String, Any> else {return}
                self!.stats = dictionary[kResultData] as! StatsModel
                self!.tableHeaderView.updateUIWithData(self!.stats!)
                self!.tableView.reloadData()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableHeaderView.updateContentOffsetY(scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableHeaderView.updateContentOffsetY(scrollView.contentOffset.y)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableHeaderView.updateContentOffsetY(scrollView.contentOffset.y)
    }
}

extension StatsViewController: UITableViewDelegate, UITableViewDataSource,UIViewControllerPreviewingDelegate {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatsGazeWorldCell.self), for: indexPath) as! StatsGazeWorldCell
            cell.updateUIWithData(stats!)
            return cell
        } else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatsPoetryDistanceCell.self), for: indexPath) as! StatsPoetryDistanceCell
            cell.updateUIWithData(stats!, snapShot: snapShot)
            return cell
        } else if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatsDataInsightCell.self), for: indexPath) as! StatsDataInsightCell
            cell.updateUIWithData(stats!)
            return cell
        } else if (indexPath.row == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatsTomorrowCell.self), for: indexPath) as! StatsTomorrowCell
            cell.updateUIWithData(stats!)
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = stats {
            return 1
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = stats {
            return 4
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 490
        } else if (indexPath.row == 1) {
            return 508
        } else if (indexPath.row == 2) {
            return 300
        } else if (indexPath.row == 3) {
            return 652 + 100
        }
        return 0
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        //        [self.navigationController pushViewController:viewControllerToCommit animated:NO];
        navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // previewingContext.sourceView: 触发Peek & Pop操作的视图
        // previewingContext.sourceRect: 设置触发操作的视图的不被虚化的区域
        if let indexPath = tableView.indexPathForRow(at: location) {
            if let _ = tableView.cellForRow(at: indexPath) {
                //
                //        TripsClipModel *trip = [self.trips.trips objectAtIndex:indexPath.row];
                //        TripDetailViewModel *vm = [[TripDetailViewModel alloc] init];
                //        vm.fromType = KEPAthleticFieldFromTypeTrip;
                //        vm.requetId = trip._id;
                //        TripDetailViewController *vc = [[TripDetailViewController alloc] initWithViewModel:vm];
                //        vc.hidesBottomBarWhenPushed = YES;
                //        // 预览区域大小(可不设置)
                //        vc.preferredContentSize = CGSizeMake(0, 300);
                //        return vc;
                
            }
        }
        return nil
    }
}

