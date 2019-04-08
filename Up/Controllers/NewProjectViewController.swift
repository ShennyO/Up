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
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: OUTLETS
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
    
    var titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 22)
        textView.layer.cornerRadius = 3
        return textView
    }()
    
    var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Optional"
        textView.textColor = UIColor.lightGray
        textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        textView.layer.cornerRadius = 3
        return textView
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
    
    var taskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 4
        button.setTitle("Task", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.isSelected = true
        button.addTarget(self, action: #selector(taskButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var sessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitle("Session", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.isSelected = false
        button.addTarget(self, action: #selector(sessionButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var typeStackView: UIStackView!
    
    
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
        [titleLabel,titleTextView,descriptionLabel,descriptionTextView, typeLabel].forEach { (view) in
            self.view.addSubview(view)
        }
        typeStackView = UIStackView(arrangedSubviews: [taskButton, sessionButton])
        typeStackView.alignment = .fill
        typeStackView.spacing = 15
        self.view.addSubview(typeStackView)
        
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(150)
        }
        titleTextView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(15)
            make.top.equalToSuperview().offset(150)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(75)
            make.left.equalToSuperview().offset(20)
        }
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(75)
            make.left.equalTo(descriptionLabel.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(75)
            make.left.equalToSuperview().offset(20)
        }
        
        taskButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(70)
        }
        
        sessionButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        
        typeStackView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(65)
            make.centerX.equalTo(descriptionTextView)
        }

    }
    
    @objc private func taskButtonSelected() {
        //switching button mode
        if !taskButton.isSelected {
            taskButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            sessionButton.backgroundColor = nil
            sessionButton.isSelected = false
            taskButton.isSelected = true
        }
        
    }
    
    @objc private func sessionButtonSelected() {
        //switching button mode
        if !sessionButton.isSelected {
            sessionButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            taskButton.backgroundColor = nil
            sessionButton.isSelected = true
            taskButton.isSelected = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        configNavBar()
        addOutlets()
        setConstraints()
        titleLabel.text = "Title:"
        descriptionLabel.text = "Desc:"
        typeLabel.text = "Type:"
        // Do any additional setup after loading the view.
    }
    

    
}


extension NewProjectViewController: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Optional"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


