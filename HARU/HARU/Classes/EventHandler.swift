//
//  EventHandler.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/05.
//

import Foundation
import EventKit

class EventHandler {
    static var ekEventStore: EKEventStore?
    var event: EKEvent? = nil
    
    init() {
        event = EKEvent(eventStore: EventHandler.ekEventStore!)
    }
    
    func removeEvent(event: EKEvent) -> Bool {
        do {
            print("Event to remove", event)
            let ev = EventHandler.ekEventStore?.event(withIdentifier: event.eventIdentifier)
            try EventHandler.ekEventStore!.remove(ev!, span: .thisEvent, commit: true)
            print("event removed")
            return true
        } catch {
            print("error removing event")
            return false
        }
    }
}
