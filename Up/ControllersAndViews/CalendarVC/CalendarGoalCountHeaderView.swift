//
//  CalendarGoalCountTableViewCell.swift
//  Up
//
//  Created by Tony Cioara on 4/28/19.
//

import Foundation
import UIKit

class CalendarGoalCountHeaderView: UIView {
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Style.Colors.Palette01.gunMetal
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(dateString: String, goalCount: Int) {
        
        dateLabel.isHidden = false
        bubbleView.isHidden = false
        goalLabel.isHidden = false
        infoLabel.isHidden = true
        
        let components = dateString.split(separator: "/")
        let month = months[Int(String(components[1]))! - 1]
        let day = String(Int(String(components[0]))!)
        let dateStr = month + " " + day + ", " + String(components[2])
        dateLabel.text = dateStr
        var goalStr = "Completed " + String(goalCount) + " task"
        if goalCount > 1 {
            goalStr += "s"
        }
//        let text = dateStr + " - " + goalStr
       goalLabel.text = goalStr
    }
    
    func setup(text: String) {
        dateLabel.isHidden = true
        bubbleView.isHidden = true
        goalLabel.isHidden = true
        infoLabel.isHidden = false
        infoLabel.text = text
    }
    
    private func setupViews() {
        
        [dateLabel, goalLabel, bubbleView, infoLabel].forEach { (view) in
            self.addSubview(view)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        bubbleView.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.left.equalTo(dateLabel.snp.right).offset(6)
            make.width.height.equalTo(8)
        }
        
        goalLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(dateLabel.snp.bottom)
            make.left.equalTo(bubbleView.snp.right).offset(6)
            make.right.lessThanOrEqualToSuperview().inset(20)
            make.top.equalTo(dateLabel.snp.top)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.Colors.Palette01.pureWhite
        label.numberOfLines = 2
        label.font = Style.Fonts.bold20
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.Colors.Palette01.pureWhite
        label.font = Style.Fonts.bold18
        label.numberOfLines = 2
        return label
    }()
    
    let goalLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.Colors.Palette01.pureWhite
        label.font = Style.Fonts.bold20
        label.numberOfLines = 2
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = Style.Colors.Palette01.mainBlue
        view.clipsToBounds = true
        return view
    }()
}
