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
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var countryListView: UIView!
    @IBOutlet weak var percentMemoryLabel: UILabel!
    
    public var progressView: KPESchduleConfirmProgressView!
    public var hashCityList: [String: HashCityData] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "hash", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let dataDict = try JSONDecoder().decode(HashCity.self, from: data)
                for data in dataDict.data {
                    hashCityList.updateValue(data, forKey: data.hash)
                }
            } catch {
                // handle error
            }
        }
        
        progressView = KPESchduleConfirmProgressView.init(frame: CGRect.init(x: 0, y: 0, width: 128, height: 128))
        progressView.alpha = 0
        progressContainerView.addSubview(progressView)
        
        bottomBtn.layer.cornerRadius = 25
        bottomBtn.clipsToBounds = true
        
        progressView.animationDidEnd = ({
            
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromLeft, animations: {
                self.topMottoLabel.alpha = 1
                self.bottomBtn.alpha = 1
                
                self.timeReverseLabel.alpha = 0
                
            }) { (finished) in
                
            }
        })
        
        topMottoLabel.alpha = 0
        bottomBtn.alpha = 1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {


    }
    
    public func startScan() {
      
//        PHPersonHandler.sharedInstance()
//        PhotoScanProcessor.getHashList()
    }
    
    @IBAction func openJourney(_ sender: Any) {
        progressView.alpha = 1
        progressView.startAnimation()

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            
            timer.invalidate()
        }
    }
    

}
