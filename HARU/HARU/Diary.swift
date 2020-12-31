//
//  Diary.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/01.
//

import Foundation

class Diary {
    
    var content : String
    var date : String
    
    init(content: String, date: String) {
        
        self.content = content
        self.date = date
    }
    
    static var diaryList = [
        
        Diary(content: "Today is good", date: "2021-01-02")
    ]

}
