//
//  PrepareViewController.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

class PrepareViewController: UIViewController {

    @IBOutlet weak var topMottoLabel: UILabel!
    @IBOutlet weak var timeReverseLabel: UILabel!
    @IBOutlet weak var progressView: KCircleView!
    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var countryListView: UIView!
    @IBOutlet weak var percentMemoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomBtn.layer.cornerRadius = 25
        bottomBtn.clipsToBounds = true
        
        progressView.duration = 0
        progressView.strokeColor = UIColor.blue
        progressView.closedIndicatorBackgroundStrokeColor = UIColor.init(rgb: 0xD0CDD2)
        progressView.fillColor = UIColor.green
        progressView.coverWidth = 5.0
        progressView.loadIndicator()
        
        
        topMottoLabel.alpha = 0
        bottomBtn.alpha = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {


    }
    
    public func startScan() {
        
        for i in 0..<10 {
            progressView.update(withTotalBytes: 1, downloadedBytes: CGFloat(i)/10, animated: true)
            sleep(1)
        }
        
//        PHPersonHandler.sharedInstance()
//        PhotoScanProcessor.getHashList()
    }
    
    @IBAction func openJourney(_ sender: Any) {

        UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromLeft, animations: {
            self.topMottoLabel.alpha = 1
            self.bottomBtn.alpha = 1
            
            self.timeReverseLabel.alpha = 0
            
        }) { (finished) in
           
        }
   
        
//        let photoListVC: PhotoListTableViewController = ResourceUtil.mainSB().instantiateViewController(withIdentifier: "PhotoListTableViewController") as! PhotoListTableViewController
//        photoListVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(photoListVC, animated: true)
    }
    

}
