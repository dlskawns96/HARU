//
//  AddDiaryController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/01.
//

import UIKit

class AddDiaryController : UIViewController {
    
    var record:Diary?
    var originalDiary: String?
    static var check = false
    static var editTarget: String?
    static var selectedDate : String?
    
    @IBOutlet weak var diaryTextView: UITextView!
    let dataSource = DiaryTableViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let editDiary = AddDiaryController.editTarget, editDiary.count >= 1 && editDiary != " " {
            navigationItem.title = "일기 수정"
            diaryTextView.text = editDiary
            originalDiary = editDiary
        }
        else {
            navigationItem.title = "새 일기"
            diaryTextView.text = ""
        }
        
        diaryTextView.delegate = self
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = ThemeVariables.mainUIColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.presentationController?.delegate = nil
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
        
        if let editDiary = AddDiaryController.editTarget, editDiary.count >= 1 {
            if AddDiaryController.check {
                CoreDataManager.shared.updateDiary(diary, AddDiaryController.selectedDate)
                NotificationCenter.default.post(name: AddDiaryController.newDiary, object: nil)
                NotificationCenter.default.post(name: AddDiaryController.refreshDiaryCollection, object: nil)
            }
            else {
                CoreDataManager.shared.updateDiary(diary, AD?.selectedDate)
                NotificationCenter.default.post(name: AddDiaryController.newDiary, object: nil)
            }
        }
        else {
            dataSource.saveDiary(content: diary, date: (AD?.selectedDate)!)
            NotificationCenter.default.post(name: AddDiaryController.newDiary, object: nil)
        }

        NotificationCenter.default.post(name: AddDiaryController.updateComment, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddDiaryController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 다이어리 수정할 떄
        if let original = originalDiary, let edited = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            }
            else {
                
            }
        }
        // 새로운 다이어리 추가할 때
        if let diary = textView.text {
            if #available(iOS 13.0, *) {
                isModalInPresentation = diary.count > 0 && diary != " "
            }
        }
    }
}

extension AddDiaryController: UIAdaptivePresentationControllerDelegate {
    // 일기를 수정한 뒤, 모달 뷰를 풀다운으로 내렸을때 실행됨
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title:
                                        "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
       
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.saveBtn(action)
        }
        alert.addAction(okAction)
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.cancleBtn(action)
        }
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
extension AddDiaryController {
    static let newDiary = Notification.Name(rawValue: "newDiary")
    static let updateComment = Notification.Name(rawValue: "updateComment")
    static let refreshDiaryCollection = Notification.Name(rawValue: "refreshDiaryCollection")
}
