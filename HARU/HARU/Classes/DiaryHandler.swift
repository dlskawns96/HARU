//
//  DiaryHandler.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/05.
//

import Foundation

class DiaryHandler {
    weak var delegate: DiaryHandlerDelegate?
    //var diary: Diary? = nil
    
//    func requestDiary(date: String) {
//        var data = [Diary]()
//        let dateDiaries = CoreDataManager.returnDiary(date: date)
//
//        for diary in dateDiaries {
//            let diaryTableViewItem = ScheduleTableViewItem(event: event)
//            data.append(scheduleTableViewItem)
//        }
//        delegate?.didLoadData(data: data)
//    }
    
    func saveDiary(content: String, date: String) {
        CoreDataManager.shared.saveDiary(content, date)
    }
    
    func removeDiary(diary: Diary) {
        CoreDataManager.shared.deleteDiary(diary)
    }
    
    func updateDiary(content: String, date: String) {
        CoreDataManager.shared.updateDiary(content, date)
    }
}

protocol DiaryHandlerDelegate: class {
    func didLoadData(data: [Diary])
}
