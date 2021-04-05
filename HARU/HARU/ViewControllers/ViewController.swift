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
    @IBOutlet weak var eventsCollectionBtn: UIButton!
    @IBOutlet weak var diaryCollectionBtn: UIButton!
    
    var eventStartDates: [NSDate] = []
    var eventEndDates: [NSDate] = []
    var eventTitles: [String] = []
    var loadedEvents: [EKEvent] = []
    var labels: [UILabel] = []
    var calendarLoader: CalendarLoader!
    
    var token: NSObjectProtocol?
    var selectedDate = Date()
    
    let calendar = Calendar.current
    
    var dataSource: MainCalendarModel?
    var dataArray = [[[MainCalendarCellItem]]]() {
        didSet {
            fsCalendar.reloadData()
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
        NotificationCenter.default.addObserver(self, selector: #selector(onEventAddedNotification(notification:)), name:MainCalendarModel.mainCalendarAddEventNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEventRemovedNotification(notification:)), name:EventHandler.eventRemovedNoti, object: nil)
    
        fsCalendar.layer.cornerRadius = ThemeVariables.buttonCornerRadius
        fsCalendar.layer.shadowPath = UIBezierPath(roundedRect: fsCalendar.bounds, cornerRadius: 10).cgPath
        fsCalendar.layer.shouldRasterize = true
        fsCalendar.layer.rasterizationScale = UIScreen.main.scale
        
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
        
        for weekday in fsCalendar.calendarWeekdayView.weekdayLabels {
            if weekday.text == "일" {
                weekday.textColor = .red
            } else if weekday.text == "토" {
                weekday.textColor = .blue
            } else {
                weekday.textColor = .black
            }
        }
        
        fsCalendar.register(MainCalendarCell.self, forCellReuseIdentifier: "MainCalednarCell")
        
        EventDetailViewController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    // MARK: - Button Actions
    @IBAction func onAddEventBtnClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewEventViewController", sender: nil)
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
    
    @objc func onEventAddedNotification(notification: Notification) {
        let event = notification.userInfo!["event"] as! EKEvent
        let items = getItemsOfDate(startDate: event.startDate, endDate: event.endDate)
        dataSource?.eventAdded(event: event, items: items)
    }
    
    @objc func onEventRemovedNotification(notification: Notification) {
        let startDate = notification.userInfo!["startDate"] as! Date
        let endDate = notification.userInfo!["endDate"] as! Date
        dataSource?.eventRemoved(startDate: startDate, endDate: endDate)
    }
    
    func getItemsOfDate(startDate: Date, endDate: Date) -> [MainCalendarCellItem] {
        var items = [MainCalendarCellItem]()
        for i in 0...abs(startDate.difference(between: endDate)) {
            let curDate = startDate.adjust(.day, offset: i)
            items.append(dataArray[self.calendar.component(.year, from: curDate) - MainCalendarModel.startYear][self.calendar.component(.month, from: curDate)-1][self.calendar.component(.day, from: curDate)-1])
        }
        return items
    }
    
    func setItemsOfDate(startDate: Date, endDate: Date, newItems: [MainCalendarCellItem]) {
        for i in 0...abs(startDate.difference(between: endDate)) {
            let curDate = startDate.adjust(.day, offset: i)
            dataArray[self.calendar.component(.year, from: curDate) - MainCalendarModel.startYear][self.calendar.component(.month, from: curDate)-1][self.calendar.component(.day, from: curDate)-1] = newItems[i]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSelectDateView" {
            guard let controller = segue.destination as? SelectDateController else { return }
            controller.selectedDate = self.selectedDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let AD = UIApplication.shared.delegate as? AppDelegate
            AD?.selectedDate = dateFormatter.string(from: self.selectedDate)
            AD?.selectedDateEvents =  dataArray[self.calendar.component(.year, from: selectedDate) - MainCalendarModel.startYear][self.calendar.component(.month, from: selectedDate)-1][self.calendar.component(.day, from: selectedDate)-1].events
        } else if segue.identifier == "AddNewEventViewController" {
            guard let controller = segue.destination as? AddNewEventViewController else {
                return
            }
            controller.selectedDate = Date()
        }
    }
}

// MARK: - Extensions
extension ViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    // Implement protocols
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        self.performSegue(withIdentifier: "ShowSelectDateView", sender: nil)
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
    
    
    func configureCell(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
    }
}

extension ViewController: MainCalendarModelDelegate {
    func didLoadData(data: [[[MainCalendarCellItem]]]) {
        dataArray = data
    }
    
    func itemChanged(datas: [MainCalendarCellItem], startDate: Date, endDate: Date) {
        setItemsOfDate(startDate: startDate, endDate: endDate, newItems: datas)
    }
}

extension ViewController: EventDetailViewDelegate {
    func eventChanged(event: EKEvent) {
        dataSource?.eventRemoved(startDate: event.startDate, endDate: event.endDate)
    }
}
