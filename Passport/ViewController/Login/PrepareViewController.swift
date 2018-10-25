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
    public var hashList: [String] = []
    public var countries: [String] = []
    public var hashes: [String] = []
    
    public let tabbar: CustomTabBarViewController = ResourceUtil.mainSB().instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        progressView = KPESchduleConfirmProgressView.init(frame: CGRect.init(x: 0, y: 0, width: 128, height: 128))
        progressView.alpha = 0
        progressContainerView.addSubview(progressView)
        
        bottomBtn.layer.cornerRadius = 25
        bottomBtn.clipsToBounds = true
        
        percentMemoryLabel.alpha = 0
        
        progressView.animationDidEnd = ({
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromLeft, animations: {
                self.topMottoLabel.alpha = 1
                self.bottomBtn.alpha = 1
                self.timeReverseLabel.alpha = 0
                
            }) { (finished) in
                
            }
        })
        
        topMottoLabel.alpha = 0
        bottomBtn.alpha = 0
        timeReverseLabel.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {


    }
    
    public func processData() -> Void {
        DispatchQueue.global().async {
            if let path = Bundle.main.path(forResource: "hash", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let dataDict = try JSONDecoder().decode(HashCity.self, from: data)
                    for data in dataDict.data {
                        self.hashCityList.updateValue(data, forKey: data.hash)
                    }
                } catch {
                    // handle error
                    
                }
                
                self.hashList = PhotoScanProcessor.getHashList()
                self.countries = self.mergeHashData()
                print(self.countries)
                
            }
            
            DispatchQueue.main.async {
                
            }
        }
        
    }
    
    func mergeHashData() -> [String] {
        var countries: [String] = []
        for hash in hashList {
            if let cityData = hashCityList[hash] {
                if !countries.contains(cityData.flag) {
                    countries.append(cityData.flag)
                }
                
                if !hashes.contains(cityData.hash) {
                    hashes.append(cityData.hash)
                }
                
            }else {
                continue
            }
            
        }
        return countries
        
    }
    
    @IBAction func openJourney(_ sender: Any) {
        self.navigationController?.present(tabbar, animated: true, completion: {
            
        })
        
    }
    
    public func startCalculate() -> Void {
        timeReverseLabel.alpha = 1
        percentMemoryLabel.alpha = 1
        progressView.alpha = 1
        progressView.startAnimation()
        var i = 1
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            i = i + 1
            if i >= 100 {
                timer.invalidate()
                self.percentMemoryLabel.text = "你踏足过 \(self.countries.count) 个国度 \(self.hashes.count) 座城"
                return
            }
            self.percentMemoryLabel.text = "回忆覆盖度 \(i)%"
            
        }
        
        for index in 0..<countries.count {
            //一排 5 个
            let row = index % 5
            let column = index / 5
            
            let imageView = UIImageView.init(frame: CGRect.init(x: row * (10 + 50), y: column * (5 + 30) , width: 50, height: 30))
            var pic = self.countries[index]
            pic = pic.trimmingCharacters(in: .whitespacesAndNewlines)
            imageView.image = UIImage.init(named: pic)
            imageView.alpha = 0
            imageView.tag = 1000 + index
            self.countryListView.addSubview(imageView)
        }
        
        self.animateFlags(index: 0)
    }
    
    func animateFlags(index: Int) {
        if index >= self.countries.count {
            return
        }
        var i = index
        let timeInterval: Double = 5.0 / Double(countries.count)
        let imageView = self.countryListView.viewWithTag(1000 + index)
        UIView.animate(withDuration: timeInterval, delay: 0, options: .transitionFlipFromLeft, animations: {
            imageView!.alpha = 1
        }) { (finished) in
            i = i + 1
            self.animateFlags(index: i)
        }
    }

}
