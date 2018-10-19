//
//  StatsProfileHeaderView.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation
import UIKit
import Then

class StatsProfileHeaderView: UIView {
    let mapImageView = UIImageView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x333333, alpha: 0.5)
        $0.contentMode = .scaleAspectFill
        $0.sd_setImage(with: URL(string: "https://api.mapbox.com/styles/v1/keepintl/cjl4lzhzv8mqd2sqm492y15ws/static/120,0,3/800x600?access_token=pk.eyJ1Ijoia2VlcGludGwiLCJhIjoiY2pncTRxY2VhMzF6YzJ5bzhsdGFpM21iNiJ9.HD758SGS8F21IA6YnQvoJg"))
        $0.clipsToBounds = true
    }
    let avatarImageView = UIImageView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x333333, alpha: 0.5)
        $0.layer.cornerRadius = 42
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 3
        $0.layer.masksToBounds = true
    }
    let userNameLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x333333)
        $0.font = UIFont.kep_SFProDisplaySemibold(withSize: 21)
    }
    let ageLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_fontForKeep(withSize: 14)
    }
    
    let tagImageView = UIImageView().then {
        $0.image = UIImage(named: "profile_tag")
        $0.contentMode = .scaleAspectFit
    }
    
    var originAcceleration: CMAcceleration?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        shakeMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(mapImageView)
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        addSubview(ageLabel)
        addSubview(tagImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.width.equalTo(84)
            make.height.equalTo(84)
            make.centerY.equalTo(160)
            make.centerX.equalToSuperview()
        }
        
        mapImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(avatarImageView.snp.centerY)
        }
        
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        ageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        tagImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.right.equalTo(-20)
            make.width.height.equalTo(84)
        }
    }
    
    func updateUIWithData(_ stats: StatsModel) {
        userNameLabel.text = stats.profile.username
        ageLabel.text = stats.profile.birthday
        avatarImageView.sd_setImage(with: URL(string: stats.profile.avatar))
        DateUtil.increaseDate(stats.profile.birthday) { (time) in
            self.ageLabel.text = time + " 岁"
        }
    }
    
    func shakeMap() {
        
//        LYMotionManager.default()?.startAccelerometerUpdates(handler: {(acceleration, error) in
//            if (self.originAcceleration == nil) {
//                self.originAcceleration = acceleration
//            }
//
//            self.mapImageView.layer.transform = CATransform3DMakeRotation(CGFloat(10 * M_PI / 180), CGFloat(acceleration.x) - CGFloat(self.originAcceleration!.x), CGFloat(acceleration.y) - CGFloat(self.originAcceleration!.y),CGFloat(acceleration.z) - CGFloat(self.originAcceleration!.z))
//        })
    }
    
    func updateContentOffsetY(_ offsetY: CGFloat) {
        mapImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(offsetY)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(avatarImageView.snp.centerY)
        }
    }
}
