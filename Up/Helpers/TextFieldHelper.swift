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
        tv.backgroundColor = UIColor.white
        tv.layer.cornerRadius = 4
        tv.textColor = UIColor.lightGray
        tv.text = "Optional description"
        return tv
    }()
    
    let tf: UITextField = {
        
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 4
        tf.borderStyle = .none
        return tf
        
    }()
    
    let tfOverlayLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.4666666667, green: 0.4941176471, blue: 0.5411764706, alpha: 1)
        return label
        
    }()
    
    let bottomBorder: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.1754467785, green: 0.3823254108, blue: 0.9967435002, alpha: 1)
        view.alpha = 0
        return view
    }()
    
    init(frame: CGRect, fontSize: CGFloat, type: inputType) {
        super.init(frame: frame)
        addOutlets(type: type)
        setConstraints(type: type)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4
        tf.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        tv.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
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
                make.top.equalToSuperview().offset(15)
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
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        tfOverlayLabel.textColor = #colorLiteral(red: 0.1754467785, green: 0.3823254108, blue: 0.9967435002, alpha: 1)
        animateBottomBorder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Optional description"
            textView.textColor = UIColor.lightGray
        }
        tfOverlayLabel.textColor = #colorLiteral(red: 0.4666666667, green: 0.4941176471, blue: 0.5411764706, alpha: 1)
        dismissBottomBorder()
    }
}

extension SunnyCustomInputView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tfOverlayLabel.textColor = #colorLiteral(red: 0.1737573147, green: 0.3813245595, blue: 0.9967152476, alpha: 1)
        animateBottomBorder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfOverlayLabel.textColor = #colorLiteral(red: 0.4666666667, green: 0.4941176471, blue: 0.5411764706, alpha: 1)
        dismissBottomBorder()
    }
    
}


