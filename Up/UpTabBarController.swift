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
    
    private func configNavBar(navController: UINavigationController) {
        extendedLayoutIncludesOpaqueBars = true
        navController.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //create tab one
        let goalsVC = UpViewController()
        let goalsNavVC = UINavigationController(rootViewController: goalsVC)
        configNavBar(navController: goalsNavVC)
        let tabOneBarItem = UITabBarItem(title: "Goals", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        goalsNavVC.tabBarItem = tabOneBarItem
        
        //create tab two
        let calendarVC = CalendarViewController()
        let calendarNavVC = UINavigationController(rootViewController: calendarVC)
        let tabTwoBarItem = UITabBarItem(title: "Calendar", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        calendarNavVC.tabBarItem = tabTwoBarItem
        self.viewControllers = [goalsVC, calendarVC]
    }
    
    
    
}
