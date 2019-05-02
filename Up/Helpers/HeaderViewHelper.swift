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
    
    let getStartedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.text = "Add a task to get started"
        label.textColor = UIColor.white
        label.isHidden = false
        return label
    }()
    
    private func addOutlets() {
        self.addSubview(getStartedLabel)
    }
    
    private func setConstraints() {
    
        getStartedLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            
            self.getStartedLabel.isHidden = false
            self.getStartedLabel.alpha = 0
            UIView.animate(withDuration: 0.7, animations: {
                self.getStartedLabel.alpha = 1
            })
                
        } else { //If there are projects
            
            self.getStartedLabel.isHidden = true
            
        }
    }
    
    
}


    
    


