//
//  CalendarDayCell.swift
//  Up
//
//  Created by Tony Cioara on 4/18/19.
//

import Foundation
import UIKit

class CalendarDayCell: UICollectionViewCell {
    
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
        backgroundColor=UIColor.clear
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        setUpViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        [dateLabel].forEach { (view) in
            self.addSubview(view)
        }
    }
    
    func addConstraints() {
        dateLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func setUp(indexPath: IndexPath, firstWeekDayOfMonth: Int) {
        backgroundColor=UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            isHidden=false
            dateLabel.text="\(calcDate)"
        }
    }
}
