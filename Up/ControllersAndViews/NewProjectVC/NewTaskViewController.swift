//
//  NewTaskViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 5/12/19.
//

import UIKit

protocol newProjectVCToUpVCDelegate: class {
    func addGoalToUpVC(goal: Goal)
    func editGoalToUpVC(goal: Goal, index: Int)
}

protocol newTaskVCToSlidingViewDelegate: class {
    func sessionModeOn()
    func taskModeOn()
    func sendGoalDescription(desc: String)
    func sendSelectedTimeForEdit(time: Int)
}


class NewTaskViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    //MARK: VARIABLES
    let stack = CoreDataStack.instance
    var selectedGoal: Goal?
    var sessionButtonSelected = false
    var backgroundColorAlpha: CGFloat = 0.7
    
    var selectedIndex: Int?
    var selectedTime = 30
    var descriptionText: String?
    
    //MARK: DELEGATES
    weak var upVCDelegate: newProjectVCToUpVCDelegate!
    weak var slidingViewDelegate: newTaskVCToSlidingViewDelegate!

    
    //MARK: PANGESTURE VARIABLES
    var originalPosMinY: CGFloat?
    var startPosition: CGPoint?
    var panGesture = UIPanGestureRecognizer()
    
    //MARK: OUTLETS
    let containerView = NewTaskSlidingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let timeSelectorView = TimeSelectorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: widthScaleFactor(distance: 352)))
    
    let darkView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2058082521, green: 0.2050952315, blue: 0.2267607152, alpha: 1).withAlphaComponent(0.7)
        return view
    }()
    
    //MARK: FUNCTIONS
    private func setUpGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        panGesture.delegate = self
        originalPosMinY = self.containerView.frame.minY
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(panGesture)
    }
    
    private func configureEdit() {

        if selectedGoal == nil {
            return
        }
        
        slidingViewDelegate.sendGoalDescription(desc: selectedGoal!.goalDescription!)
        
        if Int(selectedGoal!.duration) > 0 {
            selectedTime = Int(selectedGoal!.duration)
            sessionButtonSelected = true
            slidingViewDelegate.sessionModeOn()
            slidingViewDelegate.sendSelectedTimeForEdit(time: Int(selectedGoal!.duration))
            
        } else {
            slidingViewDelegate.taskModeOn()
        }
    }
    
    //MARK: OBJC FUNCTIONS
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer) {
        
        let currentPosY = self.containerView.frame.minY
        let currentAlpha = backgroundColorAlpha - (abs(heightScaleFactor(distance: 200) - currentPosY) / 700)
        
        switch sender.state {
            
        case .began:
            
            view.endEditing(true)
            startPosition = self.containerView.center
            
        case .changed:
            
            let translation = sender.translation(in: self.view)
            guard let start = self.startPosition else { return }
            let newCenter = CGPoint(x: start.x, y: start.y + max(translation.y, 0))
            self.containerView.center = newCenter
            self.darkView.backgroundColor = #colorLiteral(red: 0.2058082521, green: 0.2050952315, blue: 0.2267607152, alpha: 1).withAlphaComponent(currentAlpha)
            
        default:
            
            guard let minPos = originalPosMinY else {return}
            
            let distanceFromTop = currentPosY - heightScaleFactor(distance: 200)
            let distanceFromBot = (UIScreen.main.bounds.height - currentPosY) / 2
            
            if currentPosY < minPos + heightScaleFactor(distance: 375) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.containerView.center.y -= distanceFromTop
                    self.darkView.backgroundColor = #colorLiteral(red: 0.2058082521, green: 0.2050952315, blue: 0.2267607152, alpha: 1).withAlphaComponent(0.7)
                })
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.dismiss(animated: true, completion: nil)
                }
                
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.containerView.center.y += (distanceFromBot)
                    self.darkView.backgroundColor = #colorLiteral(red: 0.2058082521, green: 0.2050952315, blue: 0.2267607152, alpha: 1).withAlphaComponent(0)
                })
            }
        }
    }
    
    private func addOutlets() {
        self.view.addSubview(darkView)
        self.view.addSubview(containerView)
        self.view.addSubview(timeSelectorView)
    }
    
    private func setConstraints() {
        darkView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 200))
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        timeSelectorView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(heightScaleFactor(distance: 352))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 80))
            make.height.equalTo(heightScaleFactor(distance: 352))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        addOutlets()
        setConstraints()
        setUpGesture()
        slidingViewDelegate = containerView
        containerView.newTaskVCDelegate = self
        configureEdit()
        hideKeyboardWhenTappedAround()
        timeSelectorView.isUserInteractionEnabled = true
    }
    
    deinit {
        print("newTaskVC deinitialized!")
    }

}

extension NewTaskViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension NewTaskViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NewTaskViewController: NewTaskSlidingViewToNewTaskVCDelegate {
    
    func sendDefaultTime(time: Int) {
        if selectedTime == 0 {
            selectedTime = time
        }
    }
    
    func sendSetTime(time: Int) {
        selectedTime = time
    }
    
    func sendTextViewText(text: String) {
        descriptionText = text
    }
    
    func sessionButtonTapped() {
        sessionButtonSelected = true
    }
    
    func taskButtonTapped() {
        sessionButtonSelected = false
    }
    
    func addButtonTapped() {
        guard let text = descriptionText else {
            return
        }
        
        if let goal = selectedGoal {
            
            goal.goalDescription = text
            if sessionButtonSelected {
                goal.duration = Int32(selectedTime)
            } else {
                goal.duration = Int32(0)
            }
            
            upVCDelegate.editGoalToUpVC(goal: goal, index: selectedIndex!)
            
        } else {
            
            let goals = stack.fetchGoal(type: .all, completed: .incomplete, sorting: .listOrderNumberAscending) as? [Goal] ?? []
            
            let newGoal = Goal(context: stack.viewContext)
            newGoal.completionDate = nil
            newGoal.listOrderNumber = 0
            for x in goals {
                x.listOrderNumber += 1
            }
            newGoal.date = Date()
            newGoal.goalDescription = text
            if sessionButtonSelected {
                newGoal.duration = Int32(selectedTime)
            } else {
                newGoal.duration = Int32(0)
            }
            
            upVCDelegate.addGoalToUpVC(goal: newGoal)
            
        }
        
        stack.saveTo(context: stack.viewContext)
        
        self.darkView.backgroundColor = UIColor.clear
        
        self.dismiss(animated: true)
    }
    
    func configGestureStatus(status: Bool) {
        panGesture.isEnabled = status
    }
    
}



