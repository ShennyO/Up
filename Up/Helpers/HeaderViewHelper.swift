//
//  headerViewHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import Foundation
import UIKit


//need a delegate from HeaderView to upVC to communicate that when edit mode
//is on, hide the add button on upVC

protocol HeaderViewToUpVCDelegate {
    func addTapped()
}

class HeaderView: UIView {
    
    //MARK: VARIABLES
    var delegate: HeaderViewToUpVCDelegate!
    
    //MARK: OUTLETS
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "AddButton Copy"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    let getStartedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.text = "Add a goal to get started"
        label.textColor = UIColor.white
        label.isHidden = false
        return label
    }()
    
    private func addOutlets() {
        self.addSubview(titleLabel)
        self.addSubview(addButton)
        self.addSubview(getStartedLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(25)
        }
    
        addButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalTo(titleLabel)
        }
        
        
        getStartedLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(125)
        }
        
    }
    
    
    @objc private func addButtonTapped() {
        delegate.addTapped()
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


    
    


