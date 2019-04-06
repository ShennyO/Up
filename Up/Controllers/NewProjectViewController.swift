//
//  NewProjectViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import UIKit

class NewProjectViewController: UIViewController {
    
    //MARK: OUTLETS
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.09240043908, green: 0.0924237594, blue: 0.09239736944, alpha: 1)
        return label
    }()
    
    var titleTextField = UITextField()
    
    var descriptionTextView = UITextView()
    
    
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.09240043908, green: 0.0924237594, blue: 0.09239736944, alpha: 1)
        return label
    }()
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.09240043908, green: 0.0924237594, blue: 0.09239736944, alpha: 1)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
}
