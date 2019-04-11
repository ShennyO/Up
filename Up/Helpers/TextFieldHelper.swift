//
//  TextFieldHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/9/19.
//

import Foundation
import UIKit

class SunnyCustomTextFieldView: UIView {
    
    //MARK: OUTLETS
    let tf: UITextField = {
        
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 4
        let leftview = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        tf.leftView = leftview
        tf.leftViewMode = .always
        return tf
        
    }()
    
    let tfOverlayLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.black
        return label
        
    }()
    
    let bottomBorder: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.09016115218, green: 0.3289901018, blue: 1, alpha: 1)
        view.alpha = 0
        return view
    }()
    
    init(frame: CGRect, fontSize: CGFloat) {
        super.init(frame: frame)
        tf.delegate = self
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4
        tf.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        tfOverlayLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        tfOverlayLabel.text = "Title"
        addOutlets()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addOutlets() {
        [tf, tfOverlayLabel, bottomBorder].forEach { (view) in
            self.addSubview(view)
        }
    }
    
    private func setConstraints() {
        tf.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.right.bottom.equalToSuperview()
            
        }
        
        tfOverlayLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
        }
        
        bottomBorder.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(4)
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func animateBottomBorder() {
        bottomBorder.isHidden = false
        bottomBorder.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.bottomBorder.alpha = 1
        }
    }
    
    private func dismissBottomBorder() {
        UIView.animate(withDuration: 0.4, animations: {
            self.bottomBorder.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.bottomBorder.isHidden = true
        })
    }
    
    
}

extension SunnyCustomTextFieldView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfOverlayLabel.textColor = #colorLiteral(red: 0.09016115218, green: 0.3289901018, blue: 1, alpha: 1)
        animateBottomBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfOverlayLabel.textColor = UIColor.black
        dismissBottomBorder()
    }
    
}


