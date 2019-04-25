//
//  calendarTableViewCell.swift
//  Up
//
//  Created by Tony Cioara on 4/19/19.
//

import Foundation
import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let calendarCollectionViewCellID = "calendarCollectionViewCellID"
    
    var calendarCollectionView: UICollectionView!
    
    var calendarHeaderView: CalendarHeaderView = {
        let headerView = CalendarHeaderView()
        return headerView
    }()
    
    func configureProtocols(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, headerViewDelegate: CalendarVCToHeaderViewDelegate) {
        calendarCollectionView.delegate = delegate
        calendarCollectionView.dataSource = dataSource
        calendarHeaderView.delegate = headerViewDelegate
    }
    
    func setupCollectionView() {
        let layout = CalendarLayout()
        layout.scrollDirection = .horizontal
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        cv.isPagingEnabled = true
        cv.backgroundColor = Style.Colors.Palette01.gunMetal
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.tag = 1
        cv.allowsSelection = true
        
        cv.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: calendarCollectionViewCellID)
        
        self.calendarCollectionView = cv
    }
    
    private func setupViews() {
        
        [calendarHeaderView, calendarCollectionView].forEach { (view) in
            self.addSubview(view)
        }
        
        calendarCollectionView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
//            make.height.equalTo(calendarCollectionView.snp.width).multipliedBy(6 / 7)
        }
        
        calendarHeaderView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(calendarCollectionView.snp.top)
            make.height.equalTo(90)
        }
    }
}
