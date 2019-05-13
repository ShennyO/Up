//
//  NewTaskViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 5/12/19.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    //MARK: VARIABLES
    var originalPosMinY: CGFloat?
    var startPosition: CGPoint?
    var panGesture = UIPanGestureRecognizer()
    
    //MARK: OUTLETS
    let containerView = NewProjectSlidingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    //MARK: FUNCTIONS
    private func setUpGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        panGesture.delegate = self
        originalPosMinY = self.containerView.frame.minY
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(panGesture)
    }
    
    
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer) {
        
        self.view.bringSubviewToFront(containerView)
        
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
            let distanceFromTop = currentPosY - 120
            let distanceFromBot = UIScreen.main.bounds.height - currentPosY
            
            if currentPosY < minPos + 375 {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        self.view.addSubview(containerView)
        setUpGesture()
        hideKeyboardWhenTappedAround()
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(120)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
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
