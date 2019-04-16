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
        
        let editButton: UIButton = {
            let button = UIButton()
            button.setBackgroundImage(#imageLiteral(resourceName: "editIcon"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
//            button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            button.clipsToBounds = true
            return button
        }()

        
        
        vw.addSubview(titleLabel)
        vw.addSubview(editButton)
        // Constraints
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview().offset(5)
        }
        
        editButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview().offset(5)
        }
        
        return vw
    }
}

