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
    let chart = Chart(frame: .zero)
    
    var chartSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: ChartType.days.rawValue, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: ChartType.week.rawValue, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: ChartType.month.rawValue, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: ChartType.Year.rawValue, at: 0, animated: true)
        return segmentedControl
    }()
    
    private func chartSetup(){
        //TODO: Fetch data from Coredata
        let series = ChartSeries([0, 5.5, 2, 3, 6, 4.1, 3, -10])
        chart.add(series)
        chart.xLabels = [0,1,2,3,4,5,6]
        chart.xLabelsFormatter = { Day.allCases[Int($1)].rawValue }
        chart.xLabelsSkipLast = true
        chart.yLabels = []
        chart.labelColor = .white
        self.view.addSubview(chart)
    }
    
    private func segmentedControl(){
        
    }
    
    private func setConstraints(){
        chart.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(300)
        }
        
        chartSegmentedControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(chart.snp.top).offset(-20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        self.view.addSubview(chartSegmentedControl)
        self.chartSetup()
        self.setConstraints()
        
    }

}

