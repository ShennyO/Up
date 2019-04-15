//
//  TextFieldHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/9/19.
//

import Foundation
import UIKit


enum inputType {
    case textField
    case textView
}

class SunnyCustomInputView: UIView {
    
    //MARK: OUTLETS
    
    let tv: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = #colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1)
        tv.textColor = UIColor.gray
        tv.text = "Goal description"
        return tv
    }()
    
    let tf: UITextField = {
        
        let tf = UITextField()
        tf.textColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        tf.backgroundColor = #colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1)
        tf.borderStyle = .none
        return tf
        
    }()
    
    let tfOverlayLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        return label
        
    }()
    
    let bottomBorder: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0, green: 0.3391429484, blue: 0.7631449103, alpha: 1)
        view.alpha = 0
        return view
    }()
    
    init(frame: CGRect, fontSize: CGFloat, type: inputType) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        addOutlets(type: type)
        setConstraints(type: type)
        self.backgroundColor = #colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1)
        self.layer.cornerRadius = 5
        tf.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        tv.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        tv.tintColor = #colorLiteral(red: 0, green: 0.3391429484, blue: 0.7631449103, alpha: 1)
        tfOverlayLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        switch type {
        case .textField:
            tfOverlayLabel.text = "Title"
            tf.delegate = self
        case .textView:
            tfOverlayLabel.text = "Description"
            tv.delegate = self
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addOutlets(type: inputType) {
        
        switch type {
            case .textField:
                self.addSubview(tf)
            case .textView:
                self.addSubview(tv)
        
        }
        
        [tfOverlayLabel, bottomBorder].forEach { (view) in
            self.addSubview(view)
        }
    }
    
    private func setConstraints(type: inputType) {
        
        switch type {
        case .textField:
            tf.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(15)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview()
                
            }
        case .textView:
            
            tv.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview()
            }
            
        }
        
        
        
        tfOverlayLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
        }
        
        bottomBorder.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(6)
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func animateBottomBorder() {
        bottomBorder.isHidden = false
        bottomBorder.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.bottomBorder.alpha = 1
        }
    }
    
    private func dismissBottomBorder() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomBorder.alpha = 0
        }, completion:  {
            (value: Bool) in
            self.bottomBorder.isHidden = true
        })
    }
    
    
}

extension SunnyCustomInputView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 75
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        }
        tfOverlayLabel.textColor = #colorLiteral(red: 0, green: 0.3391429484, blue: 0.7631449103, alpha: 1)
        animateBottomBorder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Goal description"
            textView.textColor = UIColor.gray
        }
        tfOverlayLabel.textColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        dismissBottomBorder()
    }
}

extension SunnyCustomInputView: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfOverlayLabel.textColor = #colorLiteral(red: 0.1737573147, green: 0.3813245595, blue: 0.9967152476, alpha: 1)
        animateBottomBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfOverlayLabel.textColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        dismissBottomBorder()
    }
    
}


