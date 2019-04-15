//
//  TimedProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit

class TimedProjectCell: UITableViewCell {

    //MARK: VARIABLES
    var timedProject: timedProject! {
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
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        return label
    }()
    
    var timeImageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "timeIcon"))
        return image
    }()
    
//    var leftStackView: UIStackView!
    
    //MARK: FUNCTIONS
    private func addOutlets() {
//        if timedProject.description != "" {
//            leftStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
//        } else {
//            leftStackView = UIStackView(arrangedSubviews: [titleLabel])
//        }
//        leftStackView.distribution = .fillEqually
//        leftStackView.alignment = .fill
//        leftStackView.axis = .vertical
//        leftStackView.spacing = 5
        
        
        self.addSubview(containerView)
//        containerView.addSubview(leftStackView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(timeImageView)
        
    }
    
    private func setConstraints() {
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        
//        leftStackView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(15)
//            make.centerY.equalToSuperview()
//
//        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        timeImageView.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp.left).offset(-7)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
    }
    
    private func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        addOutlets()
        setConstraints()
//        titleLabel.text = timedProject.title
        descriptionLabel.text = timedProject.description
        timeLabel.text = String(describing: timedProject.time)
        
        
    }
    
    
}
