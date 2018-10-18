//
//  TripsHeaderView.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/18.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation

class TripsHeaderView: UIView {
    let tripDayCountDescLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_fontForKeep(withSize: 16)
        $0.text = "旅行天数"
    }
    let tripDayCountValueLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x584F60)
        $0.font = UIFont.kep_fontForKeep(withSize: 60)
    }
    let tripCountryCountDescLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_fontForKeep(withSize: 16)
        $0.text = "旅行国家"
    }
    let tripCountryCountValueLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x584F60)
        $0.font = UIFont.kep_fontForKeep(withSize: 60)
    }
    let longestTripDayCountDescLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_fontForKeep(withSize: 16)
        $0.text = "最长出行"
    }
    let longestTripDayCountValueLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x584F60)
        $0.font = UIFont.kep_fontForKeep(withSize: 60)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(tripDayCountDescLabel)
        addSubview(tripDayCountValueLabel)
        addSubview(tripCountryCountDescLabel)
        addSubview(tripCountryCountValueLabel)
        addSubview(longestTripDayCountDescLabel)
        addSubview(longestTripDayCountValueLabel)
        tripDayCountValueLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(52)
            make.centerX.equalToSuperview()
            make.height.equalTo(66)
        }
        tripDayCountDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tripDayCountValueLabel.snp.bottom)
            make.centerX.equalTo(tripDayCountValueLabel)
            make.height.equalTo(23)
        }
        
        tripCountryCountValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tripDayCountDescLabel.snp.bottom).offset(22)
            make.centerX.equalToSuperview().offset(103)
            make.height.equalTo(40)
        }
        
        tripCountryCountDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tripCountryCountValueLabel.snp.bottom)
            make.centerX.equalTo(tripCountryCountValueLabel)
            make.height.equalTo(23)
        }
        
        longestTripDayCountValueLabel.snp.makeConstraints { (make) in
            
        }
        
        longestTripDayCountDescLabel.snp.makeConstraints { (make) in
            
        }
        
    }
    
    func updateUIWithData(_ trips: TripsModel) {
        
    }
}
