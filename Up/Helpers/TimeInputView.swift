//
//  TimeInputViewButton.swift
//  Up
//
//  Created by Sunny Ouyang on 4/12/19.
//

import Foundation
import UIKit



class TimeInputViewButton: UIView {
    
    
    //MARK: OUTLETS
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textColor = UIColor.white
        label.text = "30 minutes"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        self.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        self.layer.cornerRadius = 4
        self.isUserInteractionEnabled = true
        addOutlets()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addOutlets() {
        self.addSubview(timeLabel)
    }
    
    private func setConstraints() {
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(2)
        }

    }
    
    
}
// from NewProjectVC to TimeInputView
extension TimeInputViewButton: NewProjectVCToTimeInputButtonDelegate {
    func sendSelectedTime(time: Int) {
        timeLabel.text = String(describing: time) + " minutes "
    }
    
    
    func tapStarted() {
        timeLabel.textColor = UIColor.gray
    }
    
    func tapEnded() {
        timeLabel.textColor = UIColor.white
    }
}
