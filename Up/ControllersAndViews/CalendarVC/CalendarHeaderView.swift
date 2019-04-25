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
        self.backgroundColor = Style.Colors.Palette01.gunMetal
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
            make.left.top.equalToSuperview().inset(8)
            make.width.equalTo(leftButton.snp.height)
            make.bottom.equalTo(monthLabel.snp.bottom)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview().inset(8)
            make.width.equalTo(leftButton.snp.height)
            make.bottom.equalTo(monthLabel.snp.bottom)
        }
        
        monthLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.right.equalTo(rightButton.snp.left).offset(-8)
            make.left.equalTo(leftButton.snp.right).offset(8)
        }
        
        makeDayLabels()
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
        label.font = Style.Fonts.bold30
        label.textColor = Style.Colors.Palette01.pureWhite
        label.textAlignment = .center
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(Style.Colors.Palette01.pureWhite, for: .normal)
        button.titleLabel?.font = Style.Fonts.bold35
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(Style.Colors.Palette01.pureWhite, for: .normal)
        button.titleLabel?.font = Style.Fonts.bold35
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func makeDayLabels() {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        var lastLabel: UILabel?
        for day in days {
            let label = UILabel()
            label.text = day
            label.textColor = Style.Colors.Palette01.pureWhite
            label.font = Style.Fonts.medium18
            label.textAlignment = .center
            
            self.addSubview(label)
            
            if let lastLabel = lastLabel {
                label.snp.makeConstraints { (make) in
                    make.width.equalTo(lastLabel.snp.width)
                    make.bottom.equalToSuperview().inset(4)
                    make.left.equalTo(lastLabel.snp.right)
                    make.top.equalTo(monthLabel.snp.bottom).offset(8)
                    if day == days.last {
                        make.right.equalToSuperview()
                    }
                }
            } else {
                label.snp.makeConstraints { (make) in
                    make.bottom.equalToSuperview().inset(4)
                    make.left.equalToSuperview()
                    make.top.equalTo(monthLabel.snp.bottom).offset(8)
                }
            }
            
            lastLabel = label
        }
    }
}
