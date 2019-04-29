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
    
    func setup(goal: Goal, withTime: Int?) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        self.backgroundColor = Style.Colors.Palette01.gunMetal
        descriptionLabel.text = goal.goalDescription
        
        if goal.duration == 0 {
            iconView.image = #imageLiteral(resourceName: "whiteRectangle")
        } else {
            iconView.image = #imageLiteral(resourceName: "whiteTimeIcon")
        }
        
        if let wt = withTime {
            setupTimeViews()
            var labelText = ""
            if wt == 0 {
                labelText = String(wt + 12)
            } else if wt >= 13 {
                labelText = String(wt - 12)
            } else {
                labelText = String(wt)
            }

            if wt < 12 {
                labelText += " AM "
            } else {
                labelText += " PM "
            }
            timeLabel.text = labelText
        } else {
            removeTimeViews()
        }
    }
    
    private func removeTimeViews() {
        [topLineView, timeLabel].forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    private func setupTimeViews() {
        self.addSubview(topContainerView)
        [topLineView, timeLabel].forEach { (view) in
            topContainerView.addSubview(view)
        }
        
        topContainerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomContainerView.snp.top)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(lineView.snp.centerX)
            make.centerY.equalToSuperview()
        }
        
        topLineView.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.left.equalTo(timeLabel.snp.right).offset(16)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(0.5)
        }
    }
    
    private func setupViews() {
        
        [bottomContainerView, lineView].forEach { (view) in
            self.addSubview(view)
        }
        
        [descriptionLabel, iconView, checkmarkView].forEach { (view) in
            bottomContainerView.addSubview(view)
        }
        
        bottomContainerView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(0.5)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(16)
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
            make.top.bottom.equalToSuperview()
        }
    }
    
    let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.gunMetal
        return view
    }()
    
    let topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.gunMetal
        return view
    }()
    
    let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Style.Colors.Palette01.gunMetal
        return imageView
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.pureWhite
        return view
    }()
    
    let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "checkMark")
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Style.Fonts.bold15
        label.numberOfLines = 0
        label.textColor = Style.Colors.Palette01.pureWhite
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = Style.Fonts.bold15
        label.textColor = Style.Colors.Palette01.pureWhite
        label.backgroundColor = Style.Colors.Palette01.gunMetal
        return label
    }()
    
    let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.pureWhite
        return view
    }()
    
    
}
