//
//  ProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit

// nonTimed Cell to UPVC
protocol NonTimedCellToUpVCDelegate {
    func deleteNonTimedCell(cell: UITableViewCell)
    func completeNonTimedCell(cell: UITableViewCell)
    
}

class ProjectCell: UITableViewCell {

    let stack = CoreDataStack.instance
    var editMode = false
    
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
        view.layer.borderWidth = 1
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
            make.top.equalToSuperview().offset(7.5)
            make.bottom.equalToSuperview().offset(-7.5)
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
        if goal.completionDate != nil{
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
        
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            taskSquareView.backgroundColor = UIColor.gray
        }
        
        if gestureRecognizer.state == .ended {
            
            //When the gesture ends, we want to change the project property to completed
            self.goal.completionDate = Date()
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
                self.delegate.completeNonTimedCell(cell: self)
            
            })
            
        }
    }
    
    @objc func deleteButtonTapped() {
        delegate.deleteNonTimedCell(cell: self)
        
    }
    
    @objc func editModeOff() {
        editMode = false
        taskSquareView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.deleteButton.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.deleteButton.isHidden = true
            
        })
    }
    
    @objc func editModeOn() {
        editMode = true
        taskSquareView.isUserInteractionEnabled = false
        deleteButton.isHidden = false
        deleteButton.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.deleteButton.alpha = 1
        })
    }
    



}

