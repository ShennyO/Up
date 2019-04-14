//
//  NewProjectViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import UIKit

class NewProjectViewController: UIViewController {
    
    
    
    
    //VARIABLES
    var projectToReturn: Project!
    var timedProjectToReturn: timedProject!
    var blurEffectView: UIVisualEffectView?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    //MARK: OUTLETS
    
    var newProjectLabel: UILabel = {
        let label = UILabel()
        label.text = "New Goal"
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 35)
        return label
    }()
    
//    var titleTextField = SunnyCustomInputView(frame: CGRect(x: 0, y: 0, width: 230, height: 50), fontSize: 20, type: .textField)
    
    
    var descriptionTextView = SunnyCustomInputView(frame: CGRect(x: 0, y: 0, width: 230, height: 100), fontSize: 18, type: .textView)
    
    
    
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
    
    
    var timeButton = timeInputViewButton(frame: CGRect(x: 0, y: 0, width: 200, height: 75))
    
    var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
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
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
    }
    
    @objc private func taskButtonSelected() {
        //switching button mode
        if taskButton.isSelected == false {
            taskButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            sessionButton.backgroundColor = nil
            sessionButton.isSelected = false
            taskButton.isSelected = true
            UIView.animate(withDuration: 0.3, animations: {
                self.timeButton.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.timeButton.isHidden = true
            })
            
            UIView.animate(withDuration: 0.4) {
                self.addButton.frame = CGRect(x: self.addButton.frame.origin.x, y: self.addButton.frame.origin.y - 60, width: self.addButton.frame.width, height: self.addButton.frame.height)
            }

        }
    }
    
    @objc private func sessionButtonSelected() {
        //switching button mode
        if sessionButton.isSelected == false {
            sessionButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            taskButton.backgroundColor = nil
            sessionButton.isSelected = true
            taskButton.isSelected = false
            timeButton.isHidden = false
            timeButton.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.timeButton.alpha = 1
                
            })
            
            UIView.animate(withDuration: 0.3) {
                self.addButton.frame = CGRect(x: self.addButton.frame.origin.x, y: self.addButton.frame.origin.y + 60, width: self.addButton.frame.width, height: self.addButton.frame.height)
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
        
    }
    
    @objc func handleTap() {
        let nextVC = timeSelectorViewController()
        //BLOCK
        nextVC.onDoneBlock = { result in
            // Do something
            UIView.animate(withDuration: 0.4, animations: {
                self.blurEffectView?.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.blurEffectView?.isHidden = true
            })
        }
        blurEffectView?.isHidden = false
        blurEffectView?.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView?.alpha = 0.6
        })
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true, completion: nil)
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        timeButton.addGestureRecognizer(tap)
        configNavBar()
        addOutlets()
        addBlur()
        setConstraints()
        
        // Do any additional setup after loading the view.
    }
    

    
}


