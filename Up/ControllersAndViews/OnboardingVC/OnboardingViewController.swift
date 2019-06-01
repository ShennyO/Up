//
//  OnboardingViewController.swift
//  Up
//
//  Created by Tony Cioara on 5/21/19.
//

import Foundation
import UIKit
import KeychainSwift

class OnboardingViewController: UIViewController {
    
    let keychain = KeychainSwift()
    
    var onboardingCollectionView: UICollectionView!
    let footerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.gunMetal
        return view
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = Style.Fonts.bold15
        button.titleLabel?.textColor = Style.Colors.Palette01.pureWhite
        button.addTarget(self, action: #selector(nextButtonTapped(sender:)), for: .touchDown)
        return button
    }()
    
    let prevButton: UIButton = {
        let button = UIButton()
        button.setTitle("Prev", for: .normal)
        button.titleLabel?.font = Style.Fonts.bold15
        button.titleLabel?.textColor = Style.Colors.Palette01.pureWhite
        button.addTarget(self, action: #selector(prevButtonTapped(sender:)), for: .touchDown)
        return button
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = Style.Colors.Palette01.mainBlue
        pageControl.pageIndicatorTintColor = Style.Colors.calendarShade1
        pageControl.backgroundColor = .clear
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    let onboardingCollectionViewCellID = "onboardingCollectionViewCellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Style.Colors.Palette01.pureWhite
        setupCollectionView()
        setupViews()
    }
    
    func setupViews() {
        [onboardingCollectionView, footerContainerView].forEach { (view) in
            self.view.addSubview(view)
        }
        
        [prevButton, nextButton, pageControl].forEach { (view) in
            footerContainerView.addSubview(view)
        }
        
        onboardingCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        footerContainerView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(onboardingCollectionView.snp.bottom)
        }
        
        prevButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(prevButton.snp.height)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(nextButton.snp.height)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(prevButton.snp.right)
            make.right.equalTo(nextButton.snp.left)
        }
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
        let frame  = CGRect.zero
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        cv.isPagingEnabled = true
        cv.backgroundColor = Style.Colors.Palette01.pureWhite
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.allowsSelection = true
        cv.alwaysBounceHorizontal = true
        
        cv.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: onboardingCollectionViewCellID)
        
        cv.delegate = self
        cv.dataSource = self
        
        self.onboardingCollectionView = cv
    }
    
    func updatePageControl(page: Int) {
        if page >= pageControl.numberOfPages || page < 0 {
            return
        }
        
        pageControl.currentPage = page
    }
    
    func scrollCollectionView(offset: Int) {
        let layout = onboardingCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let newItem = Int(round(onboardingCollectionView.contentOffset.x / onboardingCollectionView.frame.width)) + offset
        if newItem < 0 || newItem >= onboardingCollectionView.numberOfItems(inSection: 0) { return }
        guard let attri = layout.layoutAttributesForItem(at: IndexPath(item: newItem, section: 0)) else { return }
        onboardingCollectionView.setContentOffset(CGPoint(x: attri.frame.origin.x, y: 0), animated: true)
    }
    
    func finishOnboarding() {
        keychain.set(true, forKey: "onboarded")
        
        guard let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window
            else { return }
        let tabBarController = UpTabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        return
    }
    
    @objc func nextButtonTapped(sender: UIButton) {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            finishOnboarding()
        }
        scrollCollectionView(offset: 1)
    }
    
    @objc func prevButtonTapped(sender: UIButton) {
        scrollCollectionView(offset: -1)
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: onboardingCollectionViewCellID, for: indexPath) as! OnboardingCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.setup(image: #imageLiteral(resourceName: "Up-1"), title: "Welcome to Up", description: "A modern task manager that helps you keep track of your productivity")
        case 1:
            cell.setup(image: #imageLiteral(resourceName: "up-tasks-screen"), title: "Manage your tasks", description: "Keep track of what you have to do using tasks or timed sessions.")
        default:
            cell.setup(image: #imageLiteral(resourceName: "up-calendar-screen"), title: "Track your progress", description: "The calendar shows how many tasks you've completed each day. Scroll down to view the details for the selected date.")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        if page == onboardingCollectionView.numberOfItems(inSection: 0) - 1 {
            nextButton.setTitle("Done", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
        updatePageControl(page: page)
    }
}
