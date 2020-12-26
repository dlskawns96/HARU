//
//  CalendarLoader.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import Foundation
import EventKit

class CalendarLoader {
    
    struct EVENT {
        var startDate: NSDate
        var endDate: NSDate
        var title: String
        var calendarName: String
        var color: String
    }
    
    var titles : [String] = []
    var startDates : [NSDate] = []
    var endDates : [NSDate] = []
    
    let eventStore = EKEventStore()
    let calendars : [EKCalendar]
    
    init() {
        var auth: Bool = false
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
                auth = true
        case .denied:
                print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                    if granted {
                        auth = true

                    }else{
                        print("Access denied")
                    }
                })
            default:
                print("Case Default")
            }
        
        calendars = eventStore.calendars(for: .event)
        if auth {
            getEvents()
        }
    }
    
    func getEvents() {
        for calendar in calendars {
            let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)

            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])

            let events = eventStore.events(matching: predicate)

            for event in events {
                print(event)
                print(event.calendar.title)
                titles.append(event.title)
                startDates.append(event.startDate as NSDate)
                endDates.append(event.endDate as NSDate)
            }
        }
    }
}
