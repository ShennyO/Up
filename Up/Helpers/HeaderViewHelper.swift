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
    func alertUpVCOfEditMode(mode: Bool)
}

class HeaderView: UIView {
    
    //MARK: VARIABLES
    var editButtonMode = false
    var delegate: HeaderViewToUpVCDelegate!
    
    //MARK: OUTLETS
    var titleLabel: UILabel = {
        let label = UILabel()
//        label.clipsToBounds = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "editIcon"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "disabledEditIcon"), for: .disabled)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.isEnabled = false
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
        self.addSubview(editButton)
        self.addSubview(dotDotDotLabel)
        self.addSubview(getStartedLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(25)
        }
    
        editButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalTo(titleLabel)
        }
        
        dotDotDotLabel.snp.makeConstraints { (make) in
            make.right.equalTo(editButton.snp.right).offset(10)
            make.centerY.equalTo(editButton).offset(5)
        }
        
        getStartedLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(125)
        }
        
    }
    
    @objc private func editButtonTapped() {
        
        //if button is active when tapped
        if editButtonMode {
            
            editButtonMode = false
            
            //hiding UpVC's Addbutton
            delegate.alertUpVCOfEditMode(mode: editButtonMode)
            
            //move back to original pos
            editButton.snp.updateConstraints { (make) in
                make.height.width.equalTo(30)
                make.right.equalToSuperview().offset(-25)
                make.centerY.equalTo(titleLabel)
            }
            //hiding the dotDotDots and moving editButton back to original pos
            UIView.animate(withDuration: 0.3, animations: {
                self.dotDotDotLabel.alpha = 0
                self.layoutIfNeeded()
            }, completion:  {
                (value: Bool) in
                self.dotDotDotLabel.isHidden = true
                
            })
            
            //Communicating to all the tableview cells to hide their delete button
            NotificationCenter.default.post(name: .editModeOff, object: nil)
            
        } else { // if edit button is not active when tapped
            //Using a notification center instead of a delegate because we need to communicate with
            //all of the tableview cells and not just one
            NotificationCenter.default.post(name: .editModeOn, object: nil)
            editButtonMode = true
            delegate.alertUpVCOfEditMode(mode: editButtonMode)
            editButton.snp.updateConstraints { (make) in
                make.height.width.equalTo(30)
                make.right.equalToSuperview().offset(-35)
                make.centerY.equalTo(titleLabel)
            }
            
            UIView.animate(withDuration: 0.4, animations: {
                self.layoutIfNeeded()
                
            })
            //showing the dotDotDots
            dotDotDotLabel.isHidden = false
            dotDotDotLabel.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations: {
                self.dotDotDotLabel.alpha = 1
            })
            
            
            
            
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

extension HeaderView: UpVCToUpVCHeaderDelegate {
    
    //PURPOSE: To configure the header view based off of the count of projects
    func alertHeaderView(total: Int) {
        
        //If there aren't any projects
        if total == 0 {
            editButtonMode = false
            NotificationCenter.default.post(name: .editModeOff, object: nil)
            //move back to original pos
            editButton.snp.updateConstraints { (make) in
                make.height.width.equalTo(30)
                make.right.equalToSuperview().offset(-25)
                make.centerY.equalTo(titleLabel)
            }
            //hiding the dotDotDots
            UIView.animate(withDuration: 0.3, animations: {
                self.editButton.isEnabled = false
                self.layoutIfNeeded()
                self.dotDotDotLabel.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.dotDotDotLabel.isHidden = true
            })
            
            getStartedLabel.isHidden = false
            getStartedLabel.alpha = 0
            UIView.animate(withDuration: 0.7, animations: {
                self.getStartedLabel.alpha = 1
            })
            
            
        } else { //If there are projects
            
            UIView.animate(withDuration: 0.3) {
                self.editButton.isEnabled = true
            }
            
            
            UIView.animate(withDuration: 0.6, animations: {
                
                self.getStartedLabel.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.getStartedLabel.isHidden = true
            })
            
        }
        
    }
    
    
}

