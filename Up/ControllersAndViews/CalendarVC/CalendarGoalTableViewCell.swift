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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(goal: Goal) {
        self.backgroundColor = .green
    }
}
