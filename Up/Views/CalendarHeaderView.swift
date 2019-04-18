//
//  CalendarHeaderView.swift
//  Up
//
//  Created by Sunny Ouyang on 4/17/19.
//

import Foundation
import JTAppleCalendar


class CalendarHeaderView: JTAppleCollectionReusableView {
    
    //MARK: OUTLETS
    var monthLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    func setUpView(month: String) {
        self.addSubview(monthLabel)
        monthLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        monthLabel.text = month
    }
    
    
    
}
