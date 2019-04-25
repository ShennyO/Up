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
        formatter.timeStyle = .medium
        self.backgroundColor = Style.Colors.Palette01.gunMetal
        descriptionLabel.text = goal.goalDescription
        timeLabel.text = formatter.string(from: goal.completionDate!)
    }
    
    func setupViews() {
        [descriptionLabel, timeLabel].forEach { (view) in
            self.addSubview(view)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview().inset(8)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(8)
            make.top.equalTo(descriptionLabel.snp.bottom)
        }
    }
    
    let iconView: UIImageView = {
        let imageView = UIImageView()
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
