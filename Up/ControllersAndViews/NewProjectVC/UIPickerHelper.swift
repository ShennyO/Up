//
//  UIPickerHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/8/19.
//

import Foundation
import UIKit

class MyPickerView: UIPickerView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderWidth = 0 // Main view rounded border
        
        // Component borders
        self.subviews.forEach {
            $0.layer.borderWidth = 0
            $0.isHidden = $0.frame.height <= 1.0
        }
    }
    
}
