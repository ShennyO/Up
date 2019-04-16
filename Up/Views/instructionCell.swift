//
//  instructionCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import UIKit

class instructionCell: UITableViewCell {

    //MARK: OUTLETS
    var instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
    
    func setUpCell() {
        
        instructionLabel.text = "Add a goal to get started"
        
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.addSubview(instructionLabel)
        instructionLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(7)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
}
