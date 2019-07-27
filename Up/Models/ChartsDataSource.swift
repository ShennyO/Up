//
//  ChartsDataSource.swift
//  Up
//
//  Created by Tony Cioara on 7/27/19.
//

import Foundation

class ChartsDataSource {
    static let shared = ChartsDataSource()
    
    var goals = [Goal]()
    let coreDataStack = CoreDataStack.instance
    
    private var yearStartIndex: Int?
    private var monthStartIndex: Int?
    private var weekStartIndex: Int?
    private var dayStartIndex: Int?
    
    private lazy var gregorian : NSCalendar = {
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        cal.timeZone = TimeZone.current
        return cal
    }()
    
    init() {
        fetchData()
    }
    
    func getYearData() -> [Int] {
        var result = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        guard let yearStartIndex = yearStartIndex else {
            return []
        }
        for index in yearStartIndex..<goals.count {
            let goal = goals[index]
            if let completionDate = goal.completionDate {
                let month = gregorian.component(.month, from: completionDate)
                result[month - 1] += 1
            }
        }
        return result
    }
    
    func getMonth() -> [Goal] {
        if let monthStartIndex = monthStartIndex {
            return Array(goals.suffix(from: monthStartIndex))
        }
        return []
    }
    
    func getWeek() -> [Goal] {
        if let weekStartIndex = weekStartIndex {
            return Array(goals.suffix(from: weekStartIndex))
        }
        return []
    }
    
    func getDay() -> [Goal] {
        if let dayStartIndex = dayStartIndex {
            return Array(goals.suffix(from: dayStartIndex))
        }
        return []
    }

    
    private func fetchData() {
        let now = Date()
        goals = coreDataStack.fetchGoal(type: .all, completed: .completed, sorting: .completionDateAscending) as! [Goal]
        for index in 0..<goals.count {
            let goal = goals[index]
            if let completionDate = goal.completionDate {
                if yearStartIndex == nil && moreThanA(unit: .year, from: completionDate, to: now) {
                    yearStartIndex = index
                }
                if monthStartIndex == nil && moreThanA(unit: .month, from: completionDate, to: now) {
                    monthStartIndex = index
                }
                if weekStartIndex == nil && moreThanA(unit: .weekOfYear, from: completionDate, to: now) {
                    weekStartIndex = index
                }
                if dayStartIndex == nil && moreThanA(unit: .day, from: completionDate, to: now) {
                    dayStartIndex = index
                }
            }
            
        }
    }
    
    private func moreThanA(unit: NSCalendar.Unit, from: Date, to: Date) -> Bool {
        let aYearBefore = gregorian.date(byAdding: unit, value: -1, to: to, options: NSCalendar.Options())!
        let comparison = gregorian.compare(from, to: aYearBefore, toUnitGranularity: .day)
        if comparison == .orderedAscending {
            return false
        }
        return true
    }
}
