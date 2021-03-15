//
//  ViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import UIKit
import Foundation
import AFDateHelper
import EventKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    var eventStartDates: [NSDate] = []
    var eventEndDates: [NSDate] = []
    var eventTitles: [String] = []
    var loadedEvents: [EKEvent] = []
    var labels: [UILabel] = []
    var calendarLoader: CalendarLoader!
    
    var token: NSObjectProtocol?
    
    let calendar = Calendar.current
    
    var dataSource: MainCalendarModel?
    var dataArray = [[[MainCalendarCellItem]]]() {
        didSet {
//            fsCalendar.reloadData()
        }
    }
    
    var current = Date() {
        didSet {
            MainCalendarCell.currentMonth = current
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        EventHandler.ekEventStore = EKEventStore()
        calendarLoader = CalendarLoader()
        dataSource = MainCalendarModel()
        dataSource!.delegate = self
        dataSource?.initData(date: Date())
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
        
        fsCalendar.register(MainCalendarCell.self, forCellReuseIdentifier: "MainCalednarCell")
        
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
//        let storyboard = UIStoryboard(name: "EventCollectionTableViewController", bundle: nil)
//        guard let controller = storyboard.instantiateViewController(identifier: "EventCollectionTableViewController") as UINavigationController? else { return }
        let controller = EventCollectionTableViewController.storyboardInstance()
        self.present(controller!, animated: true, completion: nil)
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
        AD?.selectedDateEvents =  dataArray[self.calendar.component(.year, from: date) - MainCalendarModel.startYear][self.calendar.component(.month, from: date)-1][self.calendar.component(.day, from: date)-1].events
        self.present(controller, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let customCell = cell as? MainCalendarCell else {
            return
        }
        
        customCell.configureCell(with: dataArray[self.calendar.component(.year, from: date) - MainCalendarModel.startYear][self.calendar.component(.month, from: date)-1][self.calendar.component(.day, from: date)-1])
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: "MainCalednarCell", for: date, at: position) as? MainCalendarCell else {
            return calendar.dequeueReusableCell(withIdentifier: "MainCalednarCell", for: date, at: position)
        }

        return cell
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        let isSameMon: Bool = date.isSameAs(as: .month, from: calendar.currentPage)
//        if !isSameMon {
//            return nil
//        }
//        if getWeekDay(for: date) == "Sunday" {
//            return .red
//        }
//        if getWeekDay(for: date) == "Saturday" {
//            return .blue
//        }
//        return nil
//    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // 특정 연도가 되면 리로드
    }

    
    func configureCell(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
    }
}

extension ViewController: MainCalendarModelDelegate {
    func didLoadData(data: [[[MainCalendarCellItem]]]) {
        dataArray = data
    }
}
