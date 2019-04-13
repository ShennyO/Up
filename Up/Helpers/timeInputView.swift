//
//  timeInputView.swift
//  Up
//
//  Created by Sunny Ouyang on 4/12/19.
//

import Foundation
import UIKit


class timeInputView: UIView {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textColor = UIColor.white
        label.text = "20 minutes"
        return label
    }()
    
    let arrowImage = UIImageView(image: #imageLiteral(resourceName: "downArrow"))
    
    var stack: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        self.layer.cornerRadius = 4
        addOutlets()
        setConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addOutlets() {
        stack = UIStackView(arrangedSubviews: [timeLabel, arrowImage])
//        stack.alignment = .fill
        stack.spacing = 10
        self.addSubview(stack)
    }
    
    private func setConstraints() {
        arrowImage.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.width.equalTo(20)
        }
        
        stack.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
//            make.height.equalTo(20)
        }
        
    }
    
}
