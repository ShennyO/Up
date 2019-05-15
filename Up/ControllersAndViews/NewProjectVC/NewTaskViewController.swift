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


class NewTaskViewController: UIViewController {
    
    //MARK: VARIABLES
    let stack = CoreDataStack.instance
    var selectedGoal: Goal?
    var sessionButtonSelected = false
    
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
            slidingViewDelegate.sessionModeOn()
            //setting time of timeInputButton
            slidingViewDelegate.sendSelectedTimeForEdit(time: Int(selectedGoal!.duration))
            
        } else {
            slidingViewDelegate.taskModeOn()
        }
    }
    
    //MARK: OBJC FUNCTIONS
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer) {
        
//        self.view.bringSubviewToFront(containerView)
        
        let currentPosY = self.containerView.frame.minY
        
        switch sender.state {
            
        case .began:
            
            startPosition = self.containerView.center
            
        case .changed:
            
            let translation = sender.translation(in: self.view)
            guard let start = self.startPosition else { return }
            let newCenter = CGPoint(x: start.x, y: start.y + max(translation.y, 0))
            self.containerView.center = newCenter
            
        default:
            
            guard let minPos = originalPosMinY else {return}
            let distanceFromTop = currentPosY - heightScaleFactor(distance: 120)
            let distanceFromBot = (UIScreen.main.bounds.height - currentPosY) / 2
            
            if currentPosY < minPos + heightScaleFactor(distance: 375) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.containerView.center.y -= distanceFromTop
                })
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.dismiss(animated: true, completion: nil)
                }
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.containerView.center.y += (distanceFromBot)
                })
                
            }
        }
        
    }
    
    private func addOutlets() {
        self.view.addSubview(containerView)
        self.view.addSubview(timeSelectorView)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 120))
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
        addOutlets()
        setConstraints()
        setUpGesture()
        slidingViewDelegate = containerView
        containerView.newTaskVCDelegate = self
        configureEdit()
        hideKeyboardWhenTappedAround()
        
        
        timeSelectorView.isUserInteractionEnabled = true
        
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
        self.dismiss(animated: true)
    }
    
    func configGestureStatus(status: Bool) {
        panGesture.isEnabled = status
    }
    
}



