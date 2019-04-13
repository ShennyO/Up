//
//  timeSelectorViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/12/19.
//

import UIKit

class timeSelectorViewController: UIViewController {

    //MARK: VARIABLES
    var times = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: OUTLETS
    let containerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        view.layer.cornerRadius = 7
        return view
        
    }()
    
    let timePickerView = MyPickerView()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        return button
    }()
    
    private func addOutlets() {
        self.view.addSubview(containerView)
        containerView.addSubview(timePickerView)
        containerView.addSubview(doneButton)
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.left.equalToSuperview().offset(85)
            make.right.equalToSuperview().offset(-85)
            make.height.equalTo(300)
        }
        
        timePickerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(45)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(185)
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(timePickerView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(125)
        }
        
    }
    
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
//        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.view.isOpaque = false
        timePickerView.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        timePickerView.layer.cornerRadius = 4
        timePickerView.delegate = self
        timePickerView.dataSource = self
        timePickerView.selectRow(3, inComponent: 0, animated: false)
        addOutlets()
        setConstraints()
        // Do any additional setup after loading the view.
    }
    
    
}

extension timeSelectorViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel: UILabel = {
            let label = UILabel()
            label.text = String(describing: times[row]) + " minutes"
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



}

