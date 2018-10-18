//
//  StatsPoetryDistanceCell.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation


class StatsFarthestPlaceView: UIView {
    let photoImageView = UIImageView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x333333, alpha: 0.3)
    }
    let dateLabel = UILabel().then {
        $0.font = UIFont.kep_regularPingFangSC(withSize: 14)
        $0.textColor = UIColor.kep_color(fromHex: 0x333333)
    }
    let fromLabel = UILabel().then {
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 13)
        $0.textColor = UIColor.kep_color(fromHex: 0x333333)
    }
    let toLabel = UILabel().then {
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 13)
        $0.textColor = UIColor.kep_color(fromHex: 0x333333)
    }
    let earthImageView = UIImageView().then {
        $0.image = UIImage(named: "earth")
    }
    let distanceLabel = UILabel().then {
        $0.font = UIFont.kep_regularPingFangSC(withSize: 11)
        $0.textColor = UIColor.white
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x24C789)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(photoImageView)
        addSubview(dateLabel)
        addSubview(fromLabel)
        addSubview(toLabel)
        addSubview(earthImageView)
        addSubview(distanceLabel)
        photoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(22)
            make.width.height.equalTo(142)
            make.left.equalToSuperview().offset(24)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(photoImageView.snp.bottom).offset(12)
            make.centerX.equalTo(photoImageView)
        }
        earthImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(122)
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-24)
        }
        fromLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(earthImageView.snp.top).offset(-4)
            make.height.equalTo(19)
            make.centerX.equalTo(earthImageView)
        }
        toLabel.snp.makeConstraints { (make) in
            make.top.equalTo(earthImageView.snp.bottom).offset(4)
            make.centerX.equalTo(earthImageView)
            make.height.equalTo(19)
        }
        distanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(toLabel.snp.bottom).offset(5)
            make.centerX.equalTo(toLabel)
            make.width.equalTo(90)
            make.height.equalTo(20)
        }
    }
}

class StatsFarthestDayView: UIView {
    let descLabel = UILabel().then {
        $0.text = "走过的最远的一天"
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    let photoImageView = UIImageView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x333333, alpha: 0.3)
    }
    let dateLabel = UILabel().then {
        $0.font = UIFont.kep_regularPingFangSC(withSize: 14)
        $0.textColor = UIColor.kep_color(fromHex: 0x333333)
    }
    let iconImageView = UIImageView().then {
        $0.image = UIImage(named: "steps")
    }
    let stepTitleLabel = UILabel().then {
        $0.text = "一日步数"
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 14)
        $0.textColor = UIColor.kep_color(fromHex: 0x24C789)
    }
    let stepCountLabel = UILabel().then {
        $0.font = UIFont.kep_fontForKeep(withSize: 56)
        $0.textColor = UIColor.kep_color(fromHex: 0x24C789)
        $0.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(descLabel)
        addSubview(photoImageView)
        addSubview(dateLabel)
        addSubview(iconImageView)
        addSubview(stepTitleLabel)
        addSubview(stepCountLabel)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(17)
        }
        photoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(28)
            make.width.height.equalTo(142)
            make.left.equalToSuperview().offset(24)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(photoImageView.snp.bottom).offset(12)
            make.centerX.equalTo(photoImageView)
        }
        stepCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(photoImageView.snp.right)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(62)
            make.centerY.equalToSuperview()
        }
        stepTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(stepCountLabel).offset(10)
            make.bottom.equalTo(stepCountLabel.snp.top).offset(-13)
            make.height.equalTo(20)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(stepTitleLabel.snp.left).offset(-6)
            make.centerY.equalTo(stepTitleLabel)
            make.width.height.equalTo(16)
        }
    }
}

class StatsPoetryDistanceCell: UITableViewCell {
    let containView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    let titleLabel = UILabel().then {
        $0.text = "诗和远方"
        $0.textColor = UIColor.kep_color(fromHex: 0x333333)
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 16)
    }
    let descLabel = UILabel().then {
        $0.text = "到过的世界上最遥远的地方、拍下的风景和见过的人"
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    
    let farthestPlaceView = StatsFarthestPlaceView()
    let farthestDayView = StatsFarthestDayView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    func setupSubviews() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.kep_color(fromHex: 0xF8F8F8)
        contentView.addSubview(containView)
        containView.addSubview(titleLabel)
        containView.addSubview(descLabel)
        containView.addSubview(farthestPlaceView)
        containView.addSubview(farthestDayView)
        containView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(11)
            make.leadingMargin.equalTo(11)
            make.trailingMargin.equalTo(-11)
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(17)
            make.leadingMargin.equalTo(11)
            make.trailingMargin.equalTo(-11)
            make.height.equalTo(23)
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leadingMargin.equalTo(11)
            make.trailingMargin.equalTo(-11)
            make.height.equalTo(17)
        }
        farthestPlaceView.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(212)
        }
        
        farthestDayView.snp.makeConstraints { (make) in
            make.top.equalTo(farthestPlaceView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(231)
        }
    }
    
    func updateUIWithData(_ stats: StatsModel) {
        farthestPlaceView.dateLabel.text = formatDateString(stats.poetryDistance.day)
        farthestPlaceView.fromLabel.text = stats.poetryDistance.from.city
        farthestPlaceView.toLabel.text = stats.poetryDistance.to.city
        farthestPlaceView.distanceLabel.text = stats.poetryDistance.distance
        farthestDayView.dateLabel.text = formatDateString(stats.poetryDistance.farthestWalkedDay.day)
        farthestDayView.stepCountLabel.text = stats.poetryDistance.farthestWalkedDay.steps
    }
    
    func formatDateString(_ string: String) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter .date(from: string)
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date!)
    }
}