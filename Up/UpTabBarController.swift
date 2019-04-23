//
//  UpTabBarController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/23/19.
//

import Foundation
import UIKit

class UpTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.tabBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //create tab one
        let goalsVC = UpViewController()
        let goalsNavVC = UINavigationController(rootViewController: goalsVC)
        let tabOneBarItem = UITabBarItem(title: "Goals", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        goalsNavVC.tabBarItem = tabOneBarItem
        
        //create tab two
//        let CalendarVC = Calend
//        let hatchNavVC = UINavigationController(rootViewController: HatchVC)
//        let tabTwoBarItem = UITabBarItem(title: "Hatch", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
//        hatchNavVC.tabBarItem = tabTwoBarItem
        self.viewControllers = [goalsVC]
    }
    
    
    
}
