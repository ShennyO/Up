//
//  CalendarViewController.swift
//  Up
//
//  Created by Tony Cioara on 4/18/19.
//

import Foundation
import UIKit

class DemoCalendarViewController: UIViewController {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    
    let calendarDayCellID = "calendarDayCellID"
    var calendarCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendar()
        setUpViews()
        
        calendarCollectionView.reloadData()
    }
    
    let monthView = MonthView()
    
    func setUpCalendar() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
    }
    
    func setUpViews() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        calendarCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        calendarCollectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: calendarDayCellID)
        calendarCollectionView.backgroundColor = .green
        calendarCollectionView.isPagingEnabled = true
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        monthView.delegate = self
        
        [calendarCollectionView, monthView].forEach { (view) in
            self.view.addSubview(view)
        }
        
        setConstraints()
        
    }
    
    func setConstraints() {
        calendarCollectionView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalToSuperview()
        }
        monthView.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(calendarCollectionView.snp.top)
        }
    }
    
    func getFirstWeekDay() -> Int {
        let dateStr = "\(currentYear)-\(currentMonthIndex)-01"
        let dateFormatter = DateFormatter()
        if currentMonthIndex < 10  {
            dateFormatter.dateFormat = "yyyy'-'M'-'dd"
        } else {
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        }
        let date = dateFormatter.date(from: dateStr)
        let firstDay = Calendar.current.component(.weekday, from: date!)
        return firstDay
    }
}


extension DemoCalendarViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.frame.width/7 - 8
        return CGSize(width: length, height: length)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 9999
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarDayCellID, for: indexPath) as! CalendarDayCell
        cell.setUp(indexPath: indexPath, firstWeekDayOfMonth: firstWeekDayOfMonth)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}

extension DemoCalendarViewController: MonthViewDelegate {
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        calendarCollectionView.reloadData()
    }
    
    
}
