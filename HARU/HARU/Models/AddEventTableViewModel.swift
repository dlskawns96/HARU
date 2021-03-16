//
//  AddEventTableViewModel.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/15.
//

import Foundation
import EventKit

class AddEventTableViewModel {
    static var newEvent = EKEvent(eventStore: EventHandler.ekEventStore!)
    weak var delegate: AddEventTableViewModelDelegate?
    let cellTitleStrings = ["타이틀", "캘린더", "시작", "종료", "반복"]
    
    func initData(newEvent: EKEvent) {
        var dataArray = [AddEventTableViewItem]()
        
        for title in cellTitleStrings {
            let item = AddEventTableViewItem(titleLabelString: title)
            dataArray.append(item)
        }
        
        delegate?.didLoadData(data: dataArray)
    }
    
    func selectCalendar(newCalendar: EKCalendar) {
        AddEventTableViewModel.newEvent.calendar = newCalendar
        delegate?.didElementChanged()
    }
    
    func saveNewEvent() {
        let calendars = EventHandler.ekEventStore!.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == AddEventTableViewModel.newEvent.calendar.title {
                
                do {
                    try EventHandler.ekEventStore!.save(AddEventTableViewModel.newEvent, span: .thisEvent)
                } catch {
                    print("Error saving event in calendar")
                    return
                }
                print("Event saved!")
                NotificationCenter.default.post(name: MainCalendarModel.mainCalendarAddEventNoti, object: nil, userInfo: ["event": AddEventTableViewModel.newEvent])
                return
            }
        }
    }
}

protocol AddEventTableViewModelDelegate: class {
    func didLoadData(data: [AddEventTableViewItem])
    func didElementChanged()
}
