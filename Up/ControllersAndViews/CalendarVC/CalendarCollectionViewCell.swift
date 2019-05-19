//
//  CalendarCollectionViewCellID.swift
//  Up
//
//  Created by Tony Cioara on 4/19/19.
//

import Foundation
import UIKit

// The cell of the outer collection view (container for smallCollectionView)
class CalendarCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool{
        didSet{
            if isSelected == true {
                backgroundColor = Style.Colors.Palette01.darkBlue
                dayLabel.textColor = Style.Colors.Palette01.pureWhite
            } else {
                backgroundColor = cellBackgroundColor
                dayLabel.textColor = cellTextColor
            }
        }
    }
    
    var cellBackgroundColor = Style.Colors.Palette01.pureWhite
    var cellTextColor = Style.Colors.Palette01.gunMetal
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.Colors.Palette01.gunMetal
        label.font = Style.Fonts.bold18
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
        backgroundColor = Style.Colors.Palette01.pureWhite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var goalCount = 0
    
    func setup(day: String, goalCount: Int, isEnabled: Bool) {
        dayLabel.text = day
        self.goalCount = goalCount
        
        self.addSubview(dayLabel)
        
        dayLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        if isEnabled == true {
            self.isUserInteractionEnabled = true
            adjustBackgroundColor(addition: nil)
        } else {
            self.isUserInteractionEnabled = false
            self.backgroundColor = Style.Colors.Palette01.pureWhite
            self.dayLabel.textColor = .lightGray
        }
    }
    
    func adjustBackgroundColor(addition: Int?) {
        if let addition = addition {
            goalCount += addition
        }
        cellTextColor = Style.Colors.Palette01.pureWhite
        if goalCount == 0 {
            cellBackgroundColor = Style.Colors.Palette01.pureWhite
            cellTextColor = Style.Colors.Palette01.gunMetal
        } else if goalCount <= 2 {
            cellBackgroundColor = Style.Colors.calendarShade1
        } else if goalCount <= 5 {
            cellBackgroundColor = Style.Colors.calendarShade2
        } else if goalCount <= 9 {
            cellBackgroundColor = Style.Colors.calendarShade3
        } else if goalCount <= 14 {
            cellBackgroundColor = Style.Colors.calendarShade4
        } else {
            cellBackgroundColor = Style.Colors.calendarShade5
        }
        if self.isSelected == false {
            self.backgroundColor = cellBackgroundColor
            dayLabel.textColor = cellTextColor
        }
        
    }
    
}
