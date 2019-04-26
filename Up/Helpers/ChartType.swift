//
//  StatsType.swift
//  Up
//
//  Created by Elmer Astudillo on 4/26/19.
//

import Foundation

enum ChartType: String{
    case days = "Days"
    case week = "Week"
    case month = "Month"
    case Year = "Year"
}

enum Day: String, CaseIterable{
    case sunday = "Sun"
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
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
