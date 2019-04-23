//
//  CongratulationsView.swift
//  Up
//
//  Created by Sunny Ouyang on 4/19/19.
//

import UIKit

protocol CongratsViewToSessionViewDelegate {
    func dismissTapped()
}

class CongratulationsView: UIView {
    
    //MARK: VARIABLES
    var delegate: CongratsViewToSessionViewDelegate!
    
    //MARK: OUTLETS
    let congratulationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 35)
        label.textColor = UIColor.white
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You completed the goal!"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
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
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        return button
    }()
    
    //MARK: FUNCTIONS
    private func addOutlets() {
        [congratulationsLabel,descriptionLabel,dismissButton].forEach { (view) in
            self.addSubview(view)
        }
    }
    
    private func setConstraints() {
        congratulationsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(congratulationsLabel.snp.bottom).offset(55)
            make.centerX.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalTo(150)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    @objc private func dismissButtonTapped() {
        delegate.dismissTapped()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addOutlets()
        setConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
