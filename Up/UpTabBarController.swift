//
//  UpTabBarController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/23/19.
//

import Foundation
import UIKit
import SnapKit


class UpTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        self.delegate = self
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.isTranslucent = false

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
    
    
    private func setUpTabBar() {
        //create tab one
        let goalsVC = UpViewController()
        let goalsNavVC = UINavigationController(rootViewController: goalsVC)
        goalsNavVC.tabBarItem.image = #imageLiteral(resourceName: "home")
        goalsNavVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "selectedHome")
        goalsNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        
        
        //create tab two
        let calendarVC = CalendarViewController()
        let calendarNavVC = UINavigationController(rootViewController: calendarVC)
        calendarNavVC.tabBarItem.image = #imageLiteral(resourceName: "calendar")
        calendarNavVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "selectedCalendar")
        calendarNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        
        self.viewControllers = [goalsNavVC, calendarNavVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
}
