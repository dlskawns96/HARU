//
//  ViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import UIKit
import Foundation
import FSCalendar
import AFDateHelper
import EventKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    var eventStartDates: [NSDate] = []
    var eventEndDates: [NSDate] = []
    var eventTitles: [String] = []
    var loadedEvents: [EKEvent] = []
    var labels: [UILabel] = []
    let calendarLoader = CalendarLoader()
    
    var token: NSObjectProtocol?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        for weekday in fsCalendar.calendarWeekdayView.weekdayLabels {
            if weekday.text == "일" {
                weekday.textColor = .red
            } else if weekday.text == "토" {
                weekday.textColor = .blue
            } else {
                weekday.textColor = .black
            }
        }
        
        token = NotificationCenter.default.addObserver(forName: AddEventViewController.eventChangedNoti, object: nil,
                queue: OperationQueue.main) {_ in
            self.loadedEvents = self.calendarLoader.loadEvents()
            self.fsCalendar.reloadData()
                }
    }
    
    deinit {
            if let token = token {
                NotificationCenter.default.removeObserver(token)
            }
        }
    
    // MARK: - Button Actions
    @IBAction func onAddEventBtnClicked(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "AddEvent", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "AddEventNavigationViewController") as UINavigationController? else { return }
        controller.modalPresentationStyle = .pageSheet
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func onEventCollectionBtnClicked(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(identifier: "EventCollectionTableViewController") as UINavigationController? else { return }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func DiaryCollectionBtnClicked(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(identifier: "DiaryCollectionTableViewController") as UINavigationController? else { return }
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
    }
    
    /// 해당 날짜의 이벤트를 리턴 해주는 함수
    func loadEventsOfDay(for date: Date) -> [EKEvent] {
        var events: [EKEvent] = []
        
        for event in loadedEvents {
            if event.startDate.compare(.isSameDay(as: date)) {
                events.append(event)
            }
        }
        return events
    }
}

// MARK: - Extensions
extension ViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // Implement protocols
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let controller = self.storyboard?.instantiateViewController(identifier: "SelectDateController") as? SelectDateController else { return }
        controller.modalPresentationStyle = .pageSheet
        controller.selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let AD = UIApplication.shared.delegate as? AppDelegate
        AD?.selectedDate = dateFormatter.string(from: date)
        AD?.selectedDateEvents = loadEventsOfDay(for: date)
        self.present(controller, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let eves = loadedEvents.filter({$0.startDate.compare(.isSameDay(as: date))})
        
        if eves.count != 0 {
            var posY = 50
            for eve in eves {
                let lab = UILabel(frame: CGRect(x: 0, y: posY, width: Int(cell.bounds.width), height: 15))
                lab.font = .systemFont(ofSize: 12, weight: .regular)
                lab.lineBreakMode = .byCharWrapping
                lab.text = eve.title
                lab.textColor = UIColor.init(named: "#32C77F")
                cell.addSubview(lab)
                lab.backgroundColor = UIColor(cgColor: eve.calendar.cgColor)
                posY = posY + 15
            }
            
        } else {
            for view in cell.subviews {
                if view is UILabel {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let isSameMon: Bool = date.isSameAs(as: .month, from: calendar.currentPage)
        if !isSameMon {
            return nil
        }
        if getWeekDay(for: date) == "Sunday" {
            return .red
        }
        if getWeekDay(for: date) == "Saturday" {
            return .blue
        }
        return nil
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
    }
}

extension Date {
    
    func isSameAs(as compo: Calendar.Component, from date: Date) -> Bool {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        return cal.component(compo, from: date) == cal.component(compo, from: self)
    }
    
    func dayBefore() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
