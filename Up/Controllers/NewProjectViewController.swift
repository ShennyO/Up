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
    var times = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    
    
    
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
        textView.tag = 1
        return textView
    }()
    
    var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Optional description"
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
    
    var timePicker: UIPickerView = {
        let picker = MyPickerView()
        picker.backgroundColor = UIColor.black
        picker.layer.cornerRadius = 4
        picker.isHidden = true
        return picker
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.addTarget(self, action: #selector(sessionButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
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
        [titleLabel,titleTextView,descriptionLabel,descriptionTextView, typeLabel, timePicker, addButton, cancelButton].forEach { (view) in
            self.view.addSubview(view)
        }
        typeStackView = UIStackView(arrangedSubviews: [sessionButton, taskButton])
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
        
        timePicker.snp.makeConstraints { (make) in
            make.top.equalTo(typeStackView.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(100)
            make.left.equalTo(typeStackView)
        }

        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(timePicker.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(110)
            make.height.equalTo(45)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(20)
//            make.width.equalTo(55)
        }
        
    }
    
    @objc private func taskButtonSelected() {
        //switching button mode
        if taskButton.isSelected == false {
            taskButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            sessionButton.backgroundColor = nil
            sessionButton.isSelected = false
            taskButton.isSelected = true
            
            //animate alpha value of picker to be 0, then set hide picker view
            UIView.animate(withDuration: 0.4, animations: {
                self.timePicker.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.timePicker.isHidden = true
            })
        }
    }
    
    @objc private func sessionButtonSelected() {
        //switching button mode
        if sessionButton.isSelected == false {
            sessionButton.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
            taskButton.backgroundColor = nil
            sessionButton.isSelected = true
            taskButton.isSelected = false
            timePicker.isHidden = false
            timePicker.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.timePicker.alpha = 1
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        titleTextView.delegate = self
        timePicker.delegate = self
        timePicker.dataSource = self
        configNavBar()
        addOutlets()
        setConstraints()
        timePicker.selectRow(3, inComponent: 0, animated: false)
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
        if textView.text.isEmpty && textView.tag != 1 {
            textView.text = "Optional description"
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


extension NewProjectViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel: UILabel = {
            let label = UILabel()
            label.text = String(describing: times[row]) + " minutes"
            label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
            label.textAlignment = .left
            label.textColor = UIColor.white
            return label
            
        }()
        return pickerLabel
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    

    
}
