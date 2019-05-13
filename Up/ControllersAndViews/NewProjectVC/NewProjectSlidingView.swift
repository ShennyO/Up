//
//  NewProjectSlidingView.swift
//  Up
//
//  Created by Sunny Ouyang on 5/12/19.
//

import UIKit

class NewProjectSlidingView: UIView {
    
    //MARK: VARIABLES
    var descriptionText: String?
    
    //MARK: OUTLETS
    
    var topHorizontalView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.pureWhite
        view.layer.cornerRadius = 4
        return view
    }()
    
    var newTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "What's the next task?"
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 25))
        return label
    }()
    
    var descriptionTextView = SunnyCustomInputView(frame: CGRect(x: 0, y: 0, width: 230, height: 75), fontSize: widthScaleFactor(distance: 18), type: .textView)
    
    var taskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        button.layer.cornerRadius = 4
        button.setImage(#imageLiteral(resourceName: "whiteRectangle"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.isSelected = true
//        button.addTarget(self, action: #selector(taskButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var sessionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setImage(#imageLiteral(resourceName: "whiteTimeIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        button.isSelected = false
//        button.addTarget(self, action: #selector(sessionButtonSelected), for: .touchUpInside)
        return button
    }()
    
    var typeStackView: UIStackView!
    
    var timeButton = TimeInputViewButton(frame: CGRect(x: 0, y: 0, width: 165, height: 50))
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = widthScaleFactor(distance: 30)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 25))
        button.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
//        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private func addOutlets() {
        [topHorizontalView, newTaskLabel,descriptionTextView, timeButton, addButton].forEach { (view) in
            self.addSubview(view)
        }
        descriptionTextView.textDelegate = self
        typeStackView = UIStackView(arrangedSubviews: [sessionButton, taskButton])
        typeStackView.alignment = .fill
        typeStackView.spacing = 35
        self.addSubview(typeStackView)
    }
    
    private func setConstraints() {
        
        topHorizontalView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(6)
        }
        
        newTaskLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
        }
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(newTaskLabel.snp.bottom).offset(heightScaleFactor(distance: 48))
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-32)
            make.height.equalTo(widthScaleFactor(distance: 100))
        }
        
        taskButton.snp.makeConstraints { (make) in
            make.height.equalTo(widthScaleFactor(distance: 66))
            make.width.equalTo(widthScaleFactor(distance: 66))
        }
        
        sessionButton.snp.makeConstraints { (make) in
            make.height.equalTo(widthScaleFactor(distance: 66))
            make.width.equalTo(widthScaleFactor(distance: 66))
        }
        
        typeStackView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(widthScaleFactor(distance: 48))
            make.centerX.equalTo(descriptionTextView)
        }
        
        timeButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeStackView.snp.bottom).offset(widthScaleFactor(distance: 32))
            make.centerX.equalToSuperview()
            make.width.equalTo(widthScaleFactor(distance: 166))
            make.height.equalTo(widthScaleFactor(distance: 56))
        }
        
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(typeStackView.snp.bottom).offset(widthScaleFactor(distance: 48))
            make.centerX.equalToSuperview()
            make.width.equalTo(widthScaleFactor(distance: 128))
            make.height.equalTo(widthScaleFactor(distance: 60))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addOutlets()
        setConstraints()
        roundCorners([.topLeft, .topRight], radius: 8)
        self.backgroundColor = Style.Colors.Palette01.gunMetal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewProjectSlidingView: CustomTextViewToNewProjVCDelegate {
    
    func sendText(text: String) {
        descriptionText = text
    }
    
}
