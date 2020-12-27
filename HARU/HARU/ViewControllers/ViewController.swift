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
    var loadedEvents: [CalendarLoader.EVENT] = []
    var labels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarLoader = CalendarLoader()
        self.loadedEvents = calendarLoader.loadedEvents
        print("ViewController - Events Loaded:")
        print(loadedEvents)
        
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print(dateFormatter.string(from: date))
                    
        guard let controller = self.storyboard?.instantiateViewController(identifier: "SelectDateController") as? SelectDateController else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        controller.paramDate = dateFormatter.string(from: date)

        self.present(controller, animated: true, completion: nil)
    }

    
    // 현재 화면에 표시된 날짜만 적용
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        let curDate = Calendar.current.dateComponents([.year, .month, .day], from: date)
//        let eventNum = loadedEvents.count
//
//        for event in loadedEvents {
//            let eventDate = Calendar.current.dateComponents([.year, .month, .day], from: event.startDate as Date)
//            if curDate.year == eventDate.year && curDate.month == eventDate.month && curDate.day == eventDate.day {
//                let labelMy2 = UILabel(frame: CGRect(x: 10, y: 30, width: cell.bounds.width, height: 50))
//                labelMy2.font = UIFont(name: "Henderson BCG Sans", size: 10)
//                labelMy2.text = event.title
//                labelMy2.layer.cornerRadius = cell.bounds.width/2
//                labelMy2.textColor = UIColor.init(named: "#32C77F")
//                labelMy2.backgroundColor = event.color
//                labels.append(labelMy2)
//                cell.addSubview(labelMy2)
//                print(curDate)
//                print(eventDate)
//                print(labels.count)
//            }
//        }
    }
}

