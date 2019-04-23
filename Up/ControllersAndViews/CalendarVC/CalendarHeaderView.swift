//
//  CalendarHeaderView.swift
//  Up
//
//  Created by Tony Cioara on 4/23/19.
//

import Foundation
import UIKit

protocol HeaderViewToCalendarVCDelegate {
    func changeLabelText(text: String)
}

protocol CalendarVCToHeaderViewDelegate {
    func leftButtonTapped()
    func rightButtonTapped()
}

class CalendarHeaderView: UIView, HeaderViewToCalendarVCDelegate {
    
    var delegate: CalendarVCToHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeLabelText(text: String) {
        monthLabel.text = text
    }
    
    private func setupViews() {
        [monthLabel, leftButton, rightButton].forEach { (view) in
            self.addSubview(view)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(leftButton.snp.height)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(leftButton.snp.height)
        }
        
        monthLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.right.equalTo(rightButton.snp.left).inset(8)
            make.left.equalTo(leftButton.snp.right).inset(8)
        }
        
    }
    
    @objc private func leftButtonTapped() {
        guard let delegate = self.delegate else { return }
        delegate.leftButtonTapped()
    }
    
    @objc private func rightButtonTapped() {
        guard let delegate = self.delegate else { return }
        delegate.rightButtonTapped()
    }
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.text = "Month Label"
        label.textColor = .black
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
}
