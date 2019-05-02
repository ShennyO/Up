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
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.1019607843, green: 0.1098039216, blue: 0.1176470588, alpha: 1)
        return label
    }()
    
    var timeLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.0862745098, blue: 0.09411764706, alpha: 1)
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
    }
    
    private func setUpCell() {
        self.backgroundColor = UIColor.clear
        
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
    
}

extension TimedProjectCell: UpVCToTimedProjectCellDelegate {
    
    
    private func strikeThrough() {
        // Here we will draw the lines through the text
        // crafting the path of the line
        let path = UIBezierPath()
        let path2 = UIBezierPath()
        let numberOfLines = descriptionLabel.calculateMaxLines()
        var rowTwoWidth: CGFloat = 0
        if descriptionLabel.text!.count > 70  {
            rowTwoWidth = descriptionLabel.intrinsicContentSize.width
        } else if descriptionLabel.text!.count < 60 {
            rowTwoWidth = descriptionLabel.intrinsicContentSize.width / 3
        } else {
            rowTwoWidth = descriptionLabel.intrinsicContentSize.width / 2
        }
        if numberOfLines == 1 {
            path.move(to: CGPoint(x: 80, y: self.bounds.height / 2))
            path.addLine(to: CGPoint(x: 80 + descriptionLabel.intrinsicContentSize.width, y: self.bounds.height / 2))
            
            let shapeLayer: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.fillColor = #colorLiteral(red: 0.1101594344, green: 0.1095120981, blue: 0.1106618419, alpha: 1)
                layer.strokeColor = #colorLiteral(red: 0.1101594344, green: 0.1095120981, blue: 0.1106618419, alpha: 1)
                layer.lineWidth = 1
                layer.path = path.cgPath
                return layer
            }()
            
            self.layer.addSublayer(shapeLayer)
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = 0.2
            shapeLayer.add(animation, forKey: "MyAnimation")
            
        } else {
            
            let yPos = (self.bounds.height / 2) - (descriptionLabel.bounds.height / 2) + 10
            path.move(to: CGPoint(x: 80, y: yPos))
            path.addLine(to: CGPoint(x: 80 + descriptionLabel.intrinsicContentSize.width, y: yPos))
            
            let yPos2 = (self.bounds.height / 2) + (descriptionLabel.bounds.height / 2) - 9
            path.move(to: CGPoint(x: 80, y: yPos2))
            path.addLine(to: CGPoint(x: 80 + rowTwoWidth, y: yPos2))
            
            let shapeLayer: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.fillColor = #colorLiteral(red: 0.1101594344, green: 0.1095120981, blue: 0.1106618419, alpha: 1)
                layer.strokeColor = #colorLiteral(red: 0.1101594344, green: 0.1095120981, blue: 0.1106618419, alpha: 1)
                layer.lineWidth = 1
                layer.path = path.cgPath
                return layer
            }()
            
            
            self.layer.addSublayer(shapeLayer)
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = 0.2
            shapeLayer.add(animation, forKey: "MyAnimation")
            
            let shapeLayer2: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.fillColor = #colorLiteral(red: 0.1101594344, green: 0.1095120981, blue: 0.1106618419, alpha: 1)
                layer.strokeColor = #colorLiteral(red: 0.1101594344, green: 0.1095120981, blue: 0.1106618419, alpha: 1)
                layer.lineWidth = 1
                layer.path = path2.cgPath
                return layer
            }()
            
            self.layer.addSublayer(shapeLayer2)
            let animation2 = CABasicAnimation(keyPath: "strokeEnd")
            animation2.fromValue = 0
            animation2.duration = 0.2
            shapeLayer.add(animation, forKey: "MyAnimation2")

        }
    }
    
    
    func showBlackCheck() {
        
        blackCheckMark.isHidden = false
        blackCheckMark.alpha = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.generator.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.strikeThrough()
            })
            UIView.animate(withDuration: 0.35, animations: {
                self.blackCheckMark.alpha = 1
            }, completion: { (res) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.27, execute: {
                     self.delegate.completeTimedCell(cell: self)
                })
                
            })
            
        }
        
    }
    
    
}

