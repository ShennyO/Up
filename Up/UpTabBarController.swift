//
//  UpTabBarController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/23/19.
//

import Foundation
import UIKit
import SnapKit

protocol GoalCompletionDelegate {
    func goalWasCompleted(goal: Goal)
}

class UpTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var firstTabbarItemImageView: UIImageView!
    var secondTabbarItemImageView: UIImageView!
    var thirdTabbarItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.tabBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.tabBar.isTranslucent = false
        setUpTabBar()
        self.delegate = self
        
    }
    
    private func configNavBar(navController: UINavigationController) {
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:Style.Colors.Palette01.pureWhite]
        navController.navigationBar.titleTextAttributes = textAttributes
        navController.navigationBar.largeTitleTextAttributes = textAttributes
        navController.navigationItem.title = title
        
        extendedLayoutIncludesOpaqueBars = true
        navController.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.prefersLargeTitles = true
        
        
    }
    
    private func setUpTabBar() {
        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(color: .black)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        
        //  Create tab item three
        let statsVC = StatsViewController()
        let statsNavVC = UINavigationController(rootViewController: statsVC)
        statsNavVC.tabBarItem.image = #imageLiteral(resourceName: "whiteChart")
        statsNavVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "blueChart")
        statsNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        statsNavVC.tabBarItem.tag = 3
        
//        Create tab item two
        let calendarVC = CalendarViewController()
        let calendarNavVC = UINavigationController(rootViewController: calendarVC)
        calendarNavVC.tabBarItem.image = #imageLiteral(resourceName: "whiteCal")
        calendarNavVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "blueCal")
        calendarNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        calendarNavVC.tabBarItem.tag = 2
        calendarNavVC.navigationBar.barTintColor = Style.Colors.Palette01.gunMetal
        configNavBar(navController: calendarNavVC)
        calendarNavVC.navigationBar.barTintColor = Style.Colors.Palette01.gunMetal
        
//        Create tab item one
        let goalsVC = UpViewController()
        calendarVC.calendarGoalDelegate = goalsVC
        goalsVC.goalCompletionDelegate = calendarVC
        let goalsNavVC = UINavigationController(rootViewController: goalsVC)
        goalsNavVC.tabBarItem.image = #imageLiteral(resourceName: "whiteList")
        goalsNavVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "blueList")
        goalsNavVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        goalsNavVC.tabBarItem.tag = 1
        configNavBar(navController: goalsNavVC)
        
        self.viewControllers = [goalsNavVC, calendarNavVC]
        
        let firstItemView = tabBar.subviews.first!
        firstTabbarItemImageView = firstItemView.subviews.first as? UIImageView
        firstTabbarItemImageView.contentMode = .center
        
        let secondItemView = self.tabBar.subviews[1]
        self.secondTabbarItemImageView = secondItemView.subviews.first as? UIImageView
        self.secondTabbarItemImageView.contentMode = .center
        
//        let thirdItemView = self.tabBar.subviews[2]
//        self.thirdTabbarItemImageView = thirdItemView.subviews.first as? UIImageView
//        self.thirdTabbarItemImageView.contentMode = .center
        
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
