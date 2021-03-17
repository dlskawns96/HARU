//
//  MainCalendarModel.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/08.
//

import Foundation
import EventKit

class MainCalendarModel {
    static var startYear = 0
    weak var delegate: MainCalendarModelDelegate?
    let calendarLoader = CalendarLoader()
    let calendar = Calendar.current
    
    static let mainCalendarAddEventNoti = Notification.Name("mainCalendarAddEventNoti")
    
    func initData(date: Date) {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name:MainCalendarModel.mainCalendarAddEventNoti, object: nil)
        var dataArray = [[[MainCalendarCellItem]]]()
        
        // nil 없이 Date까지 다 저장하기
        // 10년 전으로 가서 10년 후가 될 때까지 반복
        var currentYear = date.adjust(.year, offset: -3)
        var currentMonth = currentYear
        var daysInMonth = [Date]()
        var monthlyEvents = [[EKEvent]]()
        
        MainCalendarModel.startYear = self.calendar.component(.year, from: currentYear)
        
        for year in 0...6 {
            print("CurrentYear:", currentYear.toString(dateFormat: "yyyy-MM-dd"))
            currentMonth = currentYear.adjust(hour: 0, minute: 0, second: 0, day: 1, month: 1)
            dataArray.append([])
            for month in 0...11 {
                dataArray[year].append([])
                daysInMonth = currentMonth.datesOfMonth
                monthlyEvents = calendarLoader.loadEvents(ofMonth: currentMonth)
                for day in 0..<daysInMonth.count {
                    let item = MainCalendarCellItem(events: monthlyEvents[day], date: daysInMonth[day])
                    dataArray[year][month].append(item)
                }
                currentMonth = currentMonth.adjust(.month, offset: 1)
            }
            currentYear = currentYear.adjust(.year, offset: 1)
        }
        delegate?.didLoadData(data: dataArray)
    }
    
    @objc func onNotification(notification:Notification) {
        eventAdded(event: notification.userInfo!["event"] as! EKEvent)
    }
    
    func eventAdded(event: EKEvent) {
        let events = calendarLoader.loadEvents(ofDay: event.startDate)
        let newItem = MainCalendarCellItem(events: events, date: event.startDate)
        delegate?.eventAdded(data: newItem)
    }
    
    
    //    func requestData(isNextMonth: Bool) {
    //        if isNextMonth {
    //            dataArray.remove(at: 0)
    //            fiveMonth.remove(at: 0)
    //
    //            let nextMonth = fiveMonth.last?.adjust(.month, offset: 1)
    //            fiveMonth.append(nextMonth!)
    //            dataArray.append([])
    //            for date in nextMonth!.datesOfMonth {
    //                let item = MainCalendarCellItem(events: calendarLoader.loadEvents(ofDay: date), date: date)
    //                dataArray[4].append(item)
    //            }
    //        } else {
    //            dataArray.popLast()
    //            fiveMonth.popLast()
    //
    //            let lastMonth = fiveMonth.first?.adjust(.month, offset: -1)
    //            fiveMonth.insert(lastMonth!, at: 0)
    //            dataArray.insert([], at: 0)
    //            for date in lastMonth!.datesOfMonth {
    //                let item = MainCalendarCellItem(events: calendarLoader.loadEvents(ofDay: date), date: date)
    //                dataArray[0].append(item)
    //            }
    //        }
    //
    //        delegate?.didLoadData(data: dataArray)
    //    }
}

protocol MainCalendarModelDelegate: class {
    func didLoadData(data: [[[MainCalendarCellItem]]])
    func eventAdded(data: MainCalendarCellItem)
}
