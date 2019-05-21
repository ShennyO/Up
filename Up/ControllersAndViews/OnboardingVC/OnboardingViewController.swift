//
//  OnboardingViewController.swift
//  Up
//
//  Created by Tony Cioara on 5/21/19.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    var onboardingCollectionView: UICollectionView!
    let footerView = OnboardingFooterView()
    
    let onboardingCollectionViewCellID = "onboardingCollectionViewCellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
    }
    
    func setupViews() {
        [onboardingCollectionView, footerView].forEach { (view) in
            self.view.addSubview(view)
        }
        
        onboardingCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        footerView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(onboardingCollectionView.snp.bottom)
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
        
        self.onboardingCollectionView = cv
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: onboardingCollectionViewCellID, for: indexPath) as! OnboardingCollectionViewCell
        
        return cell
    }
    
    
}
