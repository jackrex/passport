//
//  WelcomeViewController.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
