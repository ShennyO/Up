//
//  StatsViewController.swift
//  Up
//
//  Created by Elmer Astudillo on 4/24/19.
//

import UIKit
import SwiftChart
import SnapKit

class StatsViewController: UIViewController {
    
    
    // MARK: VARIABLES
    
    var allDays = ChartType.allStringValues(.week)
    var allDaysInMonth = ChartType.allStringValues(.month)
    var allHours = ChartType.allStringValues(.day)
    var allMonths = ChartType.allStringValues(.year)
    var chart = Chart(frame: .zero)
    
    var sixMonthData = [Double]()
    var sixMonthLabels = [String]()
    var thirtyDayData = [Double]()
    var sevenDayData = [Double]()
    
    var chartSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.addTarget(self, action: #selector(StatsViewController.segmentedControlSelected(sender:)), for: .valueChanged)
        segmentedControl.insertSegment(withTitle: "7 Days", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "30 Days", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "6 Months", at: 2, animated: true)
        return segmentedControl
    }()
    
    // MARK: HELPERS
    
    private func chartSetup(chart: inout Chart, chartData: [Double], xLabels: [String]){
        //TODO: Fetch data from Coredata
        let series = ChartSeries(chartData)
        print(chart.series)
        if chart.series.count == 1{
            chart.series.removeLast()
        }
        chart.add(series)
        // TODO: Dynamic xLabel data
        chart.xLabels = [0,1,2,3,4,5,6]
        chart.xLabelsFormatter = { String(xLabels[Int($1)]) }
        chart.yLabels = []
        chart.labelColor = .white
    }
    
//    private func setupChart(chart: inout Chart, goals: [Goal], type: ChartType) {
//        switch type {
//        case .day:
//            let today = Date()
//            for i in 1...goals.count {
//                let index = goals.count - i
//                if let comparisonResult = {
//                    if comparisonResult == .orderedSame
//                }
//            }
//        case .week:
//
//        case .month
//
//        case .year
//
//        }
//    }
    
    @objc private func segmentedControlSelected(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            let data = [0, 5.5, 0.4, 3, 6, 4.1, 3, -10]
            chartSetup(chart: &chart, chartData: sevenDayData, xLabels: allHours)
        case 1:
            let data = [0, 5.5, 2, 3.6, 6, 4.1, 3, -10]
            chartSetup(chart: &chart, chartData: thirtyDayData, xLabels: allDays)
        case 2:
            let data = [0, 5.5, 2, 3, 6, 4.1, 1, -10]
            chartSetup(chart: &chart, chartData: sixMonthData, xLabels: sixMonthLabels)
        default:
            break
        }
    }
    
    // MARK: CONSTRAINTS
    private func setConstraints(){
        chart.snp.makeConstraints { (make) in
            // TODO: Dynamic height for all screen sizes
            make.height.equalTo(400)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(chartSegmentedControl.snp.bottom).offset(20)
        }
        
        chartSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.topMargin).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sixMonthData = ChartsDataSource.shared.getSixMonthData()
        sixMonthLabels = ChartsDataSource.shared.getSixMonthLabels()
//        thirtyDayData = ChartsDataSource.shared.getThirtyDayData()
//        sevenDayData = ChartsDataSource.shared.getSevenDayData()
        sixMonthData = [30, 17, 25, 68, 40, 24]
        sevenDayData = [4, 0, 5, 16, 23, 16, 20]
        thirtyDayData = [3, 5, 8, 4, 6, 7, 10, 15, 17, 4, 17, 24, 19, 20, 4, 5, 19, 9, 5, 2, 4, 10, 1, 4, 0, 5, 16, 23, 16, 20]
//        let day
//        ChartType.stringValuesWith(.week, startingIndex: 3)
        
        chartSetup(chart: &chart, chartData:  [0, 5.5, 2, 3, 6, 4.1, 3, -10], xLabels: allHours)
        chartSegmentedControl.selectedSegmentIndex = 0
        configNavBar()
        viewSetup()
    }
}

extension StatsViewController{
    
    private func viewSetup(){
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.view.addSubview(chartSegmentedControl)
        self.view.addSubview(chart)
        setConstraints()
    }
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

