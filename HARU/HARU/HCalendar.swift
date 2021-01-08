//
//  HCalendar.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/09.
//

import Foundation

class HCalendar {
    
    var title : String
    var startDate : String
    var endDate : String
    var identifier : String
    
    init(title : String, startDate : String, endDate : String, indentifier : String){
    
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.identifier = indentifier
        
    }
    
    static var calendarList = [
        
        HCalendar(title: "title", startDate: "test", endDate: "test", indentifier: "test")
    ]
}
