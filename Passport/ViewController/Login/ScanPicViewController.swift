//
//  ScanPicViewController.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

public protocol ScanViewDelegate {
    func startScan()
}

class ScanPicViewController: UIViewController {

    @IBOutlet weak var scanBtn: UIButton!
    public var delegate: ScanViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        scanBtn.layer.cornerRadius = 25
        scanBtn.clipsToBounds = true
        
    }
    
    
    @IBAction func scanClick(_ sender: Any) {
        delegate.startScan()
    }
    
}
