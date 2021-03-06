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
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: widthScaleFactor(distance: 18))
        label.textColor = UIColor.white
        label.text = "30 minutes"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let upArrow = UIImageView(image: #imageLiteral(resourceName: "whiteDoubleArrows"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        self.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        self.layer.cornerRadius = widthScaleFactor(distance: 4)
        self.isUserInteractionEnabled = true
        addOutlets()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addOutlets() {
        self.addSubview(timeLabel)
        self.addSubview(upArrow)
    }
    
    private func setConstraints() {
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(2)
        }

        upArrow.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(widthScaleFactor(distance: -20))
        }
    }
    
    
}
// from NewProjectVC to TimeInputView
extension TimeInputViewButton: NewTaskViewToTimeInputButtonDelegate {
    
    func sendSelectedTime(time: Int) {
        if time == 1 {
            timeLabel.text = String(describing: time) + " minute"
        } else {
            timeLabel.text = String(describing: time) + " minutes"
        }
    }
    
    func tapStarted() {
        upArrow.image = #imageLiteral(resourceName: "grayDoubleArrows")
        timeLabel.textColor = UIColor.gray
    }
    
    func tapEnded() {
        upArrow.image = #imageLiteral(resourceName: "whiteDoubleArrows")
        timeLabel.textColor = UIColor.white
    }
}
