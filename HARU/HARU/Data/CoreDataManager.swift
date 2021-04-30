//
//  CoreDataManager.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/17.
//

import Foundation
import CoreData

class CoreDataManager {
    
    
    static let shared = CoreDataManager()
    
    private init() {
        
    }
    
    static var diaryList = [Diary]()
    
    func fetchDiary() {
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        
        do {
            CoreDataManager.diaryList = try mainContext.fetch(request)
        } catch  {
            print(error)
        }
        
    }
    
    // 다이어리 저장
    func saveDiary(_ content: String?, _ date: String?) {
        var date_ver_Date = Date()
        let dateFormatter = DateFormatter()
        let newDiary = Diary(context: mainContext)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date_ver_Date = dateFormatter.date(from: date!)!
        
        newDiary.content = content
        newDiary.date = date
        newDiary.date2 = date_ver_Date
        
        CoreDataManager.diaryList.insert(newDiary, at: 0)
        saveContext()
    }
    
    // 다이어리 업데이트
    func updateDiary(_ content: String?, _ date: String?) {
        
        for item in CoreDataManager.diaryList {
            if item.date == date {
                item.content = content
            }
        }
        
        saveContext()
    }
    
    // 다이어리 삭제
    func deleteDiary(_ diary: Diary?) {
        if let diary = diary {
            mainContext.delete(diary)
            saveContext()
        }
    }
    
    static func returnAllDiaries() -> [Diary] {
        return diaryList
    }
    
    // 모든 다이어리 리스트 리턴
    static func returnDiaries(date:String) -> [Diary] {
        return diaryList
    }
    
    // 특정 날짜의 다이어리 하나 리턴
    static func returnDiary(date:String) -> String {

        var list:String = ""

        for item in CoreDataManager.diaryList {
            if item.date == date {
                list = item.content!
            }
        }
        return list
    }
    
    // 다이어리 모음 특정 년도, 달 다이어리 리스트 리턴
    static func returnDiaryCollection(date:String) -> [Diary] {
        
        var list = [Diary]()
        
        for item in CoreDataManager.diaryList {
            let endIdx:String.Index = (item.date?.index(item.date!.startIndex, offsetBy: 6))!
            if item.date![item.date!.startIndex...endIdx] == date {
                if item.content != " " {
                    list.append(item)
                }
            }
        }
        
        return list
        
    }

    func saveEvaluation(_ evaluation: Int16?, _ date: String?) {

        var date_ver_Date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date_ver_Date = dateFormatter.date(from: date!)!
        
        var yes: Bool = true
        // 다이어리를 이미 작성했을 때 평가 부분만 추가
        for item in CoreDataManager.diaryList {
            if item.date == date {
                item.evaluation = evaluation!
                item.date2 = date_ver_Date
                yes = false
                break
            }
        }

        // 다이어리 없이 평가만 했을 때 
        if yes {
            let newDiary = Diary(context: mainContext)
            newDiary.evaluation = evaluation!
            newDiary.date = date
            newDiary.date2 = date_ver_Date
            newDiary.content = " "

            CoreDataManager.diaryList.insert(newDiary, at: 0)
        }
        
        saveContext()
    }

//    func returnImageURL(path: String) -> Diary{
//        var diary: Diary
//
//        for item in CoreDataManager.diaryList {
//            if item.
//        }
//    }
    
    func saveImageURL(path: String) {
        
        var check: Bool = true
        
        var date_ver_Date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date_ver_Date = dateFormatter.date(from: path)!

        // 다이어리 이미 있을때
        for item in CoreDataManager.diaryList {
            if item.date == path {
                item.imagePath = path
                check = false
                break
            }
        }
        
        // 다이어리 없을 때
        if check {
            let newDiary = Diary(context: mainContext)
            newDiary.date = path
            newDiary.date2 = date_ver_Date
            newDiary.imagePath = path
            newDiary.content = " "
            newDiary.evaluation = 0
        
            CoreDataManager.diaryList.insert(newDiary, at: 0)
        }
        
        saveContext()
    }

    static func returnDiaryEvaluation(date:String) -> Int {
        
        var evaluation: Int = 0
        
        for item in CoreDataManager.diaryList {
            if item.date == date {
                evaluation = Int(item.evaluation)
            }
        }
        return evaluation
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Data")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

