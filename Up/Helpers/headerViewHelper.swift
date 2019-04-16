//
//  headerViewHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import Foundation
import UIKit


protocol editButtonDelegate {
    func editButtonTapped()
}

class HeaderView: UIView {
    
    //MARK: OUTLETS
    var titleLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "editIcon"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //            button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    private func addOutlets() {
        self.addSubview(titleLabel)
        self.addSubview(editButton)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview().offset(5)
        }
    
        editButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview().offset(5)
        }
    }
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        titleLabel.text = title
        addOutlets()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

