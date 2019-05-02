//
//  TextFieldHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/9/19.
//

import Foundation
import UIKit


enum InputType {
    case textField
    case textView
}

//from TextViewInputView to NewProjectVC
protocol CustomTextViewToNewProjVCDelegate: class {
    func sendText(text: String)
}

class SunnyCustomInputView: UIView {
    
    //MARK: VARIABLES
    weak var textDelegate: CustomTextViewToNewProjVCDelegate!
    
    
    //MARK: OUTLETS
    
    
    
    let tv: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = #colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1)
        tv.textColor = UIColor.gray
        tv.text = "Goal description"
        tv.returnKeyType = UIReturnKeyType.done
//        tv.isScrollEnabled = false
        return tv
    }()
    
    
    let tfOverlayLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        return label
        
    }()
    
    let bottomBorder: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0, green: 0.337254902, blue: 0.7647058824, alpha: 1)
        view.alpha = 0
        return view
    }()
    
    init(frame: CGRect, fontSize: CGFloat, type: InputType) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        addOutlets(type: type)
        setConstraints(type: type)
        self.backgroundColor = #colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1)
        self.layer.cornerRadius = 5
        tv.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        tv.tintColor = #colorLiteral(red: 0, green: 0.3391429484, blue: 0.7631449103, alpha: 1)
        tv.becomeFirstResponder()
        tfOverlayLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 13)
        tfOverlayLabel.text = "Description"
        tv.delegate = self
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addOutlets(type: InputType) {
        
        
        [tfOverlayLabel, bottomBorder, tv].forEach { (view) in
            self.addSubview(view)
        }
    }
    
  
    
    private func setConstraints(type: InputType) {
        
        tv.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
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
            
            if !textView.text.isEmpty {
                textDelegate.sendText(text: textView.text)
            }
            
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 80
        
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
            textView.text = "Let's get started"
            textView.textColor = UIColor.gray
        } else {
            textDelegate.sendText(text: textView.text)
        }
        tfOverlayLabel.textColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        dismissBottomBorder()
    }
}


extension SunnyCustomInputView: newProjectVCToTextInputViewDelegate {
    func populateTextView(text: String) {
        tv.textColor = #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
        tv.text = text
        
    }
    
    
}




