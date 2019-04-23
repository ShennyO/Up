//
//  TimedProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit

protocol TimedCellToUpVCDelegate {
    func passTimedCellIndex(cell: UITableViewCell)
}

class TimedProjectCell: UITableViewCell {

    //MARK: VARIABLES
    let stack = CoreDataStack.instance
    
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
        self.addSubview(deleteButton)
        containerView.addSubview(darkView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(timeImageContainerView)
        timeImageContainerView.addSubview(timeImageView)
        timeImageContainerView.addSubview(blackCheckMark)
        containerView.addSubview(dragView)
        
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
        
        timeImageContainerView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            //            make.right.equalTo(timeLabel.snp.left).offset(-7)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(timeImageContainerView.snp.left).offset(-7)
//            make.right.equalToSuperview().offset(-15)
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
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
        if timedGoal.completion {
            blackCheckMark.isHidden = false
            
        } else {
            blackCheckMark.isHidden = true
            self.isUserInteractionEnabled = true
        }
        
        descriptionLabel.text = timedGoal.goalDescription
        timeLabel.text = String(describing: timedGoal.duration)
        
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if timedGoal.completion {
            return
        }
        
        if highlighted {
            darkView.alpha = 0.55
        } else {
            darkView.alpha = 0
        }
    }
    
    @objc func deleteButtonTapped() {
        delegate.passTimedCellIndex(cell: self)
        
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
    
    //MARK: - horizontal pan gesture methods
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
            dragView.isHidden = false
        }
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            
            //All the way right, alpha is 0, all the way left alpha is 0.7
            //We're going to do this based off the frame's x position (0 -> -285)
            let alphaVal = abs(frame.origin.x) / 275
            dragView.alpha = alphaVal
            
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
        }
        // 3
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease {
                // if the item is not being deleted, snap back to the original location
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
                
                self.dragView.isHidden = true
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dragView.isHidden = true
                }
                
                delegate.passTimedCellIndex(cell: self)
                
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            
            if translation.x < translation.y {
                return true
            }
            return false
        }
        return false
    }

    
}

extension TimedProjectCell: UpVCToTimedProjectCellDelegate{
    func showBlackCheck() {
        //showing the dotDotDots
        blackCheckMark.isHidden = false
        blackCheckMark.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.4, animations: {
                self.blackCheckMark.alpha = 1
            })
        }
        
    }
    
    
}

