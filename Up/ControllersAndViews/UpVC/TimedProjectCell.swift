//
//  TimedProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit

protocol TimedCellToUpVCDelegate {
    func deleteTimedCell(cell: UITableViewCell)
    func completeTimedCell(cell: UITableViewCell)
}

class TimedProjectCell: UITableViewCell {

    //MARK: VARIABLES
    let stack = CoreDataStack.instance
    var editMode = false
    
    //MARK: VIBRATION
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var timedGoal: Goal! {
        didSet {
            setUpCell()
        }
    }
    var index: IndexPath!
    var delegate: TimedCellToUpVCDelegate!
    
    
    
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
    
    var timeLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3366830349, green: 0.334687084, blue: 0.3382208347, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 10)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
    
    var timeImageContainerView = UIView()
    
    var timeImageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "timeIcon"))
        return image
    }()
    
    var blackCheckMark: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "blackCheckMark"))
        image.isHidden = true
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
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(timeImageContainerView)
        containerView.addSubview(timeLabelView)
        timeLabelView.addSubview(timeLabel)
        containerView.addSubview(darkView)
        timeImageContainerView.addSubview(timeImageView)
        timeImageContainerView.addSubview(blackCheckMark)
        
        self.addSubview(deleteButton)
        
    }
    
    private func setConstraints() {
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7.5)
            make.bottom.equalToSuperview().offset(-7.5)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        darkView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeImageContainerView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        timeImageContainerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview().offset(-3)
            make.width.height.equalTo(27)
        }
        
        timeLabelView.snp.makeConstraints { (make) in
            make.left.equalTo(timeImageContainerView.snp.right).offset(-15)
            make.top.equalTo(timeImageContainerView.snp.bottom).offset(-12)
            make.width.height.equalTo(20)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(1)
        }
        
        timeImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(27)
            make.centerX.centerY.equalToSuperview()
        }
        
        blackCheckMark.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-10)
            make.height.width.equalTo(30)
        }
        
        
        
    }
    
    private func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addOutlets()
        setConstraints()
        //MARK: GESTURE

        
        if timedGoal.completionDate == nil {
            blackCheckMark.isHidden = true

            
        } else {
            blackCheckMark.isHidden = false
        }
        
        descriptionLabel.text = timedGoal.goalDescription
        timeLabel.text = String(describing: timedGoal.duration)
        
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        
        if highlighted {
            darkView.alpha = 0.55
        } else {
            darkView.alpha = 0
        }
    }
    
    @objc func deleteButtonTapped() {
        delegate.deleteTimedCell(cell: self)
        
    }
    
    
}

extension TimedProjectCell: UpVCToTimedProjectCellDelegate{
    func showBlackCheck() {
        
        blackCheckMark.isHidden = false
        blackCheckMark.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.generator.impactOccurred()
            UIView.animate(withDuration: 0.5, animations: {
                self.blackCheckMark.alpha = 1
            }, completion: { (res) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                     self.delegate.completeTimedCell(cell: self)
                })
                
            })
            
        }
        
    }
    
    
}

