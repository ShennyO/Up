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
            clockIconView.isHidden = true
            boxView.isHidden = false
        } else {
            clockIconView.isHidden = false
            boxView.isHidden = true
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
        timeLabel.removeFromSuperview()
    }
    
    private func setupTimeViews() {
        self.addSubview(topContainerView)
        topContainerView.addSubview(timeLabel)
        
        topContainerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomContainerView.snp.top)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupViews() {
        
        [bottomContainerView, lineView].forEach { (view) in
            self.addSubview(view)
        }
        
        [descriptionLabel, clockIconView, boxView, checkmarkView].forEach { (view) in
            bottomContainerView.addSubview(view)
        }
        
        bottomContainerView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.width.equalTo(0.5)
        }
        
        clockIconView.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(16)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(clockIconView.snp.height)
        }
        
        boxView.snp.makeConstraints { (make) in
            make.left.equalTo(clockIconView.snp.left).inset(1)
            make.right.equalTo(clockIconView.snp.right).inset(1)
            make.top.equalTo(clockIconView.snp.top).inset(1)
            make.bottom.equalTo(clockIconView.snp.bottom).inset(1)
        }
        
        checkmarkView.snp.makeConstraints { (make) in
            make.left.equalTo(clockIconView.snp.left).inset(8)
            make.right.equalTo(clockIconView.snp.right).inset(8)
            make.top.equalTo(clockIconView.snp.top).inset(8)
            make.bottom.equalTo(clockIconView.snp.bottom).inset(8)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(clockIconView.snp.right).offset(16)
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
    
    let clockIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Style.Colors.Palette01.gunMetal
        imageView.image = #imageLiteral(resourceName: "whiteEmptyTimeIcon")
        return imageView
    }()
    
    let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.gunMetal
        view.layer.borderWidth = 1
        view.layer.borderColor = Style.Colors.Palette01.pureWhite.cgColor
        view.layer.cornerRadius = 3
        return view
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
        label.textAlignment = .center
        label.backgroundColor = Style.Colors.Palette01.mainBlue
        label.layer.borderColor = Style.Colors.Palette01.pureWhite.cgColor
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        return label
    }()
}
