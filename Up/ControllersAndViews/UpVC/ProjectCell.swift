//
//  ProjectCell.swift
//  Up
//
//  Created by Sunny Ouyang on 4/4/19.
//

import UIKit
import AudioToolbox

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
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
 
    
    //MARK: LAYERS
    weak var lineShapeLayer: CAShapeLayer?

    
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
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 15))
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.1019607843, green: 0.1098039216, blue: 0.1176470588, alpha: 1)
        return label
    }()
    
    
    var taskSquareView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1098039216, blue: 0.1176470588, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        return view
    }()
    
    var taskSquareFillView: UIView = {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1098039216, blue: 0.1176470588, alpha: 1)
        view.layer.cornerRadius = 3
        view.isHidden = true
        return view
        
    }()
    
    var hitBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var checkMarkImage: UIImageView = {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "checkMark"))
        imageView.isHidden = true
        return imageView
        
    }()
    
    //MARK: FUNCTIONS
    private func addOutlets() {
        self.addSubview(containerView)
        
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(taskSquareView)
        containerView.addSubview(taskSquareFillView)
        containerView.addSubview(darkView)
        taskSquareFillView.addSubview(checkMarkImage)
        containerView.addSubview(hitBoxView)
        
    }
    
    private func setConstraints() {
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 8))
            make.bottom.equalToSuperview().offset(heightScaleFactor(distance: -8))
            make.left.equalToSuperview().offset(widthScaleFactor(distance: 20))
            make.right.equalToSuperview().offset(widthScaleFactor(distance: -20))
        }
        
        darkView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        taskSquareView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(widthScaleFactor(distance: 17))
            make.centerY.equalToSuperview().offset(1)
            make.width.height.equalTo(widthScaleFactor(distance: 22))
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(taskSquareView.snp.right).offset(widthScaleFactor(distance: 15))
            make.right.equalToSuperview().offset(widthScaleFactor(distance: -15))
            make.centerY.equalToSuperview().offset(1)
        }
        
        taskSquareFillView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(widthScaleFactor(distance: 17))
            make.centerY.equalToSuperview().offset(1)
            make.width.height.equalTo(widthScaleFactor(distance: 22))
        }
        
        hitBoxView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(widthScaleFactor(distance: 12))
            make.left.equalToSuperview().inset(widthScaleFactor(distance: 8))
            make.right.equalTo(descriptionLabel.snp.left).offset(widthScaleFactor(distance: -8))
        }
        
        checkMarkImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(1)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(widthScaleFactor(distance: 12))
        }
        
    }
    
    private func addCheckBoxGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(complete))
        self.hitBoxView.addGestureRecognizer(tap)
        
    }
    
    private func setUpCell() {
        self.backgroundColor = UIColor.clear
        addOutlets()
        setConstraints()
        addCheckBoxGesture()
        if goal.completionDate != nil{
            taskSquareFillView.isHidden = false
            checkMarkImage.isHidden = false
        } else {
            taskSquareFillView.isHidden = true
            checkMarkImage.isHidden = true
        }
        
        descriptionLabel.text = goal.goalDescription
    }
    
    private func strikeThrough() {
        // Here we will draw the lines through the text
        // crafting the path of the line
        let path = UIBezierPath()
        let path2 = UIBezierPath()
        let numberOfLines = descriptionLabel.calculateMaxLines()
        let rowOneWidth = descriptionLabel.intrinsicContentSize.width
        var rowTwoWidth: CGFloat = 0
        if descriptionLabel.text!.count > 70  {
            rowTwoWidth = descriptionLabel.intrinsicContentSize.width
        } else if descriptionLabel.text!.count < 60 {
            rowTwoWidth = descriptionLabel.intrinsicContentSize.width / 3
        } else {
            rowTwoWidth = descriptionLabel.intrinsicContentSize.width / 2
        }
        
        
        if numberOfLines == 1 {
            path.move(to: CGPoint(x: widthScaleFactor(distance: 76), y: (self.bounds.height / 2) + 1))
            path.addLine(to: CGPoint(x: widthScaleFactor(distance: 76) + rowOneWidth, y: (self.bounds.height / 2) + 1))
            
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
            
            let yPos = (self.bounds.height / 2) - (descriptionLabel.bounds.height / 2) + heightScaleFactor(distance: 11)
            path.move(to: CGPoint(x: widthScaleFactor(distance: 76), y: yPos))
            path.addLine(to: CGPoint(x: widthScaleFactor(distance: 76) + CGFloat(rowOneWidth), y: yPos))
            
            let yPos2 = (self.bounds.height / 2) + (descriptionLabel.bounds.height / 2) - 9
            path.move(to: CGPoint(x: widthScaleFactor(distance: 76), y: yPos2))
            path.addLine(to: CGPoint(x: widthScaleFactor(distance: 76) + CGFloat(rowTwoWidth), y: yPos2))
            
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
    
   
    private func strikethroughAndComplete(completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.strikeThrough()
            
            completion()
        }
        
    }
    
     //THIS FUNCTION IS CALLED FROM OUTSIDE WHEN USER TAPPED ON THE CELL
    @objc private func complete() {
        //in here, after the checkbox animates, I need to run the line through the words.
        //I should create a function for this
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
        generator.impactOccurred()
        
        strikethroughAndComplete {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.delegate.completeNonTimedCell(cell: self)
            })
        }
        UIView.animate(withDuration: 0.35, animations: {
            self.taskSquareFillView.alpha = 1
            self.checkMarkImage.alpha = 1
        })
    }
    
}

