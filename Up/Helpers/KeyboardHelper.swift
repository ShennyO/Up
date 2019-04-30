//
//  KeyboardHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/20/19.
//

import Foundation
import UIKit


extension UIViewController
{
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
