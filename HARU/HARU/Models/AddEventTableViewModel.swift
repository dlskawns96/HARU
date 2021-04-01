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
    
    func initData(selectedDate: Date, calendar: EKCalendar) {
        let newEvent = EKEvent(eventStore: EventHandler.ekEventStore!)
        
        newEvent.title = "새로운 이벤트"
        newEvent.startDate = selectedDate
        newEvent.endDate = selectedDate
        newEvent.calendar = calendar
        AddEventTableViewModel.newEvent = newEvent
        
        let section1: [AddEventCellItem] = [TextFieldItem(title: "타이틀")]
        let section2: [AddEventCellItem] = [CalendarItem(title: "캘린더"), TextItem(isStartDate: true, title: "시작"), TextItem(isStartDate: false, title: "종료")]
        let section3: [AddEventCellItem] = [EventNoteItem(title: "노트")]
        let items: [[AddEventCellItem]] = [section1, section2, section3]
        
        delegate?.didLoadData(items: items)
    }
    
    func addCalendarEditItem(title: String) {
        let item: AddEventCellItem = CalendarEditItem(title: title)
        delegate?.calenadrEditItemAdded(item: item)
    }
    
    func selectCalendar(newCalendar: EKCalendar) {
        AddEventTableViewModel.newEvent.calendar = newCalendar
        delegate?.didElementChanged()
    }
    
    func didNewEventChanged() {
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
    func didLoadData(items: [[AddEventCellItem]])
    func calenadrEditItemAdded(item: AddEventCellItem)
    func didElementChanged()
}
