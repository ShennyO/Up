//
//  StatsType.swift
//  Up
//
//  Created by Elmer Astudillo on 4/26/19.
//

import Foundation

enum ChartType: String{
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    enum Day: String, CaseIterable{
        case sunday = "Sun"
        case monday = "Mon"
        case tuesday = "Tue"
        case wednesday = "Wed"
        case thursday = "Thu"
        case friday = "Fri"
        case saturday = "Sat"
    }
    
    enum Hour: String, CaseIterable{
        case zero = "12AM"
        case one = "1AM"
        case two = "2AM"
        case three = "3AM"
        case four = "4AM"
        case five = "5AM"
        case six = "6AM"
        case seven = "7AM"
        case eight = "8AM"
        case nine = "9AM"
        case ten = "10AM"
        case eleven = "11AM"
        case twelve = "12PM"
        case thirteen = "1PM"
        case fourteen = "2PM"
        case fifteen = "3PM"
        case sixteen = "4PM"
        case seventeen = "5PM"
        case eighteen = "6PM"
        case nineteen = "7PM"
        case twenty = "8PM"
        case twentyone = "9PM"
        case twentytwo = "10PM"
        case twentythree = "11PM"
    }
    
    enum Month: String, CaseIterable{
        case january = "Jan"
        case february = "Feb"
        case march = "Mar"
        case april = "Apr"
        case may = "May"
        case june = "Jun"
        case july = "Jul"
        case august = "Aug"
        case september = "Sep"
        case october = "Oct"
        case November = "Nov"
        case December = "Dec"
    }
    
    static func allStringValues(_ chartType: ChartType) -> [String] {
        switch chartType {
        case .day:
            let values = Hour.allCases.map { $0.rawValue }
            return values
        case .week:
            let values = Day.allCases.map { $0.rawValue }
            return values
        case .month:
            let values = Array(1...30)
            let stringValues = values.map { String($0) }
            return stringValues
        case .year:
            let values = Month.allCases.map { $0.rawValue }
            return values
        }
    }
    
    static func stringValuesWith(_ chartType: ChartType, startingIndex: Int) -> [String] {
        switch chartType {
        case .week:
            let values = Day.allCases.map { $0.rawValue }
            for i in 0..<values.count {
                let index = i + startingIndex
                print(values[index])
            }
            return []
        default:
            return []
        }
    }
}



