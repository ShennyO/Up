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
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
        
        //Then, add the custom top line view with custom color. And set the default background color of tabbar
//        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10))
//        lineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        self.tabBarController?.tabBar.addSubview(lineView)
//        self.tabBarController?.tabBar.backgroundColor = UIColor.black
        

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
        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: .black)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        
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
