//
//  Calendar.swift
//  Up
//
//  Created by Tony Cioara on 5/1/19.
//

import Foundation

class UpCalendar {
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private var dayDict = [String: UpCalendarDay]()
    
    func findGoals(completion year: String, month: String, day: String) -> UpCalendarDay? {
        let key = day + "/" + month + "/" + year
        return dayDict[key]
    }
    
    func findGoals(completionDate: Date) -> UpCalendarDay? {
        let key = formatter.string(from: completionDate)
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
    
}

class UpCalendarDay {
    
    init(goals: [Goal]) {
        for goal in goals {
            self.appendGoal(goal: goal)
        }
    }
    
    private var count = 0
    private var goals = [[Goal]]()
    
    func appendGoal(goal: Goal) {
        
        if count == 0 {
            goals.append([goal])
            count += 1
            return
        }
        
        guard let last = goals.last?.last else {
            goals.append([goal])
            count += 1
            return
        }
        
        let comparison = Calendar.current.compare(last.completionDate!, to: goal.completionDate!, toGranularity: .hour)
        
        switch comparison {
        case ComparisonResult.orderedSame:
            goals[goals.count - 1].append(goal)
            count += 1
        default:
            goals.append([goal])
            count += 1
        }
    }
    
}
