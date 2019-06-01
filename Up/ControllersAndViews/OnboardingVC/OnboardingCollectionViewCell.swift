//
//  OnboardingCollectionViewCell.swift
//  Up
//
//  Created by Tony Cioara on 5/21/19.
//

import Foundation
import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(image: UIImage, title: String, description: String) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
        setupViews()
    }
    
    private func setupViews() {
        [imageView, titleLabel, descriptionLabel].forEach { (view) in
            self.addSubview(view)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-32)
            make.height.equalTo(60)
//            make.bottom.equalToSuperview().offset(-32)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(30)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-16)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(32)
            make.bottom.equalTo(titleLabel.snp.top).offset(-32)
            make.centerX.equalToSuperview()
            let ratio = imageView.image!.size.height / imageView.image!.size.width
            make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
            make.width.lessThanOrEqualToSuperview().offset(-64)
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Style.Colors.Palette01.gunMetal
        label.font = Style.Fonts.bold20
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Style.Colors.Palette01.gunMetal
        label.font = Style.Fonts.bold15
        label.textAlignment = .center
        return label
    }()
}
