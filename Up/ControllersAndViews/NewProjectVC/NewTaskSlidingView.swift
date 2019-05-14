//
//  newTaskSlidingView.swift
//  Up
//
//  Created by Sunny Ouyang on 5/12/19.
//

import UIKit

protocol NewTaskViewToTimeInputButtonDelegate: class {
    func sendSelectedTime(time: Int)
    func tapStarted()
    func tapEnded()
}

protocol NewTaskSlidingViewToNewTaskVCDelegate: class {
    func timeButtonTapped(status: Bool)
}

class newTaskSlidingView: UIView {
    
    //MARK: VARIABLES
    var descriptionText: String?
    var selectedTime = 30
    weak var timeInputDelegate: NewTaskViewToTimeInputButtonDelegate!
    weak var newTaskVCDelegate: NewTaskSlidingViewToNewTaskVCDelegate!
    
    //MARK: OUTLETS
    var blurEffectView: UIVisualEffectView?
    
    var topHorizontalView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.pureWhite
        view.layer.cornerRadius = 4
        return view
    }()
    
    var newTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "What's the next task?"
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 24))
        return label
    }()
    
    var descriptionTextView = SunnyCustomInputView(frame: CGRect(x: 0, y: 0, width: 230, height: 75), fontSize: widthScaleFactor(distance: 18), type: .textView)
    
    var taskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 4
        button.setImage(#imageLiteral(resourceName: "whiteRectangle"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.isSelected = true
        button.addTarget(self, action: #selector(taskButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var sessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setImage(#imageLiteral(resourceName: "whiteTimeIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.isSelected = false
        button.addTarget(self, action: #selector(sessionButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var typeStackView: UIStackView!
    
    var timeButton = TimeInputViewButton(frame: CGRect(x: 0, y: 0, width: 165, height: 50))
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = widthScaleFactor(distance: 28)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 22))
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        //        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let timeSelectorView = TimeSelectorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: widthScaleFactor(distance: 352)))
    
    private func setUpTimeSelectorView() {
        self.addSubview(timeSelectorView)
        
        timeSelectorView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(heightScaleFactor(distance: 352))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 80))
            make.height.equalTo(heightScaleFactor(distance: 352))
        }
    }
    
    private func addOutlets() {
        [topHorizontalView, newTaskLabel,descriptionTextView, timeButton, addButton].forEach { (view) in
            self.addSubview(view)
        }
        descriptionTextView.textDelegate = self
        typeStackView = UIStackView(arrangedSubviews: [sessionButton, taskButton])
        typeStackView.alignment = .fill
        typeStackView.spacing = 35
        self.addSubview(typeStackView)
    }
    
    private func setConstraints() {
        
        topHorizontalView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 16))
            make.centerX.equalToSuperview()
            make.width.equalTo(widthScaleFactor(distance: 80))
            make.height.equalTo(heightScaleFactor(distance: 6))
        }
        
        newTaskLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 80))
            make.centerX.equalToSuperview()
        }
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(newTaskLabel.snp.bottom).offset(heightScaleFactor(distance: 48))
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(widthScaleFactor(distance: 100))
        }
        
        taskButton.snp.makeConstraints { (make) in
            make.height.equalTo(widthScaleFactor(distance: 66))
            make.width.equalTo(widthScaleFactor(distance: 66))
        }
        
        sessionButton.snp.makeConstraints { (make) in
            make.height.equalTo(widthScaleFactor(distance: 66))
            make.width.equalTo(widthScaleFactor(distance: 66))
        }
        
        typeStackView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(widthScaleFactor(distance: 48))
            make.centerX.equalTo(descriptionTextView)
        }
        
        timeButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeStackView.snp.bottom).offset(widthScaleFactor(distance: 32))
            make.centerX.equalToSuperview()
            make.width.equalTo(widthScaleFactor(distance: 166))
            make.height.equalTo(widthScaleFactor(distance: 56))
        }
        
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeStackView.snp.bottom).offset(widthScaleFactor(distance: 48))
            make.centerX.equalToSuperview()
            make.width.equalTo(widthScaleFactor(distance: 120))
            make.height.equalTo(widthScaleFactor(distance: 56))
        }
    }
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = self.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.isHidden = true
        blurEffectView?.alpha = 0.4
        if blurEffectView != nil {
            self.addSubview(blurEffectView!)
        }
    }
    
    @objc private func taskButtonSelected() {
        //switching button mode
        if taskButton.isSelected == true {
            return
        }
        taskButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        sessionButton.backgroundColor = nil
        sessionButton.isSelected = false
        taskButton.isSelected = true
        
        self.addButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.typeStackView.snp.bottom).offset(widthScaleFactor(distance: 46))
            make.centerX.equalToSuperview()
            make.width.equalTo(widthScaleFactor(distance: 120))
            make.height.equalTo(widthScaleFactor(distance: 56))
        }
        //hiding timeButton
        UIView.animate(withDuration: 0.3, animations: {
            self.timeButton.alpha = 0
            self.layoutIfNeeded()
        }, completion:  {
            (value: Bool) in
            self.timeButton.isHidden = true
        })
        self.layoutIfNeeded()
    }
    
    @objc private func sessionButtonSelected() {
        if sessionButton.isSelected == true {
            return
        }
        
        if selectedTime == 0 {
            selectedTime = 30
        }
        
        sessionButton.isSelected = true
        sessionButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        taskButton.backgroundColor = nil
        taskButton.isSelected = false
        timeButton.isHidden = false
        timeButton.alpha = 0
        
        self.addButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.typeStackView.snp.bottom).offset(widthScaleFactor(distance: 120))
            make.centerX.equalToSuperview()
            make.width.equalTo(widthScaleFactor(distance: 120))
            make.height.equalTo(widthScaleFactor(distance: 56))
        }
        //showing timeButton
        UIView.animate(withDuration: 0.4, animations: {
            self.timeButton.alpha = 1
            self.layoutIfNeeded()
        })
    }
    
    
    @objc func handleTimeButtonTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .began {
            timeInputDelegate.tapStarted()
        }
        
        if gestureRecognizer.state == .ended {
            
            timeInputDelegate.tapEnded()
            
            
            //MARK: CALLBACK
            //CALLBACK IS RUN WHEN timeSelectorVC is dismissed
            timeSelectorView.onDoneBlock = { (result) in
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.blurEffectView?.alpha = 0
                }, completion:  {
                    (value: Bool) in
                    self.blurEffectView?.isHidden = true
                })
                
                self.timeSelectorView.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview().offset(heightScaleFactor(distance: 352))
                    make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 80))
                    make.height.equalTo(heightScaleFactor(distance: 352))
                }
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded()
                })
                
                self.newTaskVCDelegate.timeButtonTapped(status: true)
                
                //THIS IS SENDING THE SELECTED TIME BACK TO THE TIMEINPUTBUTTONVIEW
                self.timeInputDelegate.sendSelectedTime(time: result)
                self.selectedTime = result
            }
            
            timeSelectorView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().inset(heightScaleFactor(distance: 144))
                make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 80))
                make.height.equalTo(heightScaleFactor(distance: 352))
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            })
            
            blurEffectView?.isHidden = false
            blurEffectView?.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffectView?.alpha = 0.6
            })
            
            newTaskVCDelegate.timeButtonTapped(status: false)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addOutlets()
        setConstraints()
        roundCorners([.topLeft, .topRight], radius: 9)
        addBlur()
        setUpTimeSelectorView()
        timeInputDelegate = timeButton
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(handleTimeButtonTap(_:)))
        tap.minimumPressDuration = 0
        timeButton.addGestureRecognizer(tap)
        self.backgroundColor = Style.Colors.Palette01.gunMetal
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension newTaskSlidingView: CustomTextViewToNewProjVCDelegate {
    
    func sendText(text: String) {
        descriptionText = text
    }
    
}

