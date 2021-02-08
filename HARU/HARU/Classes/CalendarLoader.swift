//
//  CalendarLoader.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import Foundation
import EventKit
import UIKit

class CalendarLoader {
    
    // To save calendars properties
    var loadedEvents: [EKEvent] = []
    
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
            loadEvents()
        }
    }
    
    func loadEvents() {
        loadedEvents = []
        for calendar in calendars {
            // 이벤트를 가져올 기간
            let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
            let oneMonthAfter = Date(timeIntervalSinceNow: +30*24*3600)

            // 위에서 정한 기간의 이벤트 가져오기
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            
            for event in events {
                loadedEvents.append(event)
            }
        }
    }
    
    func loadCalendars() -> [EKCalendar] {
        return calendars
    }
}
