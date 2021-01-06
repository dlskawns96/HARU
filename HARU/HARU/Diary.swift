//
//  Diary.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/01.
//

import Foundation

class Diary {
    
    var content : String
    var date : Date
    
    init(content: String, date: Date) {
        
        self.content = content
        self.date = date
    }
    
    static var diaryList = [
        
        Diary(content: "Today is good", date: Date()),
        Diary(content: "Today is bad", date: Date())

    ]

}
