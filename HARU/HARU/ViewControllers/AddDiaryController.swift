//
//  AddDiaryController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/01.
//

import UIKit

class AddDiaryController : UIViewController {
    
    var editTarget: String?
    @IBOutlet weak var diaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let editDiary = editTarget, editDiary.count > 0 {
            navigationItem.title = "일기 수정"
            diaryTextView.text = editDiary
        }
        else {
            navigationItem.title = "새 일기"
            diaryTextView.text = ""
        }
    }
    
    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        guard let diary = diaryTextView.text, diary.count > 0 else {
            alert(message: "내용을 입력하세요.")
            return
        }
        
        let AD = UIApplication.shared.delegate as? AppDelegate
        
        if let editDiary = editTarget, editDiary.count > 0 {
            
            CoreDataManager.shared.updateDiary(diary, AD?.selectedDate)
            NotificationCenter.default.post(name: AddDiaryController.newDiary, object: nil)
        }
        else {
            CoreDataManager.shared.saveDiary(diary, AD?.selectedDate)
            NotificationCenter.default.post(name: AddDiaryController.newDiary, object: nil)
        }

        dismiss(animated: true, completion: nil)
    }
    
}

extension AddDiaryController {
    static let newDiary = Notification.Name(rawValue: "newDiary")
}
