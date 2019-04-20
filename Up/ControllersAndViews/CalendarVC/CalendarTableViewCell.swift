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
    
    func configureCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, closure: (UICollectionView) -> ()) {
        calendarCollectionView.delegate = delegate
        calendarCollectionView.dataSource = dataSource
        closure(calendarCollectionView)
    }
    
    private func setupViews() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        calendarCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        calendarCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: calendarCollectionViewCellID)
        
        calendarCollectionView.backgroundColor = .blue
        calendarCollectionView.isPagingEnabled = true
        
        self.addSubview(calendarCollectionView)
        
        calendarCollectionView.snp.makeConstraints { (make) in
            make.bottom.left.top.right.equalToSuperview()
        }
    }
}
