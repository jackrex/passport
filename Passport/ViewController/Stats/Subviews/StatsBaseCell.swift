//
//  StatsBaseCell.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/18.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation

class StatsBaseCell: UITableViewCell {
    public let containView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    public let titleLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x333333)
        $0.font = UIFont.kep_SFProTextSemibold(withSize: 16)
    }
    public let descLabel = UILabel().then {
        $0.textColor = UIColor.kep_color(fromHex: 0x999999)
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
    }
    
    public let shareButton = UIButton.init(type: UIButton.ButtonType.custom).then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x24C789)
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.setTitle("分享足迹", for: .normal)
        $0.titleLabel?.font = UIFont.kep_regularPingFangSC(withSize: 11)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.kep_color(fromHex: 0xF8F8F8)
        contentView.addSubview(containView)
        containView.addSubview(titleLabel)
        containView.addSubview(descLabel)
        containView.addSubview(shareButton)
        containView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
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
        shareButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(11)
            make.right.equalToSuperview().offset(-22)
            make.width.equalTo(80)
            make.height.equalTo(28)
        }
    }
}
