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
    
    func setUpCell(type: projectType) {
        
        switch type {
        case .timed:
            instructionLabel.text = "Add a Session to start"
        case .untimed:
            instructionLabel.text = "Add a Task to start"
        }
        
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.addSubview(instructionLabel)
        instructionLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
}
