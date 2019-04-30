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
    let calendarGoalTableViewCellID = "calendarGoalTableViewCellID"
    
    var calendarCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())

    var startDate = Date()
    var endDate = Date()
    var startOfMonth = Date()
    var todayIndexPath: IndexPath?
    
    var lastSelectedCollectionViewIndexPath: IndexPath?
    var numberOfSectionsInCollectionView = 0
    var didScrollCollectionViewToToday = false
    
    var lastScrollViewOffset: CGFloat = 0

    var monthInfo = [Int:[Int]]()
    
    let firstDayIndex = 0
    let numberOfDaysIndex = 1
    let monthIndex = 2
    let yearIndex = 3
    
    var selectedDateString = "" {
        didSet {
            tableView.reloadSections(IndexSet([1]), with: .automatic)
        }
    }
    
    var goals = [String: [Goal]]()
    
    let coreDataStack = CoreDataStack()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    
    var delegate: HeaderViewToCalendarVCDelegate?
    
    lazy var gregorian : NSCalendar = {
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        cal.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)!
        return cal
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Calendar"
        
        fetchData()
        
        setupViews()
        setupTableView()
        
    }
    
    func fetchData() {
        
        let goalsArr = coreDataStack.fetchGoal(type: .all, completed: .completed, sorting: .completionDateAscending) as! [Goal]
        if goalsArr.count == 0 { return }
        startDate = gregorian.date(byAdding: .year, value: -1, to: goalsArr[0].completionDate!, options: NSCalendar.Options())!
        endDate = gregorian.date(byAdding: .year, value: 1, to: goalsArr.last!.completionDate!, options: NSCalendar.Options())!
        
        for goal in goalsArr {
            let key = formatter.string(from: goal.completionDate!)
            if goals[key] != nil {
                goals[key]!.append(goal)
            } else {
                goals[key] = [goal]
            }
        }
    }
    
    func setupTableView() {
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: calendarTableViewCellID)
        tableView.register(CalendarGoalTableViewCell.self, forCellReuseIdentifier: calendarGoalTableViewCellID)
        
        tableView.tag = 0
        tableView.backgroundColor = Style.Colors.Palette01.gunMetal
        tableView.separatorStyle = .none
        
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setupViews() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            
        }
    }
    
    func updateHeaderView(offset: Int) {
        guard let delegate = self.delegate else { return }
        
        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = Int(offset)
        
        guard let yearDate = self.gregorian.date(byAdding: monthOffsetComponents, to: self.startOfMonth, options: NSCalendar.Options()) else { return }
        
        let month = (self.gregorian.component(.month, from: yearDate) - 1) % 12
        
        let monthName = DateFormatter().monthSymbols[month] // 0 indexed array
        
        let year = String(self.gregorian.component(.year, from: yearDate))
        
        delegate.changeLabelText(text: monthName + " " + year)
    }
    
    func generateMonthComponenents(forSection section: Int) {
        var monthOffsetComponents = DateComponents()
        // offset by the number of months
        monthOffsetComponents.month = section
        
        guard let correctMonthForSectionDate = self.gregorian.date(byAdding: monthOffsetComponents, to: startOfMonth, options: NSCalendar.Options()) else { return }
        
        
        let numberOfDaysInMonth = self.gregorian.range(of: .day, in: .month, for: correctMonthForSectionDate).length
        
        var firstWeekdayOfMonthIndex = self.gregorian.component(.weekday, from: correctMonthForSectionDate)
        firstWeekdayOfMonthIndex = firstWeekdayOfMonthIndex - 1 // firstWeekdayOfMonthIndex should be 0-Indexed
        let month = self.gregorian.component(.month, from: correctMonthForSectionDate)
        let year = self.gregorian.component(.year, from: correctMonthForSectionDate)
        
        monthInfo[section] = [firstWeekdayOfMonthIndex, numberOfDaysInMonth, month, year]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            guard let goalArr = goals[selectedDateString] else { return 0 }
            return goalArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: calendarTableViewCellID, for: indexPath) as! CalendarTableViewCell
            cell.configureProtocols(delegate: self, dataSource: self, headerViewDelegate: self)
            delegate = cell.calendarHeaderView
            updateHeaderView(offset: 0)
            return cell
        default:
            var timeForCell: Int? = nil
            
            let goal = goals[selectedDateString]![indexPath.row]
            let hour = gregorian.component(.hour, from: goal.completionDate!)
            
            if indexPath.row != 0 {
                let prevGoal = goals[selectedDateString]![indexPath.row - 1]
                let prevGoalHour = gregorian.component(.hour, from: prevGoal.completionDate!)
                if hour != prevGoalHour {
                    timeForCell = hour
                }
            } else {
                timeForCell = hour
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: calendarGoalTableViewCellID, for: indexPath) as! CalendarGoalTableViewCell
            cell.setup(goal: goal, withTime: timeForCell)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let cvHeight: CGFloat = (tableView.frame.width - 32) / 7 * 6
            let headerHeight: CGFloat = 90
            let containerInsets: CGFloat = 32
            return cvHeight + headerHeight + containerInsets
        default:
            let goal = goals[selectedDateString]![indexPath.row]
            let hour = gregorian.component(.hour, from: goal.completionDate!)
            
            if indexPath.row != 0 {
                let prevGoal = goals[selectedDateString]![indexPath.row - 1]
                let prevGoalHour = gregorian.component(.hour, from: prevGoal.completionDate!)
                if hour != prevGoalHour {
                    return 132
                }
            } else {
                return 132
            }
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 1 { return 0 }
        guard let _ = goals[selectedDateString] else { return 0 }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 1 { return nil }
        guard let _ = goals[selectedDateString] else { return nil }
        let headerView = CalendarGoalCountHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        headerView.setup(dateString: selectedDateString, goalCount: goals[selectedDateString]!.count)
        return headerView
    }
}

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var firstDayOfStartMonth = self.gregorian.components( [.era, .year, .month], from: startDate)
        firstDayOfStartMonth.day = 1 // round to first day
        
        guard let dateFromDayOneComponents = self.gregorian.date(from: firstDayOfStartMonth) else {
            return 0
        }
        
        startOfMonth = dateFromDayOneComponents
        
        let today = Date()
        
        if startOfMonth.compare(today) == ComparisonResult.orderedAscending &&
            endDate.compare(today) == ComparisonResult.orderedDescending {
            
            let differenceFromTodayComponents = self.gregorian.components([.month, .day], from: startOfMonth, to: today, options: NSCalendar.Options())
            
            self.todayIndexPath = IndexPath(item: differenceFromTodayComponents.day!, section: differenceFromTodayComponents.month!)
            
        }
        
        let differenceComponents = self.gregorian.components(.month, from: startDate, to: endDate, options: NSCalendar.Options())
        
        numberOfSectionsInCollectionView = differenceComponents.month! + 1
        return numberOfSectionsInCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        generateMonthComponenents(forSection: section)
        if section == 0 {
            generateMonthComponenents(forSection: section - 1)
        }
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCollectionViewCellID, for: indexPath) as! CalendarCollectionViewCell

        let currentMonthInfo = monthInfo[indexPath.section]! // we are guaranteed an array by the fact that we reached this line (so unwrap)
        let fdIndex = Int(currentMonthInfo[firstDayIndex])
        let nDays = Int(currentMonthInfo[numberOfDaysIndex])
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - fdIndex, section: indexPath.section) // if the first is wednesday, add 2

        var month = String(currentMonthInfo[monthIndex])
        let year = String(currentMonthInfo[yearIndex])
        if month.count == 1 { month = "0" + month}
        let dateString = String(indexPath.row) + "/" + month + "/" + year
        
        if indexPath.item >= fdIndex && indexPath.item < fdIndex + nDays {
            let goalsForCell = goals[dateString] ?? []
            cell.setup(day: String(fromStartOfMonthIndexPath.item + 1), goalCount: goalsForCell.count, isEnabled: true)
            cell.isUserInteractionEnabled = true
        } else {
            var dayForCell = ""
            if indexPath.item < fdIndex {
                let prevMonthInfo = monthInfo[indexPath.section - 1]!
                let prevMonthDayCount = Int(prevMonthInfo[numberOfDaysIndex])
                dayForCell = String(prevMonthDayCount - fdIndex + indexPath.item + 1)
            } else {
                dayForCell = String(indexPath.item - fdIndex - nDays + 1)
            }
            cell.setup(day: dayForCell, goalCount: 0, isEnabled: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        var month = String(monthInfo[indexPath.section]![monthIndex])
        let year = String(monthInfo[indexPath.section]![yearIndex])
        if month.count == 1 { month = "0" + month}
        let sds = String(indexPath.row) + "/" + month + "/" + year
        if selectedDateString == sds {
            selectedDateString = ""
            lastSelectedCollectionViewIndexPath = nil
            collectionView.deselectItem(at: indexPath, animated: false)
            return false
        } else {
            selectedDateString = sds
            lastSelectedCollectionViewIndexPath = indexPath
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if didScrollCollectionViewToToday {
            return
        }
        let initalSection = numberOfSectionsInCollectionView - 13
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        guard let attri = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: initalSection)) else { return }
        collectionView.setContentOffset(CGPoint(x: attri.frame.origin.x - 2, y: 0), animated: false)
        didScrollCollectionViewToToday = true
    }
}

extension CalendarViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1 {
            let section = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            updateHeaderView(offset: section)
        }
    }
}


extension CalendarViewController: CalendarVCToHeaderViewDelegate {
    func leftButtonTapped() {
        scrollCollectionView(sectionOffset: -1)
    }
    
    func rightButtonTapped() {
        scrollCollectionView(sectionOffset: 1)
    }
    
    func scrollCollectionView(sectionOffset: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CalendarTableViewCell
        guard let cv = cell.calendarCollectionView else { return }
        
        let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
        
        let newSection = Int(round(cv.contentOffset.x / cv.frame.width)) + sectionOffset
        if newSection < 0 || newSection >= cv.numberOfSections { return }
        guard let attri = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: newSection)) else { return }
        cv.setContentOffset(CGPoint(x: attri.frame.origin.x - 2, y: 0), animated: true)
    }
    
    
}

extension CalendarViewController: GoalCompletionDelegate {
    func goalWasCompleted(goal: Goal) {
        if self.isViewLoaded == false {
            return
        }
        
        let today = Date()
        let dateString = formatter.string(from: today)
        if var _ = goals[dateString] {
            goals[dateString]!.append(goal)
        } else {
            goals[dateString] = [goal]
        }
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        let tvCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CalendarTableViewCell
        let cv = tvCell.calendarCollectionView
        
        let dateDif = self.gregorian.components(.month, from: startDate, to: today, options: NSCalendar.Options())
        cv?.reloadSections(IndexSet([dateDif.month!]))
        if let ip = lastSelectedCollectionViewIndexPath {
            cv?.selectItem(at: ip, animated: false, scrollPosition: .bottom)
            tableView.reloadSections(IndexSet([1]), with: .none)
        }
    }
}
