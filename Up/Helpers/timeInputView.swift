//
//  timeInputView.swift
//  Up
//
//  Created by Sunny Ouyang on 4/12/19.
//

import Foundation
import UIKit



class timeInputViewButton: UIView {
    
    
    //MARK: OUTLETS
    let darkView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.gray
        view.alpha = 0.5
        view.isHidden = true
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textColor = UIColor.white
        label.text = "20 minutes"
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let arrowImage: UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        imageView.image = #imageLiteral(resourceName: "upArrow")
        imageView.isUserInteractionEnabled = true
        return imageView
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
        self.addSubview(arrowImage)
        self.addSubview(darkView)
        
    }
    
    private func setConstraints() {
        
        darkView.snp.makeConstraints { (make) in
            make.top.bottom.right.left.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(2)
        }
        
        arrowImage.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.width.equalTo(20)
            make.left.equalTo(timeLabel.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }

    }
    
    
}

extension timeInputViewButton: inputDelegate {
    func tapStarted() {
        timeLabel.textColor = UIColor.gray
        arrowImage.image = #imageLiteral(resourceName: "Combined Shape")
    }
    
    func tapEnded() {
        timeLabel.textColor = UIColor.white
        arrowImage.image = #imageLiteral(resourceName: "upArrow")
    }
}
