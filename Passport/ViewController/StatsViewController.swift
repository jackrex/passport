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

class StatsViewController: BaseUIViewController {
    
    var stats: StatsModel?
    let shareButton = UIButton.init(type: UIButton.ButtonType.custom).then {
        $0.setImage(UIImage(named: "icon_share"), for: .normal)
    }
    let tableView = UITableView(frame: .zero, style: .plain).then {
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
    
    let tableHeaderView = StatsProfileHeaderView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 280))
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        shareButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIDevice.current.isX ? (SafeArea.iPhoneXInsets.top + 32) : 32)
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(24)
        }
    }
    
    func setupActions() {
        shareButton.addTarget(self, action: #selector(clickShareButton), for: .touchUpInside)
    }
    
    @objc func clickShareButton() {
        AccountManager.logout()
        SVProgressHUD.showInfo(withStatus: "账号已退出")
        let welcomeViewController = ResourceUtil.mainSB().instantiateViewController(withIdentifier: "PassportNavigationController") as! UINavigationController
        UIApplication.shared.delegate?.window?!.rootViewController = welcomeViewController
    }

    func fetchStatsInfo() {
        StatsRequester.fetchStatsInfo { [weak self] (success, dict) in
            if success {
                guard let _ = self, let dictionary = dict as? Dictionary<String, Any> else {return}
                self!.stats = dictionary[kResultData] as! StatsModel
                self!.tableHeaderView.updateUIWithData(self!.stats!)
                self!.tableView.reloadData()
            }
        }
    }
}

extension StatsViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatsGazeWorldCell.self), for: indexPath) as! StatsGazeWorldCell
            cell.updateUIWithData(stats!)
            return cell
        } else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatsPoetryDistanceCell.self), for: indexPath) as! StatsPoetryDistanceCell
            cell.updateUIWithData(stats!)
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
}

