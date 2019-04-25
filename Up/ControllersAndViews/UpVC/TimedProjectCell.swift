//
//  TimedProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit

protocol TimedCellToUpVCDelegate {
    func deleteTimedCell(cell: UITableViewCell)
}

class TimedProjectCell: UITableViewCell {

    //MARK: VARIABLES
    let stack = CoreDataStack.instance
    var editMode = false
    
    var timedGoal: Goal! {
        didSet {
            setUpCell()
        }
    }
    var index: IndexPath!
    var delegate: TimedCellToUpVCDelegate!
    
    //PANGESTURE VARIABLES
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    
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
    
    let dragView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.isHidden = true
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
        
        containerView.addSubview(darkView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(timeImageContainerView)
        timeImageContainerView.addSubview(timeImageView)
        timeImageContainerView.addSubview(blackCheckMark)
        containerView.addSubview(dragView)
        self.addSubview(deleteButton)
        
    }
    
    private func setConstraints() {
        
        darkView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7.5)
            make.bottom.equalToSuperview().offset(-7.5)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-85)
            make.centerY.equalToSuperview()
        }
        
        timeImageContainerView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(timeImageContainerView.snp.left).offset(-7)
            make.centerY.equalToSuperview().offset(1)
        }
        
       
        
        timeImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
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
        
        dragView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
    private func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(editModeOn), name: .editModeOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editModeOff), name: .editModeOff, object: nil)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addOutlets()
        setConstraints()
        //MARK: GESTURE
//        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
//        recognizer.delegate = self
//        addGestureRecognizer(recognizer)
        
        if timedGoal.completionDate == nil {
            blackCheckMark.isHidden = true
//            self.isUserInteractionEnabled = true
            
        } else {
            blackCheckMark.isHidden = false
        }
        
        descriptionLabel.text = timedGoal.goalDescription
        timeLabel.text = String(describing: timedGoal.duration)
        
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if timedGoal.completionDate != nil {
            return
        }
        
        if highlighted {
            darkView.alpha = 0.55
        } else {
            darkView.alpha = 0
        }
    }
    
    @objc func deleteButtonTapped() {
        delegate.deleteTimedCell(cell: self)
        
    }
    
    @objc func editModeOff() {
        self.editMode = false
        UIView.animate(withDuration: 0.3, animations: {
            self.deleteButton.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.deleteButton.isHidden = true
        })
    }
    
    @objc func editModeOn() {
        self.editMode = true
        deleteButton.isHidden = false
        deleteButton.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.deleteButton.alpha = 1
        })
    }
    
    
}

extension TimedProjectCell: UpVCToTimedProjectCellDelegate{
    func showBlackCheck() {
        
        blackCheckMark.isHidden = false
        blackCheckMark.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            UIView.animate(withDuration: 0.5, animations: {
                self.blackCheckMark.alpha = 1
            })
            
        }
        
    }
    
    
}

