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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
