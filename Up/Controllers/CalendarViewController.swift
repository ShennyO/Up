//
//  CalendarViewController.swift
//  Up
//
//  Created by Sunny Ouyang on 4/17/19.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    //MARK: VARIABLES
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: OUTLETS
    let calendarView = JTAppleCalendarView()
    
    //MARK: PRIVATE FUNCS
    private func configNavBar() {
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpCalendar() {
        self.view.addSubview(calendarView)
        calendarView.minimumLineSpacing = 2
        calendarView.minimumInteritemSpacing = 2
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: "calendarCell")
        calendarView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(350)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        self.view.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
        setUpCalendar()

        // Do any additional setup after loading the view.
    }
    


}

extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.setUpCell()
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.setUpCell()
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2020 01 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday, hasStrictBoundaries: false)
        return parameters
    }
    
    
}
