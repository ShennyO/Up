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
    
    private func setUpDismissalGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.darkView.addGestureRecognizer(tap)
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
    
    @objc func dismissView() {
        self.view.endEditing(true)
        self.darkView.backgroundColor = UIColor.clear
        dismiss(animated: true, completion: nil)
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer) {
        
        let currentPosY = self.containerView.frame.minY
        let currentAlpha = backgroundColorAlpha - (abs(heightScaleFactor(distance: 210) - currentPosY) / 700)
        
        switch sender.state {
            
        case .began:
            startPosition = self.containerView.center
            
        case .changed:
            
            let translation = sender.translation(in: self.view)
            guard let start = self.startPosition else { return }
            // translation is always to the bottom, so positive, can't go up
        
            let newCenter = CGPoint(x: start.x, y: start.y + max(translation.y, 0))
            self.containerView.center = newCenter
            self.darkView.backgroundColor = #colorLiteral(red: 0.2058082521, green: 0.2050952315, blue: 0.2267607152, alpha: 1).withAlphaComponent(currentAlpha)
            
        default:
            
            guard let minPos = originalPosMinY else {return}
            
            let distanceFromTop = currentPosY - heightScaleFactor(distance: 210)
            let distanceFromBot = (UIScreen.main.bounds.height - currentPosY)
            
            if currentPosY < minPos + heightScaleFactor(distance: 375) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.containerView.center.y -= distanceFromTop
                    self.darkView.backgroundColor = #colorLiteral(red: 0.2058082521, green: 0.2050952315, blue: 0.2267607152, alpha: 1).withAlphaComponent(0.7)
                })
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.containerView.center.y += distanceFromBot
                    self.darkView.backgroundColor = #colorLiteral(red: 0.2058082521, green: 0.2050952315, blue: 0.2267607152, alpha: 1).withAlphaComponent(0)
                }, completion: { (res) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                        self.dismiss(animated: false, completion: nil)
                    })
                })
            }
        }
    }
    
    private func addOutlets() {
        self.view.addSubview(darkView)
        self.view.addSubview(containerView)
    }
    
    private func setConstraints() {
        darkView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 210))
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        addOutlets()
        setConstraints()
        setUpGesture()
        setUpDismissalGesture()
        slidingViewDelegate = containerView
        containerView.newTaskVCDelegate = self
        configureEdit()
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
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
            self.containerView.center.y += (UIScreen.main.bounds.height - self.originalPosMinY!)
            self.darkView.backgroundColor = #colorLiteral(red: 0.2058082521, green: 0.2050952315, blue: 0.2267607152, alpha: 1).withAlphaComponent(0)
        }, completion: { (res) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                self.dismiss(animated: false, completion: nil)
            })
        })
    }
    
    func configGestureStatus(status: Bool) {
        panGesture.isEnabled = status
    }
    
}



