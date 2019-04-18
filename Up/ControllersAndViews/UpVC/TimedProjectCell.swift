//
//  TimedProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit

protocol TimedCellDelegate {
    func passTimedCellIndex(index: IndexPath)
}

class TimedProjectCell: UITableViewCell {

    //MARK: VARIABLES
    var timedProject: TimedProject! {
        didSet {
            setUpCell()
        }
    }
    var index: IndexPath!
    var delegate: TimedCellDelegate!
    
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
    
    let darkView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
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
        containerView.addSubview(darkView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(timeImageView)
        
    }
    
    private func setConstraints() {
        
        darkView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-85)
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
        
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-10)
            make.height.width.equalTo(30)
        }
        
    }
    
    private func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(editModeOn), name: .editModeOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editModeOff), name: .editModeOff, object: nil)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addOutlets()
        setConstraints()
        descriptionLabel.text = timedProject.description
        timeLabel.text = String(describing: timedProject.time)
        
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            darkView.alpha = 0.55
        } else {
            darkView.alpha = 0
        }
    }
    
    @objc func deleteButtonTapped() {
        delegate.passTimedCellIndex(index: index)
        
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


