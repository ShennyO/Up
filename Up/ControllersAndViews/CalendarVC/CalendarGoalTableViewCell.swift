//
//  calendarGoalTableViewCell.swift
//  Up
//
//  Created by Tony Cioara on 4/23/19.
//

import Foundation
import UIKit


class CalendarGoalTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var goal: Goal!
    
    func setup(goal: Goal) {
        self.goal = goal
//        Create formatter for date-string conversion
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        self.backgroundColor = Style.Colors.Palette01.gunMetal
        descriptionLabel.text = goal.goalDescription
        
//        Display the right icon based on the goal type
        if goal.duration == 0 {
            clockIconView.isHidden = true
            durationLabel.isHidden = true
            boxView.isHidden = false
        } else {
            clockIconView.isHidden = false
            durationLabel.isHidden = false
            boxView.isHidden = true
        }
        durationLabel.text = String(goal.duration)
    }
    
    
    private func setupViews() {
        
//        Add views into proper superviews
        [mainContainerView, lineView].forEach { (view) in
            self.addSubview(view)
        }
        
        [descriptionLabel, clockIconView, boxView, checkmarkView,/* durationLabelView, durationLabel*/].forEach { (view) in
            mainContainerView.addSubview(view)
        }
        
//        Set constraints for views
//         * Self
        mainContainerView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
//         * mainContainerView
        lineView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.width.equalTo(0.5)
        }
        
        clockIconView.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(16)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(clockIconView.snp.height)
        }
        /*
        durationLabelView.snp.makeConstraints { (make) in
            make.centerY.equalTo(clockIconView.snp.bottom).offset(-4)
            make.centerX.equalTo(clockIconView.snp.right).offset(-4)
            make.width.height.equalTo(20)
        }
        
        durationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(durationLabelView.snp.centerY).offset(1)
            make.centerX.equalTo(durationLabelView.snp.centerX)
        } */

        boxView.snp.makeConstraints { (make) in
            make.left.equalTo(clockIconView.snp.left).inset(1)
            make.right.equalTo(clockIconView.snp.right).inset(1)
            make.top.equalTo(clockIconView.snp.top).inset(1)
            make.bottom.equalTo(clockIconView.snp.bottom).inset(1)
        }

        checkmarkView.snp.makeConstraints { (make) in
            make.left.equalTo(clockIconView.snp.left).inset(8)
            make.right.equalTo(clockIconView.snp.right).inset(8)
            make.top.equalTo(clockIconView.snp.top).inset(8)
            make.bottom.equalTo(clockIconView.snp.bottom).inset(8)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(clockIconView.snp.right).offset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
    let mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.gunMetal
        return view
    }()
    
    let detailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.gunMetal
        view.backgroundColor = .green
        view.alpha = 0
        return view
    }()
    
    let clockIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Style.Colors.Palette01.gunMetal
        imageView.image = #imageLiteral(resourceName: "whiteEmptyTimeIcon")
        return imageView
    }()
    
    let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.gunMetal
        view.layer.borderWidth = 1
        view.layer.borderColor = Style.Colors.Palette01.pureWhite.cgColor
        view.layer.cornerRadius = 3
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.pureWhite
        return view
    }()
    
    let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "checkMark")
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Style.Fonts.bold15
        label.numberOfLines = 2
        label.textColor = Style.Colors.Palette01.pureWhite
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = Style.Fonts.bold12
        label.textAlignment = .center
        label.textColor = Style.Colors.Palette01.pureWhite
        label.numberOfLines = 1
        return label
    }()
    
    var durationLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = Style.Colors.Palette01.gunMetal
        view.clipsToBounds = true
        view.layer.borderColor = Style.Colors.Palette01.pureWhite.cgColor
        view.layer.borderWidth = 0.75
        view.layer.cornerRadius = 10
        return view
    }()
    
}
