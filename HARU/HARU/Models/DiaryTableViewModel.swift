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
        var data = String()
        var count = Int()
        data = CoreDataManager.returnDiary(date: date)
        
        if data != " " {
            count = 1
        }
        else {
            count = 0
        }
            
        delegate?.didLoadData(data: data)
        delegate?.didLoadDataCount(data: count)
    }
    func saveDiary(content: String, date: String) {
        CoreDataManager.shared.saveDiary(content, date)
        //CoreDataManager.shared.fetchDiary()
        self.requestDiary(date: date)
    }
}

protocol DiaryTableViewModelDelegate: class {
    func didLoadData(data: String)
    func didLoadDataCount(data: Int)
}

