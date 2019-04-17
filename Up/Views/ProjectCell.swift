//
//  ProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit

class ProjectCell: UITableViewCell {

    var project: Project! {
        didSet {
            setUpCell()
        }
    }
    
    //MARK: OUTLETS
    
    var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.07
        containerView.layer.shadowRadius = 5
        return containerView
    }()
    

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    var taskSquareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "Rectangle"), for: .normal)
        return button
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "deleteButton"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.isHidden = true
        return button
    }()
    
    
    
    //MARK: FUNCTIONS
    private func addOutlets() {
        self.addSubview(containerView)
        self.addSubview(deleteButton)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(taskSquareButton)
        
    }
    
    private func setConstraints() {
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        
        taskSquareButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.height.width.equalTo(30)
        }
        
    }
    
    private func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(editModeOn), name: .editModeOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editModeOff), name: .editModeOff, object: nil)
        addOutlets()
        setConstraints()
        descriptionLabel.text = project.description
        
    }
    
    @objc func editModeOff() {
        UIView.animate(withDuration: 0.3, animations: {
            self.deleteButton.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.deleteButton.isHidden = true
        })
    }
    
    @objc func editModeOn() {
        
        deleteButton.isHidden = false
        deleteButton.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.deleteButton.alpha = 1
        })
    }

}

