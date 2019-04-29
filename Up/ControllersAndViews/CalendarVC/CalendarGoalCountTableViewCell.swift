//
//  CalendarGoalCountTableViewCell.swift
//  Up
//
//  Created by Tony Cioara on 4/28/19.
//

import Foundation
import UIKit

class CalendarGoalCountTableViewCell: UITableViewCell {
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Style.Colors.Palette01.gunMetal
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(dateString: String, goalCount: Int) {
        let components = dateString.split(separator: "/")
        let month = months[Int(String(components[1]))! - 1]
        let day = String(Int(String(components[0]))!)
        let dateStr = month + " " + day + ", " + String(components[2])
        var goalStr = "Completed " + String(goalCount) + " task"
        if goalCount > 1 {
            goalStr += "s"
        }
        let text = dateStr + " - " + goalStr
        titleLabel.text = text
    }
    
    private func setupViews() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview().inset(8)
        }
    }
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.Colors.Palette01.pureWhite
        label.font = Style.Fonts.bold18
        return label
    }()
}
