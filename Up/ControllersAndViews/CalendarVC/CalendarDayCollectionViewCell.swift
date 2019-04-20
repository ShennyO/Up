//
//  MonthCollectionViewCell.swift
//  Up
//
//  Created by Tony Cioara on 4/19/19.
//

import Foundation
import UIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        self.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(indexPath: IndexPath, firstWeekDayOfMonth: Int) {
        
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            isHidden=false
            dateLabel.text="\(calcDate)"
        }
    }
}
