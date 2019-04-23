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
    
    var calendarCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    var startDate = Date()
    var endDate = Date()
    var startOfMonth = Date()
    var todayIndexPath: IndexPath?
    var monthInfo = [Int:[Int]]()
    
    let FIRST_DAY_INDEX = 0
    let NUMBER_OF_DAYS_INDEX = 1
    
    lazy var gregorian : NSCalendar = {
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        endDate = formatter.date(from: "01/01/2025")!
        
        setupViews()
        setupTableView()
        
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
        cell.configureCollectionView(delegate: self, dataSource: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width
    }
    
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var firstDayOfStartMonth = self.gregorian.components( [.era, .year, .month], from: startDate)
        firstDayOfStartMonth.day = 1 // round to first day
        
        guard let dateFromDayOneComponents = self.gregorian.date(from: firstDayOfStartMonth) else {
            return 0
        }
        
        startOfMonth = dateFromDayOneComponents
        
        let today = Date()
        
        if  startOfMonth.compare(today) == ComparisonResult.orderedAscending &&
            endDate.compare(today) == ComparisonResult.orderedDescending {
            
            let differenceFromTodayComponents = self.gregorian.components([.month, .day], from: startOfMonth, to: today, options: NSCalendar.Options())
            
            self.todayIndexPath = IndexPath(item: differenceFromTodayComponents.day!, section: differenceFromTodayComponents.month!)
            
        }
        
        let differenceComponents = self.gregorian.components(.month, from: startDate, to: endDate, options: NSCalendar.Options())
        
        return differenceComponents.month! + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var monthOffsetComponents = DateComponents()
        
        // offset by the number of months
        monthOffsetComponents.month = section
        
        guard let correctMonthForSectionDate = self.gregorian.date(byAdding: monthOffsetComponents, to: startOfMonth, options: NSCalendar.Options()) else {
            return 0
        }
        
        let numberOfDaysInMonth = self.gregorian.range(of: .day, in: .month, for: correctMonthForSectionDate).length
        
        var firstWeekdayOfMonthIndex = self.gregorian.component(.weekday, from: correctMonthForSectionDate)
        firstWeekdayOfMonthIndex = firstWeekdayOfMonthIndex - 1 // firstWeekdayOfMonthIndex should be 0-Indexed
        firstWeekdayOfMonthIndex = (firstWeekdayOfMonthIndex + 6) % 7 // push it modularly so that we take it back one day so that the first day is Monday instead of Sunday which is the default
        
        monthInfo[section] = [firstWeekdayOfMonthIndex, numberOfDaysInMonth]
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCollectionViewCellID, for: indexPath) as! CalendarCollectionViewCell
        
        let currentMonthInfo : [Int] = monthInfo[indexPath.section]! // we are guaranteed an array by the fact that we reached this line (so unwrap)
        
        let fdIndex = currentMonthInfo[FIRST_DAY_INDEX]
        let nDays = currentMonthInfo[NUMBER_OF_DAYS_INDEX]
        
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - fdIndex, section: indexPath.section) // if the first is wednesday, add 2
        
        if indexPath.item >= fdIndex &&
            indexPath.item < fdIndex + nDays {
            
//            cell.dayLabel.text = String(fromStartOfMonthIndexPath.item + 1)
            cell.setup(day: String(fromStartOfMonthIndexPath.item + 1))
            cell.isHidden = false
            
        }
        else {
            cell.setup(day: "")
            cell.isHidden = true
        }
        
//        cell.selected = selectedIndexPaths.contains(indexPath)
//
//        if indexPath.section == 0 && indexPath.item == 0 {
//            self.scrollViewDidEndDecelerating(collectionView)
//        }
        
//        if let idx = todayIndexPath {
//            cell.isToday = (idx.section == indexPath.section && idx.item + fdIndex == indexPath.item)
//        }
//
//        if let eventsForDay = eventsByIndexPath[fromStartOfMonthIndexPath] {
//
//            cell.eventsCount = eventsForDay.count
//
//        } else {
//            cell.eventsCount = 0
//        }
//        cell.setup(day: indexPath.row)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/7, height: collectionView.frame.height/6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
}
