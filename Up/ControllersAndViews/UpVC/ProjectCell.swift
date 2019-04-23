//
//  ProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit

// nonTimed Cell to UPVC
protocol NonTimedCellToUpVCDelegate {
    func passNonTimedCellIndex(cell: UITableViewCell)
    
}

class ProjectCell: UITableViewCell {

    let stack = CoreDataStack.instance
    
    var goal: Goal! {
        didSet {
            setUpCell()
        }
    }
    var index: IndexPath!
    var delegate: NonTimedCellToUpVCDelegate!
    
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
    

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    let dragView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    var taskSquareView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 3
        return view
    }()
    
    var taskSquareFillView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
        
    }()
    
    var checkMarkImage: UIImageView = {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "checkMark"))
        imageView.isHidden = true
        return imageView
        
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
        containerView.addSubview(taskSquareView)
        containerView.addSubview(taskSquareFillView)
        containerView.addSubview(dragView)
        taskSquareFillView.addSubview(checkMarkImage)
        
    }
    
    private func setConstraints() {
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        
        taskSquareView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(taskSquareView.snp.left).offset(-15)
            make.centerY.equalToSuperview()
            
        }
        
        
        taskSquareFillView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-10)
            make.height.width.equalTo(30)
        }
        
        checkMarkImage.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        dragView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
    private func setUpCell() {
        self.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(editModeOn), name: .editModeOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editModeOff), name: .editModeOff, object: nil)
        addOutlets()
        setConstraints()
        if goal.completion {
            taskSquareFillView.isHidden = false
            checkMarkImage.isHidden = false
        } else {
            taskSquareFillView.isHidden = true
            checkMarkImage.isHidden = true
        }
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.minimumPressDuration = 0
        taskSquareView.addGestureRecognizer(tap)
        descriptionLabel.text = goal.goalDescription
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            taskSquareView.backgroundColor = UIColor.gray
        }
        
        if gestureRecognizer.state == .ended {
            
            //When the gesture ends, we want to change the project property to completed
            self.goal.completion = true
            stack.saveTo(context: stack.viewContext)
            taskSquareView.backgroundColor = UIColor.white
            //Animate fillView
            //showing the fillView
            taskSquareFillView.isHidden = false
            taskSquareFillView.alpha = 0
            checkMarkImage.isHidden = false
            checkMarkImage.alpha = 0
            self.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.35, animations: {
                self.taskSquareFillView.alpha = 1
                self.checkMarkImage.alpha = 1
            }, completion:  {
                (value: Bool) in
                self.isUserInteractionEnabled = true

            })
            
        }
    }
    
    @objc func deleteButtonTapped() {
        delegate.passNonTimedCellIndex(cell: self)
        
    }
    
    @objc func editModeOff() {
        
        taskSquareView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.deleteButton.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.deleteButton.isHidden = true
        })
    }
    
    @objc func editModeOn() {
        taskSquareView.isUserInteractionEnabled = false
        deleteButton.isHidden = false
        deleteButton.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.deleteButton.alpha = 1
        })
    }
    
    
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
                
                delegate.passNonTimedCellIndex(cell: self)
                
                
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

