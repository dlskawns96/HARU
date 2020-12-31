//
//  AddScheduleController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit
import EventKit

class AddScheduleController : UIViewController {
  
    var savedEventId : String = ""
    var hTitle : String = "Test"
    var hDate : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
       
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate as Date
        event.endDate = endDate as Date
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
            print(savedEventId)
        } catch {
            print("no authorized")
        }
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        
        let eventStore = EKEventStore()
        
        let startDate = NSDate()
        let endDate = startDate.addingTimeInterval(60 * 60)
        
        createEvent(eventStore: eventStore, title: hTitle, startDate: startDate, endDate: endDate)

        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancleBtn(_ sender: Any) {
            
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // 일정 등록 화면
    
    // 일정 등록에서 값을 받아와 저장, 캘린더 연동에 필요한 변수들 할당
}
