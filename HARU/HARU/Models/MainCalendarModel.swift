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
    static let mainCalendarEventModifiedNoti = Notification.Name("mainCalendarEventModifiedNoti")
    
    func initData(date: Date) {
        let group = DispatchGroup()
        group.enter()
        
        var dataArray = [[[MainCalendarCellItem]]]()
        
        DispatchQueue.main.async { [self] in
            var currentYear = date.adjust(.year, offset: -1)
            var currentMonth = currentYear
            MainCalendarModel.startYear = self.calendar.component(.year, from: currentYear)
            
            for _ in 0...1 {
                currentMonth = currentYear.adjust(hour: 0, minute: 0, second: 0, day: 1, month: 1)
                dataArray.append(makeMonthItems(month: currentMonth))
                currentYear = currentYear.adjust(.year, offset: 1)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.delegate?.didLoadData(data: dataArray)
        }
    }
    
    func loadNewerData(date: Date) {
        // date 이후 년도로 1년치 더 불러오기
        var dataArray = [[[MainCalendarCellItem]]]()
        let newYear = date.adjust(.year, offset: 1)
        let currentMonth = newYear.adjust(hour: 0, minute: 0, second: 0, day: 1, month: 1)
    
        dataArray.append(makeMonthItems(month: currentMonth))
        delegate?.newerItemAdded(datas: dataArray)
    }
    
    func loadOlderData(date: Date) {
        // date 이후 년도로 1년치 더 불러오기
        var dataArray = [[[MainCalendarCellItem]]]()
        let newYear = date.adjust(.year, offset: -1)
        let currentMonth = newYear.adjust(hour: 0, minute: 0, second: 0, day: 1, month: 1)
        
        MainCalendarModel.startYear = self.calendar.component(.year, from: newYear)
        dataArray.append(makeMonthItems(month: currentMonth))
        delegate?.olderItemAdded(datas: dataArray)
    }
    
    func makeMonthItems(month: Date) -> [[MainCalendarCellItem]] {
        var dataArray = [[MainCalendarCellItem]]()
        var daysInMonth = [Date]()
        var monthlyEvents = [[EKEvent]]()
        var currentMonth = month
        for idx in 0...11 {
            dataArray.append([])
            daysInMonth = currentMonth.datesOfMonth
            monthlyEvents = self.calendarLoader.loadEvents(ofMonth: currentMonth)
            for day in 0..<daysInMonth.count {
                let item = MainCalendarCellItem(events: monthlyEvents[day], date: daysInMonth[day])
                dataArray[idx].append(item)
            }
            currentMonth = currentMonth.adjust(.month, offset: 1)
        }
        return dataArray
    }
    
    func eventAdded(event: EKEvent, items: [MainCalendarCellItem]) {
        // 이벤트의 시작날짜부터 종료날짜 까지 모든 아이템들을 불러오고, 수정해서 리턴
        var newItems = items
        var curIdx = 0
        for item in newItems {
            for j in 0...3 {
                if item.eventsToIndicate[j] == nil {
                    if j > curIdx {
                        curIdx = j
                    }
                    break
                }
            }
        }
        event.calendarIndex = curIdx
        for idx in 0..<newItems.count {
            newItems[idx].events?.append(event)
            if curIdx <= 3 {
                newItems[idx].eventsToIndicate[curIdx] = event
            }
        }
        delegate?.itemChanged(datas: newItems, startDate: event.startDate, endDate: event.endDate)
    }
    
    func eventRemoved(startDate: Date, endDate: Date) {
        var dataArray = [MainCalendarCellItem]()
        let difference = abs(startDate.difference(between: endDate))
        let newEvents = calendarLoader.loadEvents(ofDay: startDate, for: difference)
        
        for i in 0...difference {
            let item = MainCalendarCellItem(events: newEvents[i], date: startDate.adjust(.day, offset: i))
            dataArray.append(item)
        }
        
        delegate?.itemChanged(datas: dataArray, startDate: startDate, endDate: endDate)
    }
    
    func eventModified(event: EKEvent) {
        var dataArray = [MainCalendarCellItem]()
        let difference = abs(event.startDate.difference(between: event.endDate))
        let newEvents = calendarLoader.loadEvents(ofDay: event.startDate, for: difference)
        
        for i in 0...difference {
            let item = MainCalendarCellItem(events: newEvents[i], date: event.startDate.adjust(.day, offset: i))
            dataArray.append(item)
        }
        
        delegate?.itemChanged(datas: dataArray, startDate: event.startDate, endDate: event.endDate)
    }
}

protocol MainCalendarModelDelegate: class {
    func didLoadData(data: [[[MainCalendarCellItem]]])
    func itemChanged(datas: [MainCalendarCellItem], startDate: Date, endDate: Date)
    func newerItemAdded(datas: [[[MainCalendarCellItem]]])
    func olderItemAdded(datas: [[[MainCalendarCellItem]]])
}
