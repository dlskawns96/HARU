//
//  EventHandler.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/05.
//

import Foundation
import EventKit

class EventHandler {
    let ekEventStore = EKEventStore()
    
    func removeEvent(event: EKEvent) -> Bool {
        do {
            print("Event to remove", event)
            let ev = ekEventStore.event(withIdentifier: event.eventIdentifier)
            try self.ekEventStore.remove(ev!, span: .thisEvent, commit: true)
            print("event removed")
            return true
        } catch {
            print("error removing event")
            return false
        }
    }
    
    func modifyEvent(event: EKEvent) {
        
    }
}
