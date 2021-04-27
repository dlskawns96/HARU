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
    
    var selectedDate = Date()
    
    let calendar = Calendar.current
    
    var calendarAuth = EKEventStore.authorizationStatus(for: .event)
    
    var dataSource: MainCalendarModel?
    var dataArray = [[[MainCalendarCellItem]]]() {
        didSet {
            fsCalendar.reloadData()
        }
    }
    
    var state = UIApplication.shared.applicationState {
        didSet {
            print("@@@@")
            if state == .active {
                
                fsCalendar.reloadData()
            }
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if calendarAuth == .authorized {
            loadEventData()
        } else {
            authorizationCheck()
        }
        
        self.initFSCalendar()
        self.registerObservers()
        EventDetailViewController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = false
        fsCalendar.deselect(selectedDate)
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "나눔손글씨 다행체", size: 27)!]
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Button Actions
    @IBAction func onAddEventBtnClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "AddNewEventViewController", sender: nil)
    }
    
    @IBAction func onEventCollectionBtnClicked(_ sender: Any) {
        let controller = EventCollectionTableViewController.storyboardInstance()
        self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func DiaryCollectionBtnClicked(_ sender: Any) {
//        guard let controller = storyboard?.instantiateViewController(identifier: "DiaryCollectionTableViewController") as UINavigationController? else { return }
//        self.present(controller, animated: true, completion: nil)
        let controller = DiaryCollectionTableViewController.storyboardInstance()
        self.present(controller!, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    private func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
    }
    
    private func initFSCalendar() {
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.layer.cornerRadius = ThemeVariables.buttonCornerRadius
        fsCalendar.layer.shouldRasterize = true
        fsCalendar.layer.rasterizationScale = UIScreen.main.scale
        
        fsCalendar.locale = Locale(identifier: "ko_KR")
        fsCalendar.headerHeight = 50
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        fsCalendar.appearance.headerDateFormat = "YYYY년 M월"
        fsCalendar.appearance.headerTitleColor = .black
        fsCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 18)
        fsCalendar.appearance.borderRadius = 0
        fsCalendar.weekdayHeight = 40
        fsCalendar.today = nil
        for weekday in fsCalendar.calendarWeekdayView.weekdayLabels {
            weekday.borderWidth = 1.0
            weekday.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            if weekday.text == "일" {
                weekday.textColor = .red
            } else if weekday.text == "토" {
                weekday.textColor = .blue
            } else {
                weekday.textColor = .black
            }
        }
        fsCalendar.scrollDirection = .vertical
        fsCalendar.register(MainCalendarCell.self, forCellReuseIdentifier: "MainCalednarCell")
    }
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onEventAddedNotification(notification:)), name:MainCalendarModel.mainCalendarAddEventNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEventRemovedNotification(notification:)), name:EventHandler.eventRemovedNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEventModifiedNotification(notification:)), name:MainCalendarModel.mainCalendarEventModifiedNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onWillEnterForegroundNotification(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func loadEventData() {
        EventHandler.ekCalendars = EventHandler.ekEventStore.calendars(for: .event).filter({(cal: EKCalendar) -> Bool in
            return cal.allowsContentModifications
        })
        calendarLoader = CalendarLoader()
        dataSource = MainCalendarModel()
        dataSource?.delegate = self
        dataSource?.initData(date: Date())
    }
    
    private func authorizationCheck() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            self.calendarAuth = .authorized
        case .denied:
            print("Access denied")
        case .notDetermined:
            EventHandler.ekEventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                if granted {
                    self.calendarAuth = .authorized
                    self.loadEventData()
                } else {
                    self.calendarAuth = .denied
                    print("Access denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    // MARK: - Notification Handlers
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
    
    @objc func onEventModifiedNotification(notification: Notification) {
        let event = notification.userInfo!["event"] as! EKEvent
        dataSource?.eventModified(event: event)
    }
    
    @objc func onWillEnterForegroundNotification(notification: Notification) {
//        fsCalendar.reloadData()
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
        customCell.cellDate = date
        if !dataArray.isEmpty {
            customCell.configureCell(with: dataArray[self.calendar.component(.year, from: date) - MainCalendarModel.startYear][self.calendar.component(.month, from: date)-1][self.calendar.component(.day, from: date)-1])
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: "MainCalednarCell", for: date, at: position) as? MainCalendarCell else {
            return calendar.dequeueReusableCell(withIdentifier: "MainCalednarCell", for: date, at: position)
        }
//        cell.cellDate = date
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
