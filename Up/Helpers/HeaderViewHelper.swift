//
//  headerViewHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import Foundation
import UIKit



class HeaderView: UIView {
    
    //MARK: OUTLETS
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    
    let getStartedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.text = "Add a task to get started"
        label.textColor = UIColor.white
        label.isHidden = false
        return label
    }()
    
    private func addOutlets() {
        self.addSubview(titleLabel)
        self.addSubview(getStartedLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
    
        getStartedLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(95)
        }
        
    }
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        titleLabel.text = title
        addOutlets()
        setConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension HeaderView: UpVCToUpVCHeaderDelegate{
    func alertHeaderView(total: Int) {
        if total == 0 {
            
            
            getStartedLabel.isHidden = false
            getStartedLabel.alpha = 0
            UIView.animate(withDuration: 0.7, animations: {
                self.getStartedLabel.alpha = 1
            })
            
            
        } else { //If there are projects
            
            
            self.getStartedLabel.isHidden = true
            
            
        }
    }
    
    
}


    
    


