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
        self.backgroundColor = .green
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let calendarCollectionViewCellID = "calendarCollectionViewCellID"
    
    var calendarCollectionView: UICollectionView!
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        calendarCollectionView.delegate = delegate
        calendarCollectionView.dataSource = dataSource
    }
    
    private func setupViews() {
        
        let layout = CalendarLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let frame = CGRect.zero
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        cv.isPagingEnabled = true
        cv.backgroundColor = UIColor.black
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        
        cv.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: calendarCollectionViewCellID)
        
        self.addSubview(cv)
        
        cv.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalToSuperview()
        }
        
        self.calendarCollectionView = cv
        
        
    }
}
