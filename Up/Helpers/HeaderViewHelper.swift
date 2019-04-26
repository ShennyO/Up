//
//  headerViewHelper.swift
//  Up
//
//  Created by Sunny Ouyang on 4/5/19.
//

import Foundation
import UIKit


//need a delegate from HeaderView to upVC to communicate that when edit mode
//is on, hide the add button on upVC

protocol HeaderViewToUpVCDelegate {
    func addTapped()
}

class HeaderView: UIView {
    
    //MARK: VARIABLES
    var delegate: HeaderViewToUpVCDelegate!
    
    //MARK: OUTLETS
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 65)
        button.setTitleColor(UIColor.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    let getStartedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.text = "Add a goal to get started"
        label.textColor = UIColor.white
        label.isHidden = false
        return label
    }()
    
    private func addOutlets() {
        self.addSubview(titleLabel)
        self.addSubview(addButton)
        self.addSubview(getStartedLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(25)
        }
    
        addButton.snp.makeConstraints { (make) in
//            make.height.width.equalTo(30)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalTo(titleLabel)
        }
        
        
        getStartedLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(125)
        }
        
    }
    
    private func animate(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
                button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    
    @objc private func addButtonTapped() {
        animate(addButton)
        delegate.addTapped()
        
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


    
    


