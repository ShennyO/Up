//
//  ChartsDataSource.swift
//  Up
//
//  Created by Tony Cioara on 7/27/19.
//

import Foundation

class ChartsDataSource {
    
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
    
    private func fetchData() {
        self.goals = coreDataStack.fetchGoal(type: .all, completed: .completed, sorting: .completionDateAscending) as! [Goal]
        for goal in self.goals {
            let comparison = gregorian.
            if yearStartIndex == nil && {
                
            }
        }
    }
    
    private func getLastDay() {
        let now = Date()
        for goal in goals {
            if let goalDate = goal.date {
                let comparison = gregorian.compare(goalDate, to: now, toUnitGranularity: .day)
            }
            
        }
    }
}
