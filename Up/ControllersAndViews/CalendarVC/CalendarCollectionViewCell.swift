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
                backgroundColor = .gray
            } else {
                backgroundColor = cellBackgroundColor
            }
        }
    }
    
    var cellBackgroundColor = UIColor.white
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Style.Colors.Palette01.gunMetal
        label.font = Style.Fonts.semibold18
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
    
    func setup(day: String, goalCount: Int) {
        dayLabel.text = day
        self.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        adjustBackgroundColor(goalCount: goalCount)
    }
    
    private func adjustBackgroundColor(goalCount: Int) {
        if goalCount == 0 {
            cellBackgroundColor = Style.Colors.Palette01.pureWhite
        } else if goalCount < 2 {
            cellBackgroundColor = Style.Colors.calendarShade1
        } else if goalCount < 5 {
            cellBackgroundColor = Style.Colors.calendarShade2
        } else if goalCount < 10 {
            cellBackgroundColor = Style.Colors.calendarShade3
        } else if goalCount < 15 {
            cellBackgroundColor = Style.Colors.calendarShade4
        } else {
            cellBackgroundColor = Style.Colors.calendarShade5
        }
        self.backgroundColor = cellBackgroundColor
    }
}
