//
//  StatsTomorrowCell.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/18.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation

class StatsLastTripDayView: UIView {
    let descLabel = UILabel().then {
        $0.text = "距上一次旅行已经过去"
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    let valueLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 45)
    }
    let iconImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        backgroundColor = UIColor.kep_color(fromHex: 0x24C789)
        layer.cornerRadius = 3
        layer.masksToBounds = true
        addSubview(descLabel)
        addSubview(valueLabel)
        addSubview(iconImageView)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(27)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(63)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(valueLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(35)
        }
    }
}

class StatsDestinationView: UIView {
    let bgImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    let descLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 12)
    }
    let titleLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_regularPingFangSC(withSize: 30)
    }
    let button = UIButton(type: UIButton.ButtonType.custom).then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x24C789)
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.titleLabel?.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        addSubview(bgImageView)
        addSubview(descLabel)
        addSubview(titleLabel)
        addSubview(button)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(21)
            make.left.equalToSuperview().offset(31)
            make.height.equalTo(17)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom)
            make.left.equalTo(descLabel)
            make.height.equalTo(42)
        }
        button.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-17)
        }
    }
}

class StatsRecommendedDestinationView: UIView {
    let descLabel = UILabel().then {
        $0.text = "推荐目的地"
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    
    let containView = UIView()
    
    let customView = StatsDestinationView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(descLabel)
        addSubview(containView)
        addSubview(customView)
        descLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(17)
        }
        containView.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(11)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(240)
        }
        customView.snp.makeConstraints { (make) in
            make.top.equalTo(containView.snp.bottom)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(110)
        }
    }
    
    func updateUIWithData(_ stats: StatsModel) {
        for idx in 0 ..< stats.tomorrow.recommendedDestination.count {
            let destination: StatsDestination = stats.tomorrow.recommendedDestination[idx] as! StatsDestination
            let destinationView = StatsDestinationView()
            destinationView.bgImageView.sd_setImage(with: URL(string: destination.pic))
            destinationView.descLabel.text = destination.desc
            destinationView.titleLabel.text = destination.city
            destinationView.button.setTitle("加入行程", for: .normal)
            containView.addSubview(destinationView)
            destinationView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(120 * idx)
                make.left.right.equalToSuperview()
                make.height.equalTo(110)
            }
        }
        customView.bgImageView.sd_setImage(with: URL(string: "https://goss.veer.com/creative/vcg/veer/800water/veer-146010524.jpg"))
        customView.descLabel.text = "编写自己的"
        customView.titleLabel.text = "目的地"
        customView.button.setTitle("编辑行程", for: .normal)
    }
}

class StatsTomorrowCell: UITableViewCell {
    let containView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    let titleLabel = UILabel().then {
        $0.text = "明天，你是否会出发"
        $0.textColor = UIColor.kep_color(fromHex: 0x333333)
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 16)
    }
    let descLabel = UILabel().then {
        $0.text = "收拾行囊，憧憬下一场旅程"
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    
    let lastTripDayView = StatsLastTripDayView()
    let recommendedDestinationView = StatsRecommendedDestinationView()
    
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
        containView.addSubview(lastTripDayView)
        containView.addSubview(recommendedDestinationView)
        containView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leadingMargin.equalTo(11)
            make.trailingMargin.equalTo(-11)
            make.bottom.equalToSuperview().offset(-100)
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
        lastTripDayView.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(165)
        }
        recommendedDestinationView.snp.makeConstraints { (make) in
            make.top.equalTo(lastTripDayView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    func updateUIWithData(_ stats: StatsModel) {
        let days = caculDayCountWithString(stats.tomorrow.lastTripDay)
        if days > 30 {
            lastTripDayView.iconImageView.image = UIImage(named: "emoji_stressful_selected")
        } else if days > 10 {
            lastTripDayView.iconImageView.image = UIImage(named: "emoji_smile_selected")
        } else {
            lastTripDayView.iconImageView.image = UIImage(named: "emoji_peaceful_selected")
        }
        lastTripDayView.valueLabel.text = String(days)
        recommendedDestinationView.updateUIWithData(stats)
    }
    
    func caculDayCountWithString(_ string: String) -> Int {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter .date(from: string)
        let calendar = Calendar.init(identifier: .gregorian)
        let comp = calendar.dateComponents([.day], from: date!, to: Date())
        return comp.day!
    }
}
