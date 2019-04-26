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
    
    var firstTabbarItemImageView: UIImageView!
    var secondTabbarItemImageView: UIImageView!
    var thirdTabbarItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        self.delegate = self
        self.tabBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        

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
        goalsNavVC.tabBarItem.tag = 1
        
        
        
        
        //create tab two
        let calendarVC = CalendarViewController()
        let calendarNavVC = UINavigationController(rootViewController: calendarVC)
        calendarNavVC.tabBarItem.image = #imageLiteral(resourceName: "calendar")
        calendarNavVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "selectedCalendar")
        calendarNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        calendarNavVC.tabBarItem.tag = 2
        
        //create tab three
        let statsVC = StatsViewController()
        let statsNavVC = UINavigationController(rootViewController: statsVC)
        statsNavVC.tabBarItem.image = #imageLiteral(resourceName: "calendar")
        statsNavVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "selectedCalendar")
        statsNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        statsNavVC.tabBarItem.tag = 3
        self.viewControllers = [goalsNavVC, calendarNavVC, statsNavVC]
        
        let firstItemView = tabBar.subviews.first!
        firstTabbarItemImageView = firstItemView.subviews.first as? UIImageView
        firstTabbarItemImageView.contentMode = .center
        
        let secondItemView = self.tabBar.subviews[1]
        self.secondTabbarItemImageView = secondItemView.subviews.first as? UIImageView
        self.secondTabbarItemImageView.contentMode = .center
        
        let thirdItemView = self.tabBar.subviews[2]
        print(self.tabBar.subviews)
        self.thirdTabbarItemImageView = thirdItemView.subviews.first as? UIImageView
        self.thirdTabbarItemImageView.contentMode = .center
        
    }
    
    private func animate(_ imageView: UIImageView) {
        UIView.animate(withDuration: 0.1, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.175, y: 1.175)
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
        case 1:
            animate(firstTabbarItemImageView)
        case 2:
            animate(secondTabbarItemImageView)
        case 3:
            animate(thirdTabbarItemImageView)
        default:
            return
        }
        
        
    }
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    
}
