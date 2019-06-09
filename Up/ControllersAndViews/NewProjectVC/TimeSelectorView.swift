//
//  TimeSelectorView.swift
//  Up
//
//  Created by Sunny Ouyang on 5/13/19.
//

import UIKit

protocol TimeSelectorViewToNewTaskSlidingViewDelegate: class {
    func sendSelectedTime(time: Int)
    func doneButtonTapped()
}

class TimeSelectorView: UIView {

    //MARK: VARIABLES
    var times: [Int] = []
    var selectedTime = 30
    weak var slidingViewDelegate: TimeSelectorViewToNewTaskSlidingViewDelegate!
    var onDoneBlock: ((Int) -> ())?

    
    //MARK: OUTLETS
    
    let timePickerView = UIPickerView()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Style.Colors.Palette01.mainBlue
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 17))
        button.titleEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        return button
    }()
    
    private func addOutlets() {
        self.addSubview(timePickerView)
        self.addSubview(doneButton)
    }
    
    private func setConstraints() {
        timePickerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(heightScaleFactor(distance: 40))
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(widthScaleFactor(distance: heightScaleFactor(distance: 135)))
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(widthScaleFactor(distance: 45))
            make.left.right.equalToSuperview().inset(20)
        }
        
    }
    
    @objc func doneButtonTapped() {
        slidingViewDelegate.doneButtonTapped()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for x in 1...60 {
            times.append(x)
        }
        self.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
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
            
            label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 20))
            label.textAlignment = .center
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
        slidingViewDelegate.sendSelectedTime(time: selectedTime)
    }
    
}


extension TimeSelectorView: NewTaskViewToTimeSelectorViewDelegate {
    
    func setSelectedTimeForPicker(time: Int) {
        selectedTime = time
        timePickerView.selectRow(selectedTime - 1, inComponent: 0, animated: false)
    }
}
