//
//  CongratulationsView.swift
//  Up
//
//  Created by Sunny Ouyang on 4/19/19.
//

import UIKit

protocol CongratsViewToSessionVCDelegate: class {
    func dismissTapped()
    func addButtonTapped(time: Int)
}

class CongratulationsView: UIView {
    
    //MARK: VARIABLES
    weak var delegate: CongratsViewToSessionVCDelegate!
    var times: [Int] = []
    var selectedTime = 5
    
    //MARK: CONGRATS OUTLETS
    let congratulationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 35))
        label.textColor = UIColor.white
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You completed the task!"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 20))
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 25))
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        return button
    }()
    
    let moreTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Not done yet?"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 11))
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    let moreTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(showAddMore), for: .touchUpInside)
        button.setTitle("Add more time", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 14))
        return button
    }()
    
    //MARK: MORE TIME OUTLETS
    
    let addMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Add more time"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 25))
        label.textColor = UIColor.white
        label.isHidden = true
        return label
    }()
    
    let durationPicker = MyPickerView()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = widthScaleFactor(distance: 20)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 20))
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        button.isHidden = true
        return button
    }()
    
    let doneLabel: UILabel = {
        let label = UILabel()
        label.text = "Done?"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 11))
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    let returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(showCongrats), for: .touchUpInside)
        button.setTitle("Return", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 14))
        button.isHidden = true
        return button
    }()
    
    
    //MARK: FUNCTIONS
    private func setUpTimes() {
        for x in 1...60 {
            times.append(x)
        }
    }
    
    private func addOutlets() {
        [congratulationsLabel,descriptionLabel,dismissButton,moreTimeButton,moreTimeLabel,addMoreLabel, durationPicker,addButton,doneLabel,returnButton].forEach { (view) in
            self.addSubview(view)
        }
    }
    
    private func setConstraints() {
        
        congratulationsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(widthScaleFactor(distance: 35))
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(congratulationsLabel.snp.bottom).offset(widthScaleFactor(distance: 35))
            make.centerX.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.height.equalTo(widthScaleFactor(distance: 60))
            make.width.equalTo(widthScaleFactor(distance: 150))
            make.top.equalTo(descriptionLabel.snp.bottom).offset(widthScaleFactor(distance: 50))
            make.centerX.equalToSuperview()
        }
        
        moreTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dismissButton.snp.bottom).offset(widthScaleFactor(distance: 20))
            make.centerX.equalToSuperview()
        }
        
        moreTimeButton.snp.makeConstraints { (make) in
            make.top.equalTo(moreTimeLabel.snp.bottom).offset(-1)
            make.centerX.equalToSuperview()
        }
        
        addMoreLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(widthScaleFactor(distance: 35))
            make.centerX.equalToSuperview()
        }
        
        durationPicker.snp.makeConstraints { (make) in
            make.top.equalTo(addMoreLabel.snp.bottom).offset(widthScaleFactor(distance: 10))
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(widthScaleFactor(distance: 125))
        }
        
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(durationPicker.snp.bottom).offset(widthScaleFactor(distance: 10))
            make.centerX.equalToSuperview()
            make.height.equalTo(widthScaleFactor(distance: 40))
            make.width.equalTo(widthScaleFactor(distance: 90))
        }
        
        doneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addButton.snp.bottom).offset(widthScaleFactor(distance: 15))
            make.centerX.equalToSuperview()
        }
        
        returnButton.snp.makeConstraints { (make) in
            make.top.equalTo(doneLabel.snp.bottom).offset(-1)
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc private func showAddMore() {
        durationPicker.selectRow(4, inComponent: 0, animated: false)
        //hide congrats view
        [congratulationsLabel, descriptionLabel, dismissButton, moreTimeLabel, moreTimeButton].forEach { (view) in
            
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 0
                self.backgroundColor = #colorLiteral(red: 0.1105717048, green: 0.1099219099, blue: 0.1110760495, alpha: 1)
            }, completion:  {
                (value: Bool) in
                view.isHidden = true
            })
        }
        
        //show add more
        [addMoreLabel,durationPicker,addButton,doneLabel,returnButton].forEach { (view) in
            
            view.isHidden = false
            view.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                view.alpha = 1
            })
            
        }
    }
    
    @objc private func showCongrats() {
        
        //hide add more
        [addMoreLabel,durationPicker,addButton,doneLabel,returnButton].forEach { (view) in
            
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 0
                self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }, completion:  {
                (value: Bool) in
                view.isHidden = true
            })
        }
        
        //show congrats
        [congratulationsLabel, descriptionLabel, dismissButton, moreTimeLabel, moreTimeButton].forEach { (view) in
            
            view.isHidden = false
            view.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                view.alpha = 1
            })
        }
    }
    
    @objc private func addButtonTapped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showCongrats()
        }
        delegate.addButtonTapped(time: selectedTime)
    }
    
    @objc private func dismissButtonTapped() {
        delegate.dismissTapped()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        durationPicker.isHidden = true
        durationPicker.delegate = self
        durationPicker.dataSource = self
        setUpTimes()
        addOutlets()
        setConstraints()
        
    }
    
    deinit {
        print("Congrats View Deinitialized!")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension CongratulationsView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel: UILabel = {
            let label = UILabel()
            if times[row] == 1 {
                label.text = String(describing: times[row]) + " minute"
            } else {
                label.text = String(describing: times[row]) + " minutes"
            }
            
            label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
            label.textAlignment = .center
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = times[row]
    }

}
