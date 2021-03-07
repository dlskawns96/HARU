//
//  EventDetailTableViewModel.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/06.
//

import Foundation
import EventKit

class EventDetailTableViewModel {
    weak var delegate: EventDetailTableViewModelDelegate?
    
    func requestData(of event: EKEvent) {
        var dataArray = [Any]()
        
        var detailCell = EventDetailTableViewItem()
        detailCell.event = event
        
        let calendarBtnCell = ButtonTableViewItem(event: event, isCalendar: true, isAlarmOn: false, buttonTitleString: "캘린더")
        let alarmBtnCell = ButtonTableViewItem(event: event, isCalendar: false, isAlarmOn: event.hasAlarms, buttonTitleString: "알림")
        
        dataArray.append(detailCell)
        dataArray.append(calendarBtnCell)
        dataArray.append(alarmBtnCell)
        
        delegate?.didLoadData(data: dataArray)
    }
}

protocol EventDetailTableViewModelDelegate: class {
    func didLoadData(data: [Any])
}
