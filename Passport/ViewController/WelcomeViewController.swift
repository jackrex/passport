//
//  WelcomeViewController.swift
//  Passport
//
//  Created by jackrex on 2018/10/17.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, ScanViewDelegate {

    let videoView = KEPWelcomeVideoView.init(frame: UIScreen.main.bounds)
    let scanView = ResourceUtil.loginSB().instantiateViewController(withIdentifier: "ScanPicViewController") as! ScanPicViewController
    let prepareView = ResourceUtil.loginSB().instantiateViewController(withIdentifier: "PrepareViewController") as! PrepareViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(videoView)
        self.navigationController?.navigationBar.isHidden = true

        self.addChild(scanView)
        self.addChild(prepareView)
        scanView.delegate = self
        self.view.addSubview(scanView.view)
        self.view.addSubview(prepareView.view)
        self.scanView.view.alpha = 1
        self.prepareView.view.alpha = 0
        
        PhotoScanProcessor.getAuthorized(view: self.view) {
            self.prepareView.processData()
        }

    }
    
    func loginFinish() {
        PhotoScanProcessor.getAuthorized(view: self.view) {
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromLeft, animations: {
            }) { (finished) in
                UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromLeft, animations: {
                    self.scanView.view.alpha = 1
                }) { (finished) in
                }
            }
        }
 
    }
    

    
    func startScan() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromLeft, animations: {
            self.scanView.view.alpha = 0
        }) { (finished) in
            self.scanView.view.removeFromSuperview()
            self.scanView.removeFromParent()
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromLeft, animations: {
                self.prepareView.view.alpha = 1
            }) { (finished) in
                self.prepareView.startCalculate()
            }
        }

    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
