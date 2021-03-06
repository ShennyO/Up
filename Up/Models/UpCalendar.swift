//
//  Calendar.swift
//  Up
//
//  Created by Tony Cioara on 5/1/19.
//

import Foundation

class UpCalendar {
    
    static let shared = UpCalendar()
    
    var dayDict = [String: UpCalendarDay]()
    
    var startDate = Date()
    var endDate = Date()
    
    init() {
        self.fetchData()
    }
    
    func findDay(completionYear year: Int, month: Int, day: Int) -> UpCalendarDay? {
        let y = String(year)
        
        var d = String(day)
        if d.count == 1 { d = "0" + d }
    
        var m = String(month)
        if m.count == 1 { m = "0" + m}
        
        let key = d + "/" + m + "/" + y
        return dayDict[key]
    }
    
    func findDay(completionDate: Date) -> UpCalendarDay? {
        let key = formatter.string(from: completionDate)
        return dayDict[key]
    }
    
    func findDay(key: String) -> UpCalendarDay? {
        return dayDict[key]
    }
    
    func appendGoal(goal: Goal)  {
        let key = formatter.string(from: goal.completionDate!)
        if let day = dayDict[key] {
            day.appendGoal(goal: goal)
        } else {
            dayDict[key] = UpCalendarDay(goals: [goal])
        }
    }
    
    func generateKey(date: Date) -> String {
        let key = formatter.string(from: date)
        return key
    }
    
    func generateKey(year: Int, month: Int, day: Int) -> String {
        let y = String(year)
        
        var d = String(day)
        if d.count == 1 { d = "0" + d }
        
        var m = String(month)
        if m.count == 1 { m = "0" + m}
        
        let key = d + "/" + m + "/" + y
        return key
    }
    
    //    MARK: Private
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private let coreDataStack = CoreDataStack.instance
    
    private lazy var gregorian : NSCalendar = {
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        cal.timeZone = TimeZone.current
        return cal
    }()
    
    private func fetchData() {
        let goalsArr = coreDataStack.fetchGoal(type: .all, completed: .completed, sorting: .completionDateAscending) as! [Goal]
        if goalsArr.count == 0 {
            startDate = gregorian.date(byAdding: .year, value: -1, to: Date(), options: NSCalendar.Options())!
            endDate = gregorian.date(byAdding: .year, value: 1, to: Date(), options: NSCalendar.Options())!
            return
        }
        startDate = gregorian.date(byAdding: .year, value: -1, to: goalsArr[0].completionDate!, options: NSCalendar.Options())!
        endDate = gregorian.date(byAdding: .year, value: 1, to: goalsArr.last!.completionDate!, options: NSCalendar.Options())!
        
        for goal in goalsArr {
            self.appendGoal(goal: goal)
        }
    }
    
}

class UpCalendarDay {
    
    init(goals: [Goal]) {
        for goal in goals {
            self.appendGoal(goal: goal)
        }
    }
    
    private(set) var itemCount = 0
    private(set) var goals = [[Goal]]()
    
    func sectionCount() -> Int {
        return goals.count
    }
    
    func appendGoal(goal: Goal) {
        
        if itemCount == 0 {
            goals.append([goal])
            itemCount += 1
            return
        }
        
        guard let last = goals.last?.last else {
            goals.append([goal])
            itemCount += 1
            return
        }
        
        let comparison = Calendar.current.compare(last.completionDate!, to: goal.completionDate!, toGranularity: .hour)
        
        switch comparison {
        case ComparisonResult.orderedSame:
            goals[goals.count - 1].append(goal)
            itemCount += 1
        default:
            goals.append([goal])
            itemCount += 1
        }
    }
    
    func removeGoal(subArrayIndex: Int, itemIndex: Int) -> Bool{
        
        if goals.count <= subArrayIndex {
            return false
        }
        
        if goals[subArrayIndex].count <= itemIndex {
            return false
        }
        
        self.itemCount -= 1
        
        if goals[subArrayIndex].count == 1 {
            goals.remove(at: subArrayIndex)
            return true
        }
        
        goals[subArrayIndex].remove(at: itemIndex)
        return true
    }
    
}
