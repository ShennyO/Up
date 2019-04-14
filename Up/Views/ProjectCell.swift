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
    
//    var titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
//        label.numberOfLines = 0
//        label.textColor = #colorLiteral(red: 0.09240043908, green: 0.0924237594, blue: 0.09239736944, alpha: 1)
//        return label
//    }()
    
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
    
//    var leftStackView: UIStackView!
    
    
    //MARK: FUNCTIONS
    private func addOutlets() {
        self.addSubview(containerView)
        
//        if project.description != "" {
//            leftStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
//        } else {
//            leftStackView = UIStackView(arrangedSubviews: [titleLabel])
//        }
//
//        leftStackView.distribution = .fillEqually
//        leftStackView.alignment = .fill
//        leftStackView.axis = .vertical
//        leftStackView.spacing = 5
//        containerView.addSubview(leftStackView)
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
        
//        leftStackView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(15)
//            make.centerY.equalToSuperview()
//
//        }
        
        taskSquareButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
    }
    
    private func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        addOutlets()
        setConstraints()
//        titleLabel.text = project.title
        descriptionLabel.text = project.description
        
    }

}
