//
//  StatsGazeWorldCell.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/17.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation
import UIKit
import Then

extension String {
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
}

class StatsGazeWorldCardView: UIView {
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    let descLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_SFProTextRegular(withSize: 13)
    }
    let valueLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 30)
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
        backgroundColor = UIColor.kep_color(fromHex: 0x333333, alpha: 0.3)
        addSubview(imageView)
        addSubview(descLabel)
        addSubview(valueLabel)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.centerX.equalToSuperview()
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY)
            make.centerX.equalToSuperview()
        }
    }
}

class StatsGazeWorldMapView: UIView {
    
    let nameList = ["亚洲","欧洲","南美洲","北美洲","大洋洲","非洲","南极洲"]
    let nameCodeMap = ["AS":"亚洲","EU":"欧洲","SA":"南美洲","NA":"北美洲","OC":"大洋洲","AF":"非洲"]
    let continentImages = ["Asia","Europe","SouthAmerica","NorthAmerica","Ocenia","Africa"]
    
    let nameListView = UIView()
    let mapStatusView = UIImageView().then {
        $0.image = UIImage(named: "BG")
        $0.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(mapStatusView)
        addSubview(nameListView)
        nameListView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-12)
            make.leadingMargin.equalTo(11)
            make.trailingMargin.equalTo(-11)
            make.height.equalTo(21)
        }
        mapStatusView.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameListView.snp.top).offset(-12)
            make.top.equalToSuperview()
            make.leadingMargin.equalTo(11)
            make.trailingMargin.equalTo(-11)
        }
        var leftMargin: CGFloat = 10.0
        for name in nameList {
            // 名字
            let nameLabel = UILabel()
            nameLabel.text = name
            nameLabel.textColor = UIColor.kep_color(fromHex: 0xEDEDED)
            nameLabel.font = UIFont.kep_SFProDisplaySemibold(withSize: 12)
            nameListView.addSubview(nameLabel)
            let nameWidth = name.ga_widthForComment(fontSize: 12, height: 21)
            nameLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(leftMargin)
                make.height.equalToSuperview()
                make.width.equalTo(nameWidth)
            }
            leftMargin = leftMargin + nameWidth + 10
            // 图片
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            mapStatusView.addSubview(imageView);
            imageView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func updateUIWithData(_ stats: StatsModel) {
        for idx in 0 ..< nameList.count {
            if let label = nameListView.subviews[idx] as? UILabel {
                for continent in stats.gazeWorld.continents {
                    let name = nameCodeMap[continent]
                    if name == label.text! {
                        label.textColor = UIColor.kep_color(fromHex: 0x24C789)
                        if let imageView = mapStatusView.subviews[idx] as? UIImageView {
                            imageView.image = UIImage(named: continentImages[idx])
                        }
                    }
                }
            }
        }
    }
}

class StatsGazeWorldCell: StatsBaseCell {
    let countryView = StatsGazeWorldCardView().then {
        $0.descLabel.text = "涉足国家"
    }
    let unlockView = StatsGazeWorldCardView().then {
        $0.descLabel.text = "世界迷雾解锁"
    }
    let mapView = StatsGazeWorldMapView().then {
        $0.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    func setupSubviews() {
        titleLabel.text = "凝视世界"
        descLabel.text = "去过的国家、解锁的大洲"
        containView.addSubview(countryView)
        containView.addSubview(unlockView)
        containView.addSubview(mapView)
        countryView.snp.makeConstraints { (make) in
            make.leadingMargin.equalTo(11)
            make.top.equalTo(descLabel.snp.bottom).offset(8)
            make.right.equalTo(self.snp.centerX).offset(-5)
            make.height.equalTo(160);
        }
        unlockView.snp.makeConstraints { (make) in
            make.trailingMargin.equalTo(-11)
            make.top.equalTo(descLabel.snp.bottom).offset(8)
            make.left.equalTo(self.snp.centerX).offset(5)
            make.height.equalTo(160);
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(unlockView.snp.bottom).offset(20)
            make.leadingMargin.equalTo(11)
            make.trailingMargin.equalTo(-11)
            make.bottom.equalToSuperview()
        }
    }
    
    func updateUIWithData(_ stats: StatsModel) {
        countryView.valueLabel.text = String(stats.gazeWorld.countryCount)
        countryView.imageView.image = UIImage(named: "country")
        unlockView.valueLabel.text = stats.gazeWorld.unlockRate
        unlockView.imageView.image = UIImage(named: "mist")
        mapView.updateUIWithData(stats)
    }
}
