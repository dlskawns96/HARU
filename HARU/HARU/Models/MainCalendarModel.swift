//
//  MainCalendarModel.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/08.
//

import Foundation
import EventKit

class MainCalendarModel {
    weak var delegate: MainCalendarModelDelegate?
    let calendarLoader = CalendarLoader()
    let calendar = Calendar.current
    var fiveMonth = [Date]()
    var dataArray = [MainCalendarCellItem]()
    
    func initData(of month: Date) {
        fiveMonth = [month.adjust(.month, offset: -2), month.adjust(.month, offset: -1), month, month.adjust(.month, offset: 1), month.adjust(.month, offset: 2)]
        
        for currentMonth in fiveMonth {
            for date in currentMonth.datesOfMonth {
                let item = MainCalendarCellItem(events: calendarLoader.loadEvents(ofDay: date), date: date)
                dataArray.append(item)
            }
        }
        delegate?.didLoadData(data: dataArray)
    }
    
    func requestData(isNextMonth: Bool) {
        if isNextMonth {
            for _ in 0..<fiveMonth[0].numOfDays(In: fiveMonth[0]) {
                dataArray.remove(at: 0)
            }
            fiveMonth.remove(at: 0)
            
            let nextMonth = fiveMonth.last?.adjust(.month, offset: 1)
            fiveMonth.append(nextMonth!)
            for date in nextMonth!.datesOfMonth {
                let item = MainCalendarCellItem(events: calendarLoader.loadEvents(ofDay: date), date: date)
                dataArray.append(item)
            }
        } else {
            for _ in 0..<fiveMonth.last!.numOfDays(In: fiveMonth.last!) {
                dataArray.popLast()
            }
            fiveMonth.popLast()
            
            let lastMonth = fiveMonth.first?.adjust(.month, offset: -1)
            fiveMonth.insert(lastMonth!, at: 0)
            var idx = 0
            for date in lastMonth!.datesOfMonth {
                let item = MainCalendarCellItem(events: calendarLoader.loadEvents(ofDay: date), date: date)
                dataArray.insert(item, at: idx)
                idx += 1
            }
        }
        
        delegate?.didLoadData(data: dataArray)
    }
    
    
    func getItem(data: [MainCalendarCellItem], at date: Date, currentPage: Date) -> MainCalendarCellItem {
        return data.filter({(item: MainCalendarCellItem) -> Bool in
            if item.date!.compare(.isSameDay(as: date)) {
                return true }
            return false
        }).first!
    }
}

protocol MainCalendarModelDelegate: class {
    func didLoadData(data: [MainCalendarCellItem])
}
