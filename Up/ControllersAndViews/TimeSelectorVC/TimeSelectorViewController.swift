//
//  TimeSelectorViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/12/19.
//

import UIKit

class TimeSelectorViewController: UIViewController {

    //MARK: VARIABLES
    var times: [Int] = []
    var selectedTime = 30
    var onDoneBlock: ((Int) -> ())?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: OUTLETS
    let containerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        view.layer.cornerRadius = 8
        return view
        
    }()
    
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
        self.view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(timePickerView)
        containerView.addSubview(doneButton)
    }
    
    private func setConstraints() {
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(heightScaleFactor(distance: 200))
            make.left.right.equalToSuperview().inset(widthScaleFactor(distance: 80))
            make.height.equalTo(widthScaleFactor(distance: 352))
        }
        
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
    
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func dismissVCGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissVC))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissVC() {
        onDoneBlock!(selectedTime)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        print("Tapped")
        onDoneBlock!(selectedTime)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for x in 1...60 {
            times.append(x)
        }
        configNavBar()
        dismissVCGesture()
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        timePickerView.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        timePickerView.layer.cornerRadius = 4
        timePickerView.delegate = self
        timePickerView.dataSource = self
        timePickerView.selectRow(selectedTime - 1, inComponent: 0, animated: false)
        addOutlets()
        setConstraints()
        // Do any additional setup after loading the view.
    }
    
    
}

extension TimeSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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

