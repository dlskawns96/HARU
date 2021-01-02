//
//  ViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import UIKit
import FSCalendar
import AFDateHelper

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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print(dateFormatter.string(from: date))

        guard let controller = self.storyboard?.instantiateViewController(identifier: "SelectDateController") as? SelectDateController else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        controller.paramDate = dateFormatter.string(from: date)

        self.present(controller, animated: true, completion: nil)
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let eves = loadedEvents.filter({$0.startDate.compare(.isSameDay(as: date))})
        return eves.count
    }
    
    // 이벤트를 색 지정
    // TODO: 있는 이벤트들의 Date 만 모아서 datesWithEvent, datesWithMultipleEvents로 만들기
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        print(date)
        let eves = loadedEvents.filter({$0.startDate.compare(.isSameDay(as: date))})
        
        if eves.count == 1 {
            return [eves[0].color]
        }
        if eves.count > 1 {
            var colors:[UIColor] = []
            eves.forEach {
                colors.append($0.color)
            }
            return colors
        }
        return nil
    }
}

