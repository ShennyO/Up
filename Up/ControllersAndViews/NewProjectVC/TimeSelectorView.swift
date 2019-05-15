//
//  TimeSelectorView.swift
//  Up
//
//  Created by Sunny Ouyang on 5/13/19.
//

import UIKit



class TimeSelectorView: UIView {

    //MARK: VARIABLES
    var times: [Int] = []
    var selectedTime = 30
    var onDoneBlock: ((Int) -> ())?

    
    //MARK: OUTLETS
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select duration"
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 25))
        return label
    }()
    
    let timePickerView = MyPickerView()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 25))
        return button
    }()
    
    private func addOutlets() {
        self.addSubview(titleLabel)
        self.addSubview(timePickerView)
        self.addSubview(doneButton)
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 45))
            make.centerX.equalToSuperview()
        }
        
        timePickerView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(heightScaleFactor(distance: 10))
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(widthScaleFactor(distance: 185))
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(timePickerView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(widthScaleFactor(distance: 45))
            make.width.equalTo(widthScaleFactor(distance: 125))
        }
        
    }
    
    func dismissVCGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissVC))
        
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissVC() {
        onDoneBlock!(selectedTime)
    }
    
    @objc func doneButtonTapped() {
        onDoneBlock!(selectedTime)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for x in 1...60 {
            times.append(x)
        }
        self.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        self.layer.cornerRadius = 8
        timePickerView.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        timePickerView.layer.cornerRadius = 4
        timePickerView.delegate = self
        timePickerView.dataSource = self
        timePickerView.selectRow(selectedTime - 1, inComponent: 0, animated: false)
        addOutlets()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TimeSelectorView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel: UILabel = {
            let label = UILabel()
            if times[row] != 1 {
                label.text = String(describing: times[row]) + " minutes"
            } else {
                label.text = String(describing: times[row]) + " minute"
            }
            
            label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 25))
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
