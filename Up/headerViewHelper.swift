//
//  headerViewHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import Foundation
import UIKit


struct HeaderViewHelper {
    //In Progress Title Header
    //TODO: create enum so we only need one titleHeaderView
    static func createTasksTitleHeaderView(title: String, fontSize: CGFloat, frame: CGRect, color: UIColor) -> UIView
    {
        let vw = UIView(frame:frame)
        vw.backgroundColor = color
        let titleLabel = UILabel()
        titleLabel.clipsToBounds = false
        titleLabel.textColor = UIColor.white
        titleLabel.text = title
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        titleLabel.bounds.size.width = vw.bounds.width / 3
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        
        vw.addSubview(titleLabel)
        // Constraints
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview().offset(5)
        }
        
        
        return vw
    }
}

