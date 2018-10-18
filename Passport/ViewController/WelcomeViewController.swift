//
//  WelcomeViewController.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let videoView = KEPWelcomeVideoView.init(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(videoView)
        self.navigationController?.navigationBar.isHidden = true
        let loginView = ResourceUtil.loginSB().instantiateViewController(withIdentifier: "LoginViewController").view
        self.view.addSubview(loginView!)
        
    }
    


//    @IBAction func connectKeep(_ sender: Any) {
//        let viewModel = TripDetailViewModel()
//        let vc = TripDetailViewController.init(viewModel: viewModel)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func connectKeep(_ sender: Any) {
        PHPersonHandler.sharedInstance()
        PhotoScanProcessor.getHashList()
    }
    
    @IBAction func startScan(_ sender: Any) {
        
        let photoListVC: PhotoListTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoListTableViewController") as! PhotoListTableViewController
        photoListVC.datas = PhotoScanProcessor.getAuthorized(view: self.view)
        photoListVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(photoListVC, animated: true)
        
    }
}
