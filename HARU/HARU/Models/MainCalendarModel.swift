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
    var dataArray = [[MainCalendarCellItem]]()
    
    func initData(of month: Date) {
        fiveMonth = [month.adjust(.month, offset: -2), month.adjust(.month, offset: -1), month, month.adjust(.month, offset: 1), month.adjust(.month, offset: 2)]
        
        var idx = 0
        for currentMonth in fiveMonth {
            for date in currentMonth.datesOfMonth {
                dataArray.append([])
                let item = MainCalendarCellItem(events: calendarLoader.loadEvents(ofDay: date), date: date)
                dataArray[idx].append(item)
            }
            idx += 1
        }
        delegate?.didLoadData(data: dataArray)
    }
    
    func requestData(isNextMonth: Bool) {
        if isNextMonth {
            dataArray.remove(at: 0)
            fiveMonth.remove(at: 0)
            
            let nextMonth = fiveMonth.last?.adjust(.month, offset: 1)
            fiveMonth.append(nextMonth!)
            dataArray.append([])
            for date in nextMonth!.datesOfMonth {
                let item = MainCalendarCellItem(events: calendarLoader.loadEvents(ofDay: date), date: date)
                dataArray[4].append(item)
            }
        } else {
            dataArray.popLast()
            fiveMonth.popLast()
            
            let lastMonth = fiveMonth.first?.adjust(.month, offset: -1)
            fiveMonth.insert(lastMonth!, at: 0)
            dataArray.insert([], at: 0)
            for date in lastMonth!.datesOfMonth {
                let item = MainCalendarCellItem(events: calendarLoader.loadEvents(ofDay: date), date: date)
                dataArray[0].append(item)
            }
        }
        
        delegate?.didLoadData(data: dataArray)
    }
    
    func getItem(data: [[MainCalendarCellItem]], at date: Date, currentPage: Date) -> MainCalendarCellItem {
        let calendar = Calendar.current
        for month in fiveMonth {
            if date.compare(.isSameMonth(as: month)) {
                return data[fiveMonth.firstIndex(of: month)!][calendar.component(.day, from: date) - 1]
            }
        }
        return data[0][0]
    }
}

protocol MainCalendarModelDelegate: class {
    func didLoadData(data: [[MainCalendarCellItem]])
}
