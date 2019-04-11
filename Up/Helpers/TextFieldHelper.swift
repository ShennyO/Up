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
        return tf
        
    }()
    
    let tfOverlayLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.black
        return label
        
    }()
    
    init(frame: CGRect, fontSize: CGFloat) {
        super.init(frame: frame)
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
        [tf, tfOverlayLabel].forEach { (view) in
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
            make.left.equalToSuperview().offset(5)
        }
        
    }
    
    
}
