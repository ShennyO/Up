//
//  newTaskSlidingView.swift
//  Up
//
//  Created by Sunny Ouyang on 5/12/19.
//

import UIKit

protocol NewTaskViewToTimeSelectorViewDelegate: class {
    func setSelectedTimeForPicker(time: Int)
}

protocol NewTaskViewToTimeInputButtonDelegate: class {
    func sendSelectedTime(time: Int)
    func tapStarted()
    func tapEnded()
}

protocol NewTaskSlidingViewToNewTaskVCDelegate: class {
    func sendDefaultTime(time: Int)
    func sendSetTime(time: Int)
    func configGestureStatus(status: Bool)
    func addButtonTapped()
    func sessionButtonTapped()
    func taskButtonTapped()
    func sendTextViewText(text: String)
}

protocol NewTaskSlidingViewToDescriptionTextViewDelegate: class {
    func sendTextInEditMode(text: String)
}

class NewTaskSlidingView: UIView {
    
    //MARK: VARIABLES
    var selectedTime: Int = 30
    
    //MARK: DELEGATE VARIABLES
    weak var timeInputDelegate: NewTaskViewToTimeInputButtonDelegate!
    weak var newTaskVCDelegate: NewTaskSlidingViewToNewTaskVCDelegate!
    weak var descriptionViewDelegate: NewTaskSlidingViewToDescriptionTextViewDelegate!
    weak var timeSelectorViewDelegate: NewTaskViewToTimeSelectorViewDelegate!
    
    //MARK: OUTLETS
    
    var topHorizontalView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.pureWhite
        view.layer.cornerRadius = heightScaleFactor(distance: 3)
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
        button.backgroundColor = Style.Colors.Palette01.mainBlue
        button.layer.cornerRadius = 4
        button.setImage(#imageLiteral(resourceName: "whiteRectangle"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.isSelected = false
        button.addTarget(self, action: #selector(sessionButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var typeStackView: UIStackView!
    
    var typeStackViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.08583535999, blue: 0.1098039216, alpha: 1)
        view.layer.cornerRadius = widthScaleFactor(distance: 4)
        return view
    }()
    
    var timeButton = TimeInputViewButton(frame: CGRect(x: 0, y: 0, width: 165, height: 50))
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = widthScaleFactor(distance: 4)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 22))
        button.backgroundColor = Style.Colors.Palette01.mainBlue
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let timeSelectorView = TimeSelectorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: widthScaleFactor(distance: 272)))
    
    private func setUpTimeSelectorView() {
        self.addSubview(timeSelectorView)
        timeSelectorView.slidingViewDelegate = self
        self.timeSelectorViewDelegate = timeSelectorView
        timeSelectorView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(heightScaleFactor(distance: 272))
            make.left.right.equalToSuperview()
            make.height.equalTo(heightScaleFactor(distance: 272))
        }
    }
    
    private func addOutlets() {
        [topHorizontalView, descriptionTextView, timeButton, addButton, typeStackViewContainer].forEach { (view) in
            self.addSubview(view)
        }
        descriptionTextView.textDelegate = self
        typeStackView = UIStackView(arrangedSubviews: [sessionButton, taskButton])
        typeStackView.alignment = .fill
        typeStackView.spacing = 35
        typeStackViewContainer.addSubview(typeStackView)
    }
    
    private func setConstraints() {
        topHorizontalView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 16))
            make.centerX.equalToSuperview()
            make.width.equalTo(widthScaleFactor(distance: 80))
            make.height.equalTo(heightScaleFactor(distance: 6))
        }
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 96))
            make.left.equalToSuperview().offset(widthScaleFactor(distance: 32))
            make.right.equalToSuperview().offset(widthScaleFactor(distance: -32))
            make.height.equalTo(widthScaleFactor(distance: 100))
        }
        
        taskButton.snp.makeConstraints { (make) in
            make.height.equalTo(widthScaleFactor(distance: 75))
            make.width.equalTo(widthScaleFactor(distance: 75))
        }
        
        sessionButton.snp.makeConstraints { (make) in
            make.height.equalTo(widthScaleFactor(distance: 75))
            make.width.equalTo(widthScaleFactor(distance: 75))
        }
        
        typeStackViewContainer.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 32))
            make.top.equalTo(descriptionTextView.snp.bottom).offset(widthScaleFactor(distance: 30))
            make.height.equalTo(widthScaleFactor(distance: 120))
        }
        
        typeStackView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
        }
        
        timeButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeStackViewContainer.snp.bottom).offset(widthScaleFactor(distance: 30))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 32))
            make.height.equalTo(widthScaleFactor(distance: 54))
        }
        
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeStackViewContainer.snp.bottom).offset(widthScaleFactor(distance: 48))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 32))
            make.height.equalTo(widthScaleFactor(distance: 44))
        }
    }
    
    @objc private func taskButtonSelected() {
        //switching button mode
        if taskButton.isSelected == true {
            return
        }
        
        newTaskVCDelegate.taskButtonTapped()
        
        taskButton.backgroundColor = Style.Colors.Palette01.mainBlue
        sessionButton.backgroundColor = nil
        sessionButton.isSelected = false
        taskButton.isSelected = true
        
        self.addButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.typeStackViewContainer.snp.bottom).offset(widthScaleFactor(distance: 46))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 32))
            make.height.equalTo(widthScaleFactor(distance: 44))
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
        newTaskVCDelegate.sendDefaultTime(time: 30)
        newTaskVCDelegate.sessionButtonTapped()
        sessionButton.isSelected = true
        sessionButton.backgroundColor = Style.Colors.Palette01.mainBlue
        taskButton.backgroundColor = nil
        taskButton.isSelected = false
        timeButton.isHidden = false
        timeButton.alpha = 0
        
        self.addButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.typeStackViewContainer.snp.bottom).offset(widthScaleFactor(distance: 120))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 32))
            make.height.equalTo(widthScaleFactor(distance: 44))
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
            timeSelectorView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
                make.height.equalTo(heightScaleFactor(distance: 272))
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            })
            
            newTaskVCDelegate.configGestureStatus(status: false)
        }
    }
    
    private func hideTimeSelectorView() {
        self.timeSelectorView.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(heightScaleFactor(distance: 272))
            make.left.right.equalToSuperview()
            make.height.equalTo(heightScaleFactor(distance: 272))
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        })
        
        self.newTaskVCDelegate.configGestureStatus(status: true)
        self.newTaskVCDelegate.sendSetTime(time: selectedTime)
        self.timeInputDelegate.sendSelectedTime(time: selectedTime)
    }
    
    @objc private func addButtonTapped() {
        newTaskVCDelegate.addButtonTapped()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addOutlets()
        setConstraints()
        roundCorners([.topLeft, .topRight], radius: 9)
        setUpTimeSelectorView()
        timeInputDelegate = timeButton
        descriptionViewDelegate = descriptionTextView
        descriptionTextView.textDelegate = self
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

extension NewTaskSlidingView: CustomTextViewToNewTaskViewDelegate {
    
    func sendText(text: String) {
        newTaskVCDelegate.sendTextViewText(text: text)
    }
    
}

extension NewTaskSlidingView: newTaskVCToSlidingViewDelegate {
    func hideTimeSelector() {
        hideTimeSelectorView()
    }
    
    func sendSelectedTimeForEdit(time: Int) {
        timeSelectorViewDelegate.setSelectedTimeForPicker(time: time)
        timeInputDelegate.sendSelectedTime(time: time)
    }
    
    func sendGoalDescription(desc: String) {
        descriptionViewDelegate.sendTextInEditMode(text: desc)
    }
    
    func sessionModeOn() {
        sessionButton.isSelected = true
        sessionButton.backgroundColor = Style.Colors.Palette01.mainBlue
        taskButton.backgroundColor = nil
        taskButton.isSelected = false
        timeButton.isHidden = false
        self.timeButton.alpha = 1
        self.addButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.typeStackViewContainer.snp.bottom).offset(widthScaleFactor(distance: 120))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 32))
            make.height.equalTo(widthScaleFactor(distance: widthScaleFactor(distance: 44)))
        }
    }
    
    func taskModeOn() {
        taskButton.backgroundColor = Style.Colors.Palette01.mainBlue
        taskButton.isSelected = true
        sessionButton.backgroundColor = nil
        sessionButton.isSelected = false
        self.timeButton.isHidden = true
        
        self.addButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.typeStackViewContainer.snp.bottom).offset(widthScaleFactor(distance: 46))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 32))
            make.height.equalTo(widthScaleFactor(distance: widthScaleFactor(distance: 44)))
        }
    }
    
}

extension NewTaskSlidingView: TimeSelectorViewToNewTaskSlidingViewDelegate {
    func doneButtonTapped() {
        hideTimeSelectorView()
    }
    
    func sendSelectedTime(time: Int) {
        self.selectedTime = time
    }
}
