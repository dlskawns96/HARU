//
//  Calendar.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/31.
//

import Foundation

class Calendar {
    
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
        
        Calendar(title: "title", startDate: "test", endDate: "test", indentifier: "test")
    ]
}
