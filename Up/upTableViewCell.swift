//
//  upTableViewCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/3/19.
//

import UIKit

class upTableViewCell: UITableViewCell {

    //MARK: VARIABLES
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
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.09240043908, green: 0.0924237594, blue: 0.09239736944, alpha: 1)
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        return label
    }()
    
    var leftStackView: UIStackView!
    
    private func setUpLeftStackView() {
        if project.description != "" {
            leftStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        } else {
            leftStackView = UIStackView(arrangedSubviews: [titleLabel])
        }
        
        leftStackView.distribution = .fillEqually
        leftStackView.alignment = .fill
        leftStackView.axis = .vertical
        leftStackView.spacing = 5
        containerView.addSubview(leftStackView)
    }

    private func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        addOutlets()
        setConstraints()
        titleLabel.text = project.title
        descriptionLabel.text = project.description ?? ""
        timeLabel.text = project.time ?? ""
        
    }
    

    
    private func addOutlets() {
        self.addSubview(containerView)
        setUpLeftStackView()
        containerView.addSubview(timeLabel)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        leftStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            
        }
        
    }
    
}

