//
//  CalendarHelpers.swift
//  Up
//
//  Created by Tony Cioara on 4/19/19.
//

import Foundation

extension Calendar {
    
    static func getFirstWeekDay(monthIndex: Int, year: Int) -> Int {
        let dateStr = "\(year)-\(monthIndex)-01"
        let dateFormatter = DateFormatter()
        if monthIndex < 10  {
            dateFormatter.dateFormat = "yyyy'-'M'-'dd"
        } else {
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        }
        let date = dateFormatter.date(from: dateStr)
        let firstDay = Calendar.current.component(.weekday, from: date!)
        return firstDay
    }
    
}
