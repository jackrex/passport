//
//  TripsClipCell.swift
//  Passport
//
//  Created by xiongshuangquan on 2018/10/18.
//  Copyright © 2018年 Passport. All rights reserved.
//

import Foundation

class TripsClipTagView: UIView {
    
    let label = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_regularPingFangSC(withSize: 12)
        $0.text = "高光旅程"
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
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

@objc public class TripsClipCell: UITableViewCell {
    
    let containView = UIView().then {
        $0.backgroundColor = UIColor.kep_color(fromHex: 0x333333, alpha: 0.3)
        $0.layer.cornerRadius = 3
        $0.layer.masksToBounds = true
    }
    
    let bgImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let descLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_SFProDisplaySemibold(withSize: 12)
    }
    let cityTitleLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.kep_SFProDisplaySemibold(withSize: 30)
    }
    let tagView = TripsClipTagView.init(frame: CGRect(x: 0, y: 0, width: 78, height: 21)).then {
        $0.layer.cornerRadius = 2
        $0.layer.masksToBounds = true
        $0.setGradientLayer([UIColor.kep_color(fromHex: 0x9564C3)!.cgColor,UIColor.kep_color(fromHex: 0xC25FA7)!.cgColor], locations: [NSNumber.init(value: 0),NSNumber.init(value: 1)], start: .zero, end: CGPoint(x: 1, y: 1))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    func setupSubviews() {
        selectionStyle = .none
        contentView.addSubview(containView)
        containView.addSubview(bgImageView)
        containView.addSubview(descLabel)
        containView.addSubview(cityTitleLabel)
        containView.addSubview(tagView)
        containView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(125)
        }
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        descLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(26)
            make.left.equalToSuperview().offset(33)
            make.height.equalTo(17)
        }
        cityTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom)
            make.left.equalTo(descLabel)
            make.height.equalTo(42)
        }
        tagView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-9)
            make.height.equalTo(21)
            make.width.equalTo(78)
        }
    }
    
    @objc public func updateUI(tripsClip: TripsClipModel!) {
        let startDate = convertToDate(tripsClip.beginDate)
        let endDate = convertToDate(tripsClip.endDate)
        let calendar = Calendar.init(identifier: .gregorian)
        let comp = calendar.dateComponents([.day], from: startDate, to: endDate)
        tagView.isHidden = comp.day! < 5
        descLabel.text = "\(comp.day!)日行程"
        cityTitleLabel.text = tripsClip.cnCountry + tripsClip.cnCity
        if let image = tripsClip.cacheImage {
            self.bgImageView.image = image
        } else {
            if tripsClip.pic.characters.count > 0 {
                bgImageView.sd_setImage(with: URL(string: tripsClip.pic))
            } else {
                DispatchQueue.global().async {
                    PhotoScanProcessor.getRandomPhoto(endDate) { [weak self](image) in
                        self!.bgImageView.image = image
                        tripsClip.cacheImage = image
                    }
                }
            }
        }
    }
    
    func convertToDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.date(from: string)
        return date!
    }
}
