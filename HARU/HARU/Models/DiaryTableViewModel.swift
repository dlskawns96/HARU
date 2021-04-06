//
//  DiaryTableViewModel.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/06.
//

import Foundation

class DiaryTableViewModel {
    weak var delegate: DiaryTableViewModelDelegate?
    
    func requestDiary(date: String) {
        var data = [Diary]()
        var diaries = [Diary]()
        CoreDataManager.shared.fetchDiary()
        
        diaries = CoreDataManager.returnDiaries(date: date)
        
        for diary in diaries {
            if diary.date == date {
                data.append(diary)
            }
        }
        
        delegate?.didLoadData(data: data)

    }
    
    func requestDiaryCollection(date: String) {
        var diaries = [Diary]()
        diaries = CoreDataManager.returnDiaryCollection(date: date)
        diaries = diaries.sorted(by: {$0.date! < $1.date!})
        delegate?.didLoadData(data: diaries)
    }
    
    func saveDiary(content: String, date: String) {
        CoreDataManager.shared.saveDiary(content, date)
        self.requestDiary(date: date)
    }
    
    func updateDiary(content: String, date: String) {
        CoreDataManager.shared.updateDiary(content, date)
        self.requestDiary(date: date)
    }
    
    func deleteDiary(diary: Diary, date: String) {
        CoreDataManager.shared.deleteDiary(diary)
        self.requestDiary(date: date)
    }
    
    func deleteAllDiaries() {
        var diaries = [Diary]()
        diaries = CoreDataManager.returnAllDiaries()
        
        for diary in diaries {
            CoreDataManager.shared.deleteDiary(diary)
        }
        CoreDataManager.shared.fetchDiary()
        SettingViewController.deleteCheck = true
        
    }

}

protocol DiaryTableViewModelDelegate: class {
    func didLoadData(data: [Diary])
}
