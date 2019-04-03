//
//  initialViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/3/19.
//

import UIKit

class initialViewController: UIViewController {

    //MARK: OUTLETS
    var upTableView = UITableView()
    
    
    //MARK: VARIABLES
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        // Do any additional setup after loading the view.
    }
    
    private func setUp() {
        configNavBar()
        self.title = "Up"
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
    }
   
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
