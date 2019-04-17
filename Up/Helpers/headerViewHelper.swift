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
    
    //MARK: VARIABLES
    var delegate: editButtonDelegate!
    var editButtonActive = false
    
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
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    let dotDotDotLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.text = "..."
        label.textColor = UIColor.white
        label.isHidden = true
        return label
    }()
    
    private func addOutlets() {
        self.addSubview(titleLabel)
        self.addSubview(editButton)
        self.addSubview(dotDotDotLabel)
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
        
        dotDotDotLabel.snp.makeConstraints { (make) in
            make.right.equalTo(editButton.snp.right).offset(10)
            make.centerY.equalToSuperview().offset(10)
        }
        
    }
    
    @objc private func editButtonTapped() {
        
        //if button is active when tapped
        if editButtonActive {
            
            editButtonActive = false
            
            //move back to original pos
            editButton.snp.updateConstraints { (make) in
                make.height.width.equalTo(30)
                make.right.equalToSuperview().offset(-25)
                make.centerY.equalToSuperview().offset(5)
            }
            //hiding the dotDotDots
            UIView.animate(withDuration: 0.3, animations: {
                self.dotDotDotLabel.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.dotDotDotLabel.isHidden = true
            })
            
        } else {
            editButtonActive = true
            editButton.snp.updateConstraints { (make) in
                make.height.width.equalTo(30)
                make.right.equalToSuperview().offset(-45)
                make.centerY.equalToSuperview().offset(5)
            }
            //showing the dotDotDots
            dotDotDotLabel.isHidden = false
            dotDotDotLabel.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.dotDotDotLabel.alpha = 1
            })
        }
        
        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.layoutIfNeeded()
            
        })
        
        delegate.editButtonTapped()
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

