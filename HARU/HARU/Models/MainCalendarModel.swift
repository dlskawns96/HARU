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
        var dataArray = [[[MainCalendarCellItem]]]()
        
        // nil 없이 Date까지 다 저장하기
        // 10년 전으로 가서 10년 후가 될 때까지 반복
        var currentYear = date.adjust(.year, offset: -3)
        var currentMonth = currentYear
        var daysInMonth = [Date]()
        var monthlyEvents = [[EKEvent]]()
        
        MainCalendarModel.startYear = self.calendar.component(.year, from: currentYear)
        
        for year in 0...6 {
            print("Load events... CurrentYear:", currentYear.toString(dateFormat: "yyyy-MM-dd"))
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
        delegate?.eventAdded(datas: newItems, startDate: event.startDate, endDate: event.endDate)
    }
}

protocol MainCalendarModelDelegate: class {
    func didLoadData(data: [[[MainCalendarCellItem]]])
    func eventAdded(datas: [MainCalendarCellItem], startDate: Date, endDate: Date)
}
