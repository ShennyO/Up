//
//  CalendarViewController.swift
//  Up
//
//  Created by Tony Cioara on 4/19/19.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController {
    
    let calendarTableViewCellID = "calendarTableViewCellID"
    let calendarCollectionViewCellID = "calendarCollectionViewCellID"
    let calendarDayCollectionViewCellID = "calendarDayCollectionViewCellID"
    
    var calendarCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        setupViews()
        setupTableView()
        
    }
    
    func setupCalendar() {
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = Calendar.getFirstWeekDay(monthIndex: currentMonthIndex, year: currentYear)
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 1 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex] = 29
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
    }
    
    func setupTableView() {
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: calendarTableViewCellID)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setupViews() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            
        }
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: calendarTableViewCellID, for: indexPath) as! CalendarTableViewCell
        cell.configureCollectionView(delegate: self, dataSource: self) { (calendarCollectionView) in
            self.calendarCollectionView = calendarCollectionView
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width
    }
    
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case calendarCollectionView:
            return 999
        default:
            let year = currentYear + Int((currentMonthIndex + collectionView.tag) / 12)
            let monthIndex = (currentMonthIndex + collectionView.tag) % 12
            print("Month index:", currentMonthIndex)
            
            firstWeekDayOfMonth = Calendar.getFirstWeekDay(monthIndex: monthIndex, year: year)
            var numOfDays = numOfDaysInMonth[currentMonthIndex] + firstWeekDayOfMonth - 1
            
            if monthIndex == 1 && year % 4 == 0 {
                numOfDays += 1
            }
            
            return numOfDays
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case calendarCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCollectionViewCellID, for: indexPath) as! CalendarCollectionViewCell
            cell.configureCollectionView(delegate: self, dataSource: self, indexPath: indexPath)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarDayCollectionViewCellID, for: indexPath) as! CalendarDayCollectionViewCell
            
            cell.setup(indexPath: indexPath, firstWeekDayOfMonth: firstWeekDayOfMonth)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case calendarCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        default:
            let length = collectionView.frame.width/7 - 8
            return CGSize(width: length, height: length)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case calendarCollectionView:
            return 0
        default:
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case calendarCollectionView:
            return 0
        default:
            return 8
        }
    }
    
}
