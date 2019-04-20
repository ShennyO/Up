//
//  CalendarCollectionViewCellID.swift
//  Up
//
//  Created by Tony Cioara on 4/19/19.
//

import Foundation
import UIKit

// The cell of the outer collection view (container for smallCollectionView)
class CalendarCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        setupViews()
    }
    
    var indexPath: IndexPath!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let calendarDayCollectionViewCellID = "calendarDayCollectionViewCellID"
    
    var calendarMonthCollectionView: UICollectionView!
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, indexPath: IndexPath) {
        calendarMonthCollectionView.delegate = delegate
        calendarMonthCollectionView.dataSource = dataSource
        calendarMonthCollectionView.tag = indexPath.row
    }
    
    private func setupViews() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        calendarMonthCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        calendarMonthCollectionView.register(CalendarDayCollectionViewCell.self, forCellWithReuseIdentifier: calendarDayCollectionViewCellID)
        
        calendarMonthCollectionView.backgroundColor = .blue
        calendarMonthCollectionView.isPagingEnabled = true
        
        self.addSubview(calendarMonthCollectionView)
        
        calendarMonthCollectionView.snp.makeConstraints { (make) in
            make.bottom.left.top.right.equalToSuperview()
        }
        
    }
}
