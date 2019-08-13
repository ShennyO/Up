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
    let now = Date()
    
    private var sixMonthStartIndex: Int?
    private var thirtyDayStartIndex: Int?
    private var sevenDayStartIndex: Int?
    
    private lazy var gregorian : NSCalendar = {
        let cal = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        cal.timeZone = TimeZone.current
        return cal
    }()
    
    init() {
        fetchData()
    }
    
    func getSixMonthData() -> [Double] {
        let currentMonth = gregorian.component(.month, from: Date())
        var result = [Double](repeating: 0, count: 6)
        guard let sixMonthStartIndex = sixMonthStartIndex else {
            return result
        }
        for index in sixMonthStartIndex..<goals.count {
            let goal = goals[index]
            if let completionDate = goal.completionDate {
                let month = gregorian.component(.month, from: completionDate)
                let index = 5 - currentMonth + month
                result[index] += 1
            }
        }
        return result
    }
    
    func getThirtyDayData() -> [Double] {
        let currentDay = gregorian.startOfDay(for: Date())
        var result = [Double](repeating: 0, count: 30)
        guard let thirtyDayStartIndex = thirtyDayStartIndex else {
            return result
        }
        for index in thirtyDayStartIndex..<goals.count {
            let goal = goals[index]
            if let completionDate = goal.completionDate {
                let day = gregorian.startOfDay(for: completionDate)
                let components = gregorian.components(.day, from: day, to: currentDay, options: NSCalendar.Options())
                let index = 29 - (components.day ?? 0)
                result[index] += 1
            }
        }
        return result
    }
    
    func getSevenDayData() -> [Double] {
        let currentDay = gregorian.startOfDay(for: Date())
        var result = [Double](repeating: 0, count: 7)
        guard let sevenDayStartIndex = sevenDayStartIndex else {
            return result
        }
        for index in sevenDayStartIndex..<goals.count {
            let goal = goals[index]
            if let completionDate = goal.completionDate {
                let day = gregorian.startOfDay(for: completionDate)
                let components = gregorian.components(.day, from: day, to: currentDay, options: NSCalendar.Options())
                let index = 6 - (components.day ?? 0)
                result[index] += 1
            }
        }
        return result
    }
    
    func getSevenDayLabels() -> [String] {
        let today = gregorian.component(.weekday, from: now)
        print("Today is: ", today)
        
        return ChartType.stringValuesWith(.sevenDays, currentIndex: today)
    }
    func getSixMonthLabels() -> [String] {
        let currentMonth = gregorian.component(.month, from: now)
        return ChartType.stringValuesWith(.sixMonths, currentIndex: currentMonth)
    }
    
    private func fetchData() {
        let now = Date()
        goals = coreDataStack.fetchGoal(type: .all, completed: .completed, sorting: .completionDateAscending) as! [Goal]
        for index in 0..<goals.count {
            let goal = goals[index]
            if let completionDate = goal.completionDate {
                if sixMonthStartIndex == nil && moreThan(unit: .month, value: 1, from: completionDate, to: now) {
                    sixMonthStartIndex = index
                }
                if thirtyDayStartIndex == nil && moreThan(unit: .day, value: 30, from: completionDate, to: now) {
                    thirtyDayStartIndex = index
                }
                if sevenDayStartIndex == nil && moreThan(unit: .day, value: 7, from: completionDate, to: now) {
                    sevenDayStartIndex = index
                }
            }
            
        }
    }
    
    private func moreThan(unit: NSCalendar.Unit, value: Int, from: Date, to: Date) -> Bool {
        let startDate = gregorian.date(byAdding: unit, value: -value, to: to, options: NSCalendar.Options())!
        let comparison = gregorian.compare(from, to: startDate, toUnitGranularity: .day)
        if comparison == .orderedAscending {
            return false
        }
        return true
    }
}
