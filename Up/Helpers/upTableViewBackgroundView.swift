//
//  upTableViewBackgroundView.swift
//  Up
//
//  Created by Sunny Ouyang on 4/17/19.
//

import UIKit

class upTableViewBackgroundView: UIView {
    
    //MARK: OUTLETS
    var getStartedLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Add a goal to get started"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textColor = UIColor.white
        return label
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(getStartedLabel)
        
        getStartedLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(200)
        }
        
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
