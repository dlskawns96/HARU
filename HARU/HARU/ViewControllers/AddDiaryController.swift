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
    
    //static var selectedDate: String = ""
    
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
        
//        if let editDiary = editTarget, editDiary.count > 0 {
//
//        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let AD = UIApplication.shared.delegate as? AppDelegate
        CoreDataManager.shared.addDiary(diary, AD?.selectedDate)
        NotificationCenter.default.post(name: AddDiaryController.newDiary, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddDiaryController {
    static let newDiary = Notification.Name(rawValue: "newDiary")
}
