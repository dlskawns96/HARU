//
//  ScheduleTableViewModel.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/04.
//

import Foundation
import EventKit

class ScheduleTableViewModel {
    weak var delegate: ScheduleTableViewModelDelegate?
    let calendarLoader = CalendarLoader()
    let eventHandler = EventHandler()
    
    func requestData(of date: Date) {
        var data = [ScheduleTableViewItem]()
        let dateEvents = self.calendarLoader.loadEvents(ofDay: date)
        
        for event in dateEvents {
            let scheduleTableViewItem = ScheduleTableViewItem(event: event)
            data.append(scheduleTableViewItem)
        }
        delegate?.didLoadData(data: data)
    }
    
    func removeData(event: EKEvent, date: Date) {
        if eventHandler.removeEvent(event: event) {
            self.requestData(of: date)
        }
    }
}

protocol ScheduleTableViewModelDelegate: class {
    func didLoadData(data: [ScheduleTableViewItem])
}
