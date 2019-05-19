//
//  CalendarViewController.swift
//  Up
//
//  Created by Tony Cioara on 4/19/19.
//

import Foundation
import UIKit

protocol CalendarGoalDelegate {
    func restoredGoal(goal: Goal)
}

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
    
    var lastNumberOfSectionsOfTableView = 0
    let extraSectionsInTableView = 2
    
    var lastScrollViewOffset: CGFloat = 0

    var monthInfo = [Int:[Int]]()
    
    let firstDayIndex = 0
    let numberOfDaysIndex = 1
    let monthIndex = 2
    let yearIndex = 3
    
    var selectedDateKey = "" {
        didSet {
            reloadTableViewGoals()
        }
    }
    
    var upCalendar = UpCalendar()
    
    let coreDataStack = CoreDataStack.instance
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    
    var headerViewDelegate: HeaderViewToCalendarVCDelegate?
    var calendarGoalDelegate: CalendarGoalDelegate?
    
    lazy var gregorian : NSCalendar = {
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        cal.timeZone = TimeZone.current
        return cal
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
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
        if goalsArr.count == 0 {
            startDate = gregorian.date(byAdding: .year, value: -1, to: Date(), options: NSCalendar.Options())!
            endDate = gregorian.date(byAdding: .year, value: 1, to: Date(), options: NSCalendar.Options())!
            return
        }
        startDate = gregorian.date(byAdding: .year, value: -1, to: goalsArr[0].completionDate!, options: NSCalendar.Options())!
        endDate = gregorian.date(byAdding: .year, value: 1, to: goalsArr.last!.completionDate!, options: NSCalendar.Options())!
        
        for goal in goalsArr {
            upCalendar.appendGoal(goal: goal)
        }
    }
    
    func setupTableView() {
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: calendarTableViewCellID)
        tableView.register(CalendarGoalTableViewCell.self, forCellReuseIdentifier: calendarGoalTableViewCellID)
        
        tableView.tag = 0
        tableView.backgroundColor = Style.Colors.Palette01.gunMetal
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setupViews() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
    }
    
    func updateCalendarHeaderView(offset: Int) {
        guard let headerViewDelegate = self.headerViewDelegate else { return }
        
        var monthOffsetComponents = DateComponents()
        monthOffsetComponents.month = Int(offset)
        
        guard let yearDate = self.gregorian.date(byAdding: monthOffsetComponents, to: self.startOfMonth, options: NSCalendar.Options()) else { return }
        
        let month = (self.gregorian.component(.month, from: yearDate) - 1) % 12
        
        let monthName = DateFormatter().monthSymbols[month] // 0 indexed array
        
        let year = String(self.gregorian.component(.year, from: yearDate))
        
        headerViewDelegate.changeLabelText(text: monthName + " " + year)
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
        guard let day = upCalendar.findDay(key: selectedDateKey) else {
            lastNumberOfSectionsOfTableView = extraSectionsInTableView
            return extraSectionsInTableView
        }
        
        lastNumberOfSectionsOfTableView = extraSectionsInTableView + day.sectionCount()
        return lastNumberOfSectionsOfTableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 0
        default:
            guard let day = upCalendar.findDay(key: selectedDateKey) else { return 0 }
            return day.goals[section - extraSectionsInTableView].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
//            This cell contains the CalendarCollectionView
            let cell = tableView.dequeueReusableCell(withIdentifier: calendarTableViewCellID, for: indexPath) as! CalendarTableViewCell
            cell.configureProtocols(delegate: self, dataSource: self, headerViewDelegate: self)
            headerViewDelegate = cell.calendarHeaderView
            updateCalendarHeaderView(offset: 0)
            return cell
        default:
//            This cell displays one goal at a time
            guard let day = upCalendar.findDay(key: selectedDateKey) else { fatalError() }
            
            let goal = day.goals[indexPath.section - extraSectionsInTableView][indexPath.row]
        
            let cell = tableView.dequeueReusableCell(withIdentifier: calendarGoalTableViewCellID, for: indexPath) as! CalendarGoalTableViewCell
            cell.setup(goal: goal)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
//            This cell contains the CalendarCollectionView
            let cvHeight: CGFloat = (tableView.frame.width - 32) / 7 * 6
            let headerHeight: CGFloat = 90
            let containerInsets: CGFloat = 32
            return cvHeight + headerHeight + containerInsets
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 16
        case 1:
            return 8
        case lastNumberOfSectionsOfTableView - 1:
            return 32
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 40
        default:
            return 68
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            let headerView = CalendarGoalCountHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 68))
            if let day = upCalendar.findDay(key: selectedDateKey) {
                if day.itemCount == 0 {
                    headerView.setup(text: "No tasks were completed on that day.")
                } else {
                    headerView.setup(dateString: selectedDateKey, goalCount: day.itemCount)
                }
            } else if selectedDateKey != ""  {
                headerView.setup(text: "No tasks were completed on that day.")
            } else {
                headerView.setup(text: "Select a date to view acomplishments.")
            }
            return headerView
        default:
            guard let day = upCalendar.findDay(key: selectedDateKey) else { fatalError() }
            let headerView = CalendarTimeHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 68))
            let goal = day.goals[section - extraSectionsInTableView][0]
            let hour = gregorian.component(.hour, from: goal.completionDate!)
            headerView.setup(time: hour)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section < extraSectionsInTableView {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let delete = deleteAction(indexPath: indexPath)
        let edit = restoreAction(indexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func deleteAction(indexPath: IndexPath) -> UIContextualAction {
        guard let day = upCalendar.findDay(key: selectedDateKey) else { fatalError() }
        let goal = day.goals[indexPath.section - extraSectionsInTableView][indexPath.row]
        let prevNumOfRows = day.goals[indexPath.section - extraSectionsInTableView].count
        
        let action = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            self.coreDataStack.viewContext.delete(goal)
            self.coreDataStack.saveTo(context: self.coreDataStack.viewContext)
            let completed = day.removeGoal(subArrayIndex: indexPath.section - self.extraSectionsInTableView, itemIndex: indexPath.row)
            if !completed {
                fatalError()
            }
            
            self.deleteRowInTableView(indexPath: indexPath, numOfRowsInSection: prevNumOfRows - 1)
            completion(true)
        }
        
        action.backgroundColor = Style.Colors.Palette01.gunMetal
        
        action.image = UIGraphicsImageRenderer(size: CGSize(width: widthScaleFactor(distance: 21), height: widthScaleFactor(distance: 21))).image { _ in
            #imageLiteral(resourceName: "deleteIcon").draw(in: CGRect(x: 0, y: 0, width: widthScaleFactor(distance: 21), height: widthScaleFactor(distance: 21)))
        }
        
        return action
    }
    
    func restoreAction(indexPath: IndexPath) -> UIContextualAction {
        guard let day = upCalendar.findDay(key: selectedDateKey) else { fatalError() }
        let goal = day.goals[indexPath.section - extraSectionsInTableView][indexPath.row]
        let prevNumOfRows = day.goals[indexPath.section - extraSectionsInTableView].count
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            goal.completionDate = nil
            self.coreDataStack.saveTo(context: self.coreDataStack.viewContext)
            let completed = day.removeGoal(subArrayIndex: indexPath.section - self.extraSectionsInTableView, itemIndex: indexPath.row)
            if !completed {
                fatalError()
            }
            if let calendarGoalDelegate = self.calendarGoalDelegate {
                calendarGoalDelegate.restoredGoal(goal: goal)
            }
            self.deleteRowInTableView(indexPath: indexPath, numOfRowsInSection: prevNumOfRows - 1)
            
            completion(true)
        }
        
        action.backgroundColor = Style.Colors.Palette01.gunMetal
        action.image = UIGraphicsImageRenderer(size: CGSize(width: widthScaleFactor(distance: 21), height: widthScaleFactor(distance: 21))).image { _ in
            #imageLiteral(resourceName: "reset-icon-2").draw(in: CGRect(x: 0, y: 0, width: widthScaleFactor(distance: 21), height: widthScaleFactor(distance: 21)))
        }
        return action
    }
    
    func reloadTableViewGoals() {
        
        let lastNumOfSections = lastNumberOfSectionsOfTableView
        let numOfSections = numberOfSections(in: tableView)
        let sectionsToAdd = numOfSections - lastNumOfSections
        
        tableView.beginUpdates()
        
        if sectionsToAdd == 0 && lastNumOfSections > extraSectionsInTableView {
            var sectionsToReload = [Int]()
            for i in extraSectionsInTableView..<lastNumOfSections {
                sectionsToReload.append(i)
            }
            tableView.reloadSections(IndexSet(sectionsToReload), with: .fade)
        } else if sectionsToAdd > 0 {
            var sectionsToReload = [Int]()
            for i in extraSectionsInTableView..<lastNumOfSections {
                sectionsToReload.append(i)
            }
            tableView.reloadSections(IndexSet(sectionsToReload), with: .fade)
            
            var sectionsToInsert = [Int]()
            for i in lastNumOfSections..<numOfSections {
                sectionsToInsert.append(i)
            }
            tableView.insertSections(IndexSet(sectionsToInsert), with: .fade)
        } else if sectionsToAdd < 0 {
            var sectionsToReload = [Int]()
            for i in extraSectionsInTableView..<numOfSections {
                sectionsToReload.append(i)
            }
            tableView.reloadSections(IndexSet(sectionsToReload), with: .fade)
            var sectionsToDelete = [Int]()
            for i in numOfSections..<lastNumOfSections {
                sectionsToDelete.append(i)
            }
            tableView.deleteSections(IndexSet(sectionsToDelete), with: .fade)
        }
        tableView.reloadSections(IndexSet([1]), with: .fade)
        tableView.endUpdates()
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func deleteRowInTableView(indexPath: IndexPath, numOfRowsInSection: Int) {
        self.tableView.isUserInteractionEnabled = false
        let currentFooterView = self.tableView.tableFooterView // Steal the current footer view
        let newView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tableView.bounds.width, height: self.tableView.bounds.height*2.0)) // Create a new footer view with large enough height (Really making sure it is large enough)
        if let currentFooterView = currentFooterView {
            // Put the current footer view as a subview to the new one if it exists (this was not really tested)
            currentFooterView.frame.origin = .zero // Just in case put it to zero
            newView.addSubview(currentFooterView) // Add as subview
        }
        self.tableView.tableFooterView = newView // Assign a new footer
        
        if let headerView = self.tableView.headerView(forSection: 1) as? CalendarGoalCountHeaderView {
            headerView.updateGoalCount(addition: -1)
        }
        
        
        self.tableView.beginUpdates()
        if numOfRowsInSection == 0 {
            self.tableView.deleteSections(IndexSet([indexPath.section]), with: .left)
        } else {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CalendarTableViewCell {
            let cv = cell.calendarCollectionView!
            
            if let lastSelectedCollectionViewIndexPath = lastSelectedCollectionViewIndexPath {
                let cvCell = cv.cellForItem(at: lastSelectedCollectionViewIndexPath) as! CalendarCollectionViewCell
                cvCell.adjustBackgroundColor(addition: -1)
            }
        }
        
        self.tableView.endUpdates()
        self.tableView.tableFooterView = currentFooterView
        self.tableView.isUserInteractionEnabled = true
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
        let month = currentMonthInfo[monthIndex]
        let year = currentMonthInfo[yearIndex]
        let nDays = Int(currentMonthInfo[numberOfDaysIndex])
        
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - fdIndex, section: indexPath.section) // if the first is wednesday, add 2
        
        if indexPath.item >= fdIndex && indexPath.item < fdIndex + nDays {
            let key = upCalendar.generateKey(year: year, month: month, day: indexPath.row - fdIndex + 1)
            var goalCount = 0
            if let day = upCalendar.findDay(key: key) {
                goalCount = day.itemCount
            }
            cell.setup(day: String(fromStartOfMonthIndexPath.item + 1), goalCount: goalCount, isEnabled: true)
            cell.isUserInteractionEnabled = true
            
            if let selected = lastSelectedCollectionViewIndexPath {
                if selected == indexPath {
                    cell.isSelected = true
                }
            }
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
        
        let currentMonthInfo = monthInfo[indexPath.section]!
        
        let fdIndex = Int(currentMonthInfo[firstDayIndex])
        let month = currentMonthInfo[monthIndex]
        let year = currentMonthInfo[yearIndex]
        
        let key = upCalendar.generateKey(year: year, month: month, day: indexPath.row - fdIndex + 1)
        if selectedDateKey == key {
            selectedDateKey = ""
            lastSelectedCollectionViewIndexPath = nil
            collectionView.deselectItem(at: indexPath, animated: false)
            return false
        } else {
            selectedDateKey = key
            lastSelectedCollectionViewIndexPath = indexPath
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if didScrollCollectionViewToToday {
            return
        }
        
        guard let initalSection = gregorian.components(.month, from: startDate, to: Date(), options: NSCalendar.Options()).month
            else { return }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        guard let attri = layout.layoutAttributesForItem(at: IndexPath(item: 0, section: initalSection)) else { return }
        collectionView.setContentOffset(CGPoint(x: attri.frame.origin.x - 2, y: 0), animated: false)
        didScrollCollectionViewToToday = true
    }
}

extension CalendarViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.tag {
        case 1:
            let section = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            updateCalendarHeaderView(offset: section)
        default:
            return
        }
    }
}


extension CalendarViewController: CalendarViewToHeaderViewDelegate {
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
        
        upCalendar.appendGoal(goal: goal)
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        let tvCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CalendarTableViewCell
        let cv = tvCell.calendarCollectionView
        
        let dateDif = self.gregorian.components(.month, from: startDate, to: Date(), options: NSCalendar.Options())
        cv?.reloadSections(IndexSet([dateDif.month!]))
        if let ip = lastSelectedCollectionViewIndexPath {
            cv?.selectItem(at: ip, animated: false, scrollPosition: .bottom)
            
//            Refactor this into a function with all the possible edge cases
            //            Edge case: what if the task they just added is a different hour from previous tasks
            //            Edge case: what happens if they selected a day and they just switch to another day
            let lastNumOfSections = lastNumberOfSectionsOfTableView
            let numOfSections = numberOfSections(in: tableView)
            
            tableView.beginUpdates()
            if lastNumOfSections < numOfSections {
                tableView.insertSections(IndexSet([lastNumOfSections]), with: .none)
            } else {
                tableView.reloadSections(IndexSet([lastNumOfSections - 1]), with: .none)
            }
            tableView.reloadSections(IndexSet([1]), with: .none)
            tableView.endUpdates()
        }
    }
}
