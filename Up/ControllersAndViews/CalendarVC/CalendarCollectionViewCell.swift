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
                backgroundColor = .white
            }
        }
    }
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Style.Fonts.medium18
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(day: String) {
        dayLabel.text = day
        self.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func setupViews() {
        
    }
}
