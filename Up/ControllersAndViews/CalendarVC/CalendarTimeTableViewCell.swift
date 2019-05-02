//
//  CalendarTimeTableViewCell.swift
//  Up
//
//  Created by Tony Cioara on 5/1/19.
//

import Foundation
import UIKit

class CalendarTimeTableViewCell: UITableViewCell {
    
    func setup(time: Int) {
        setupViews()
//        Create formatter for date-string conversion
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        self.backgroundColor = Style.Colors.Palette01.gunMetal
        
//        Format time for display
        var labelText = ""
        if time == 0 {
            labelText = String(time + 12)
        } else if time >= 13 {
            labelText = String(time - 12)
        } else {
            labelText = String(time)
        }
        
        if time < 12 {
            labelText += " AM "
        } else {
            labelText += " PM "
        }
        
        timeLabel.text = labelText
    }
    
    private func setupViews() {
        
        self.addSubview(timeLabel)
        
        //         * topContainerView
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.bottom.top.equalToSuperview().inset(16)
        }
    }
    
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
