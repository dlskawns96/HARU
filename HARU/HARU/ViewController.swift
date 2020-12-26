//
//  ViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    @IBOutlet weak var fsCalendar: FSCalendar!
    var eventStartDates: [NSDate] = []
    var eventEndDates: [NSDate] = []
    var eventTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarLoader = CalendarLoader()
        eventStartDates = calendarLoader.startDates
        eventEndDates = calendarLoader.endDates
        eventTitles = calendarLoader.titles
        
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
        fsCalendar.locale = Locale(identifier: "ko_KR")
        fsCalendar.headerHeight = 50
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        fsCalendar.appearance.headerDateFormat = "YYYY년 M월"
        fsCalendar.appearance.headerTitleColor = .black
        fsCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        fsCalendar.appearance.borderRadius = 0
    }

//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return 2
//    }
    
//    func setUpEvents() {
//    let formatter = DateFormatter()
//    formatter.locale = Locale(identifier: "ko_KR")
//    formatter.dateFormat = "yyyy-MM-dd"
//    let xmas = formatter.date(from: "2020-12-25")
//    let sampledate = formatter.date(from: "2020-08-22")
//    events = [xmas!, sampledate!]
//    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let curDate = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        if curDate.year == today.year && curDate.month == today.month && curDate.day == today.day {
            let labelMy2 = UILabel(frame: CGRect(x: 10, y: 30, width: cell.bounds.width, height: 50))
            labelMy2.font = UIFont(name: "Henderson BCG Sans", size: 10)
            labelMy2.text = "abc"
            labelMy2.layer.cornerRadius = cell.bounds.width/2
            labelMy2.textColor = UIColor.init(named: "#32C77F")
            cell.addSubview(labelMy2)
        }
    }
}

