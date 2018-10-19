//
//  StatsDataInsightCell.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation

class StatsDataInsightCardView: UIView {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    let valueLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_fontForKeep(withSize: 36)
    }
    let unitLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(unitLabel)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(14)
            make.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.centerY.equalTo(iconImageView)
        }
        valueLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        unitLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(valueLabel).offset(-5)
            make.left.equalTo(valueLabel.snp.right).offset(7)
        }
    }
}

class StatsDataInsightCell: StatsBaseCell {
    let tripsCountView = StatsDataInsightCardView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0xC77A7A)
    }
    let beenToCityView = StatsDataInsightCardView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0xCFC276)
    }
    let totalStepsView = StatsDataInsightCardView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x7876CF)
    }
    let totalDistanceView = StatsDataInsightCardView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x71C7AC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    func setupSubviews() {
        titleLabel.text = "数据大观园"
        descLabel.text = "个人旅行数据汇总"
        containView.addSubview(tripsCountView)
        containView.addSubview(beenToCityView)
        containView.addSubview(totalStepsView)
        containView.addSubview(totalDistanceView)
        tripsCountView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalTo(containView.snp.centerX).offset(-2)
            make.top.equalTo(descLabel.snp.bottom).offset(12)
            make.height.equalTo(103)
        }
        beenToCityView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.left.equalTo(containView.snp.centerX).offset(2)
            make.top.equalTo(tripsCountView)
            make.height.equalTo(103)
        }
        totalStepsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(tripsCountView)
            make.top.equalTo(tripsCountView.snp.bottom).offset(6)
            make.height.equalTo(103)
        }
        totalDistanceView.snp.makeConstraints { (make) in
            make.left.right.equalTo(beenToCityView)
            make.top.equalTo(beenToCityView.snp.bottom).offset(6)
            make.height.equalTo(103)
        }
    }
    
    func updateUIWithData(_ stats: StatsModel) {
        tripsCountView.iconImageView.image = UIImage(named: "journeys")
        tripsCountView.titleLabel.text = "旅程数"
        tripsCountView.valueLabel.text = "\(stats.dataInsight.tripsCount)"
        tripsCountView.unitLabel.text = "个"
        
        beenToCityView.iconImageView.image = UIImage(named: "cities")
        beenToCityView.titleLabel.text = "去过的城市"
        beenToCityView.valueLabel.text = "\(stats.dataInsight.beenToCity)"
        beenToCityView.unitLabel.text = "个"
        
        totalStepsView.iconImageView.image = UIImage(named: "steps2")
        totalStepsView.titleLabel.text = "行走步数"
        if stats.dataInsight.totalSteps > 10000 {
            totalStepsView.valueLabel.text = "\(stats.dataInsight.totalSteps/10000)"
            totalStepsView.unitLabel.text = "万步"
        } else {
            totalStepsView.valueLabel.text = "\(stats.dataInsight.totalSteps)"
            totalStepsView.unitLabel.text = "步"
        }
        
        totalDistanceView.iconImageView.image = UIImage(named: "distance")
        totalDistanceView.titleLabel.text = "出行距离"
        if stats.dataInsight.totalDistance > 10000 {
            totalDistanceView.valueLabel.text = "\(stats.dataInsight.totalDistance/10000)"
            totalDistanceView.unitLabel.text = "万公里"
        } else {
            totalDistanceView.valueLabel.text = "\(stats.dataInsight.totalDistance)"
            totalDistanceView.unitLabel.text = "公里"
        }
       
    }
}
