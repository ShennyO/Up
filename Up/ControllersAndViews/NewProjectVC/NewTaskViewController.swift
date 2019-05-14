//
//  NewTaskViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 5/12/19.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    
    //MARK: PANGESTURE VARIABLES
    var originalPosMinY: CGFloat?
    var startPosition: CGPoint?
    var panGesture = UIPanGestureRecognizer()
    
    //MARK: OUTLETS
    let containerView = newTaskSlidingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let timeSelectorView = TimeSelectorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: widthScaleFactor(distance: 352)))
    
    //MARK: FUNCTIONS
    private func setUpGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        panGesture.delegate = self
        originalPosMinY = self.containerView.frame.minY
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(panGesture)
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
            let distanceFromBot = UIScreen.main.bounds.height - currentPosY
            
            if currentPosY < minPos + heightScaleFactor(distance: 375) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.containerView.center.y -= distanceFromTop
                })
            } else {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                    self.containerView.center.y += (distanceFromBot)
                }) { (res) in
                    self.dismiss(animated: true, completion: nil)
                }
                
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
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        addOutlets()
        setConstraints()
        setUpGesture()
        hideKeyboardWhenTappedAround()
        containerView.newTaskVCDelegate = self
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
    
    func timeButtonTapped(status: Bool) {
        panGesture.isEnabled = status
    }
    
}
