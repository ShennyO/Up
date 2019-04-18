//
//  CalendarCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/17/19.
//

import Foundation
import JTAppleCalendar


class CalendarCell: JTAppleCell {
    
    //MARK: OUTLETS
    var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5
        containerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        containerView.layer.borderWidth = 2
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.07
        containerView.layer.shadowRadius = 5
        return containerView
    }()
    
    
    
    func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//        self.addSubview(containerView)
//        containerView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(5)
//            make.bottom.equalToSuperview().offset(-5)
//            make.left.equalToSuperview().offset(5)
//            make.right.equalToSuperview().offset(-5)
//        }
    }
    
}
