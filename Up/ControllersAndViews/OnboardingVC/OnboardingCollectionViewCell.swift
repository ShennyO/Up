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
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(image: UIImage, title: String, description: String) {
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    private func setupViews() {
        [imageView, titleLabel, descriptionLabel].forEach { (view) in
            self.addSubview(view)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-16)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(32)
            make.right.lessThanOrEqualToSuperview().offset(-32)
            make.bottom.lessThanOrEqualTo(titleLabel.snp.top).offset(-32)
            make.width.equalTo(imageView.snp.height)
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
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
