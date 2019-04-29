//
//  NewProjectViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import UIKit


protocol newProjectVCToTextInputViewDelegate {
    func populateTextView(text: String)
}

protocol newProjectVCToUpVCDelegate {
    func addGoalToUpVC(goal: Goal)
    func editGoalToUpVC(goal: Goal, index: Int)
}

class NewProjectViewController: UIViewController {
    
    //COREDATA stack
    let stack = CoreDataStack.instance
    var selectedGoal: Goal?
    

    //VARIABLES
    var selectedIndex: Int?
    var blurEffectView: UIVisualEffectView?
    var selectedTime = 30
    var descriptionText: String?
    var textViewDelegate: newProjectVCToTextInputViewDelegate!
    var timeInputDelegate: NewProjectVCToTimeInputButtonDelegate!
    var goalDelegate: newProjectVCToUpVCDelegate!

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: OUTLETS
    
    var newProjectLabel: UILabel = {
        let label = UILabel()
        label.text = "What's the next task?"
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        return label
    }()
    
    
    
    var descriptionTextView = SunnyCustomInputView(frame: CGRect(x: 0, y: 0, width: 230, height: 75), fontSize: 18, type: .textView)
    
    
    var taskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 4
        button.setImage(#imageLiteral(resourceName: "whiteRectangle"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
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
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
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
        button.layer.cornerRadius = 30
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: PRIVATE FUNCTIONS
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addOutlets() {
        [newProjectLabel,descriptionTextView, timeButton, addButton, cancelButton].forEach { (view) in
            self.view.addSubview(view)
        }
        descriptionTextView.textDelegate = self
        typeStackView = UIStackView(arrangedSubviews: [sessionButton, taskButton])
        typeStackView.alignment = .fill
        typeStackView.spacing = 35
        self.view.addSubview(typeStackView)
        
    }
    
    private func setConstraints() {

        newProjectLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(125)
            make.centerX.equalToSuperview()
        }
        
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(newProjectLabel.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(100)
        }
        
        
        
        taskButton.snp.makeConstraints { (make) in
            make.height.equalTo(65)
            make.width.equalTo(65)
        }
        
        sessionButton.snp.makeConstraints { (make) in
            make.height.equalTo(65)
            make.width.equalTo(65)
        }
        
        
        typeStackView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(45)
            make.centerX.equalTo(descriptionTextView)
        }
        
        
        timeButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeStackView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(165)
            make.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(timeButton.snp.bottom).offset(-15)
            make.centerX.equalToSuperview()
            make.width.equalTo(125)
            make.height.equalTo(60)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
    }
    
    //if task doesn't have a time
    private func taskButtonModeOn() {
        
            taskButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            taskButton.isSelected = true
            sessionButton.backgroundColor = nil
            sessionButton.isSelected = false
            self.timeButton.isHidden = true
            
            self.addButton.snp.updateConstraints { (make) in
                make.top.equalTo(self.timeButton.snp.bottom).offset(-15)
                make.centerX.equalToSuperview()
                make.width.equalTo(125)
                make.height.equalTo(60)
            }
        
    }
    
    //if task has a time
    private func sessionButtonModeOn() {
        
            sessionButton.isSelected = true
            sessionButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            taskButton.backgroundColor = nil
            taskButton.isSelected = false
            timeButton.isHidden = false
            self.timeButton.alpha = 1
            self.addButton.snp.updateConstraints { (make) in
                make.top.equalTo(self.timeButton.snp.bottom).offset(35)
                make.centerX.equalToSuperview()
                make.width.equalTo(125)
                make.height.equalTo(60)
            }
        
    }
    
    
    //MARK: OBJC FUNCTIONS
    
    
    @objc private func taskButtonSelected() {
        //switching button mode
        if taskButton.isSelected == false {
            taskButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            sessionButton.backgroundColor = nil
            sessionButton.isSelected = false
            taskButton.isSelected = true
            
            self.addButton.snp.updateConstraints { (make) in
                make.top.equalTo(self.timeButton.snp.bottom).offset(-15)
                make.centerX.equalToSuperview()
                make.width.equalTo(125)
                make.height.equalTo(60)
            }
            //hiding timeButton
            UIView.animate(withDuration: 0.3, animations: {
                self.timeButton.alpha = 0
                self.view.layoutIfNeeded()
            }, completion:  {
                (value: Bool) in
                self.timeButton.isHidden = true
            })
            self.view.layoutIfNeeded()
            

        }
    }
    
    
    
    @objc private func sessionButtonSelected() {
        //switching button mode
        
        if sessionButton.isSelected == false {
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
                make.top.equalTo(self.timeButton.snp.bottom).offset(35)
                make.centerX.equalToSuperview()
                make.width.equalTo(125)
                make.height.equalTo(60)
            }
            //showing timeButton
            UIView.animate(withDuration: 0.4, animations: {
                self.timeButton.alpha = 1
                self.view.layoutIfNeeded()
                
            })
        }
    }
    
    
    @objc private func addButtonTapped() {
        guard let text = descriptionText else {
            return
        }
        
        if let goal = selectedGoal {
            
            goal.goalDescription = text
            if sessionButton.isSelected {
                goal.duration = Int32(selectedTime)
            } else {
                goal.duration = Int32(0)
            }
            
            goalDelegate.editGoalToUpVC(goal: goal, index: selectedIndex!)
            
        } else {
            let newGoal = Goal(context: stack.viewContext)
            newGoal.completionDate = nil
            newGoal.date = Date()
            newGoal.goalDescription = text
            if sessionButton.isSelected {
                newGoal.duration = Int32(selectedTime)
            } else {
                newGoal.duration = Int32(0)
            }
            
            goalDelegate.addGoalToUpVC(goal: newGoal)
            
        }
        
        stack.saveTo(context: stack.viewContext)
        
        

        self.dismiss(animated: true)
    }
    
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
        
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            timeInputDelegate.tapStarted()
        }
        
        if gestureRecognizer.state == .ended {
            
            timeInputDelegate.tapEnded()
            
            let nextVC = TimeSelectorViewController()
           nextVC.selectedTime = selectedTime
            
            //MARK: CALLBACK
            //CALLBACK IS RUN WHEN timeSelectorVC is dismissed
            nextVC.onDoneBlock = { (result) in
    
                UIView.animate(withDuration: 0.4, animations: {
                    self.blurEffectView?.alpha = 0
                }, completion:  {
                    (value: Bool) in
                    self.blurEffectView?.isHidden = true
                })
                //THIS IS SENDING THE SELECTED TIME BACK TO THE TIMEINPUTBUTTONVIEW
                self.timeInputDelegate.sendSelectedTime(time: result)
                self.selectedTime = result
            }
            
            blurEffectView?.isHidden = false
            blurEffectView?.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.blurEffectView?.alpha = 0.6
            })
            nextVC.modalPresentationStyle = .overCurrentContext
            self.present(nextVC, animated: true, completion: nil)
        }

    }
    
    
    
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.isHidden = true
        blurEffectView?.alpha = 0.4
        if blurEffectView != nil {
            view.addSubview(blurEffectView!)
        }
    }
    
    
    private func configureEdit() {
        if let goal = selectedGoal {
            
            //Set textview text
            textViewDelegate.populateTextView(text: goal.goalDescription!)
            
            if Int(goal.duration) > 0 {
                sessionButtonModeOn()
                //setting time of timeInputButton
                timeInputDelegate.sendSelectedTime(time: Int(goal.duration))
                
            } else {
                taskButtonModeOn()
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.minimumPressDuration = 0
        timeButton.addGestureRecognizer(tap)
        hideKeyboard()
        configNavBar()
        addOutlets()
        addBlur()
        setConstraints()
        timeInputDelegate = timeButton
        textViewDelegate = descriptionTextView
        configureEdit()
        
        
        // Do any additional setup after loading the view.
    }
    

    
}

extension NewProjectViewController: CustomTextViewToNewProjVCDelegate {
    func sendText(text: String) {
        descriptionText = text
    }
    
}




//From NewProjectVC back to TimeInputButton
protocol NewProjectVCToTimeInputButtonDelegate {
    
    func sendSelectedTime(time: Int)
    
    func tapStarted()
    
    func tapEnded()
}

