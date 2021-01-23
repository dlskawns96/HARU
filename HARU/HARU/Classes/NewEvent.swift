//
//  NewEvent.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/01/21.
//

import Foundation
import UIKit

class NewEvent {
    var eventTitle: String?
    
    /// 제목, 색깔
    var calendar: (title: String, color: UIColor)!
    var startDate: Date!
    var endDate: Date!
    
    /// 매주 or 매일 / 며칠마다 / 횟수
    var repeating: (eveyWeek: Bool, cycle: Int, time: Int)!
    
    init() {
        self.eventTitle = nil
        self.calendar = nil
        self.startDate = nil
        self.endDate = nil
        self.repeating = nil
    }
    
    init(eventTitle: String, calendar: (title: String, color: UIColor), startDate: Date, endDate: Date, repeating: (eveyWeek: Bool, cycle: Int, time: Int)) {
        self.eventTitle = eventTitle
        self.calendar = calendar 
        self.startDate = startDate
        self.endDate = endDate
        self.repeating = repeating
    }
}
