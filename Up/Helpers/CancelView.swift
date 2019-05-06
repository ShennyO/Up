//
//  CancelView.swift
//  Up
//
//  Created by Sunny Ouyang on 5/6/19.
//

import UIKit


protocol CancelViewToSessionVCDelegate: class {
    func yesTapped()
    func cancelTapped()
}

class CancelView: UIView {

    //MARK: VARIABLES
    weak var delegate: CancelViewToSessionVCDelegate!
    
    //MARK: OUTLETS
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        label.text = "Task in progress"
        label.textColor = UIColor.white
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.text = "Are you sure you want to exit? All progress will be lost."
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 0.1105717048, green: 0.1099219099, blue: 0.1110760495, alpha: 1)
        button.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)
        button.setTitle("Yes, I'm sure", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Style.Colors.Palette01.mainBlue
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        return button
        
    }()
    
    var buttonStackView: UIStackView!
    
    var horizontalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    
    var verticalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    
    private func addOutlets() {
        [titleLabel, descriptionLabel].forEach { (view) in
            self.addSubview(view)
        }
        
        buttonStackView = UIStackView(arrangedSubviews: [yesButton, cancelButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        self.addSubview(buttonStackView)
        self.addSubview(horizontalSeparatorView)
        self.addSubview(verticalSeparatorView)
        
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(15)
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        horizontalSeparatorView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(buttonStackView.snp.top)
            make.height.equalTo(1)
        }
        
        verticalSeparatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonStackView.snp.top)
            make.height.equalTo(45)
            make.width.equalTo(1)
        }
        
    }
    
    @objc private func cancelTapped() {
        delegate.cancelTapped()
    }
    
    @objc private func yesTapped() {
        delegate.yesTapped()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.1105717048, green: 0.1099219099, blue: 0.1110760495, alpha: 1)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        addOutlets()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CancelView deinitialized!")
    }
    
}
