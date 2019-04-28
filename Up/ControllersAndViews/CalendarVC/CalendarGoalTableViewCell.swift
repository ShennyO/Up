//
//  calendarGoalTableViewCell.swift
//  Up
//
//  Created by Tony Cioara on 4/23/19.
//

import Foundation
import UIKit


class CalendarGoalTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(goal: Goal) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        self.backgroundColor = Style.Colors.Palette01.gunMetal
        descriptionLabel.text = goal.goalDescription
        timeLabel.text = formatter.string(from: goal.completionDate!)
        
        if goal.duration == 0 {
            iconView.image = #imageLiteral(resourceName: "whiteRectangle")
        } else {
            iconView.image = #imageLiteral(resourceName: "whiteTimeIcon")
        }
    }
    
    func setupViews() {
        [descriptionLabel, timeLabel, iconView, checkmarkView].forEach { (view) in
            self.addSubview(view)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(iconView.snp.height)
        }
        
        checkmarkView.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.left).inset(6)
            make.right.equalTo(iconView.snp.right).inset(6)
            make.top.equalTo(iconView.snp.top).inset(6)
            make.bottom.equalTo(iconView.snp.bottom).inset(6)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(iconView.snp.right).offset(16)
            make.top.equalToSuperview().inset(8)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(iconView.snp.right).offset(16)
            make.bottom.equalToSuperview().inset(8)
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
    }
    
    let iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "checkMark")
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Style.Fonts.bold15
        label.textColor = Style.Colors.Palette01.pureWhite
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = Style.Fonts.bold15
        label.textColor = Style.Colors.Palette01.pureWhite
        return label
    }()
    
    
}
