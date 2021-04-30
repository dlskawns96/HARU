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
    
    // 달력에서 평가 리턴
    static func requestEvaluation(selectedDate: Date) -> Int{
        var evaluation: Int = 0

        for item in CoreDataManager.diaryList {
            if selectedDate.compare(.isSameDay(as: item.date2!)) {
                evaluation = Int(item.evaluation)
            }
        }
        return evaluation
    }

    func requestEvaluation(date: String) -> [Float]{
        
        var list = [Diary]()
        var evaluation_array: [Float] = [0,0,0]
        var bad: Int = 0
        var good: Int = 0
        var best: Int = 0
        
        for item in CoreDataManager.diaryList {
            let endIdx:String.Index = (item.date?.index(item.date!.startIndex, offsetBy: 6))!
            if item.date![item.date!.startIndex...endIdx] == date {
                list.append(item)
            }
        }
        
        // 1 😱 2 😀 3 🥰
        for item in list {
            if item.evaluation == 1 {
                bad += 1
            }
            else if item.evaluation == 2 {
                good += 1
            }
            else if item.evaluation == 3 {
                best += 1
            }
        }
        
        if bad+good+best != 0 {
            evaluation_array[0] = Float(Double(bad)/Double((bad+good+best)))
            evaluation_array[1] = Float(Double(good)/Double((bad+good+best)))
            evaluation_array[2] = Float(Double(best)/Double((bad+good+best)))
        }
        
        return evaluation_array
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
    
    func savePictureDiary() {
        
    }

}

protocol DiaryTableViewModelDelegate: class {
    func didLoadData(data: [Diary])
}
