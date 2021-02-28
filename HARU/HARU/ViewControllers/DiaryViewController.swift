//
//  DiaryViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/22.
//

import UIKit

class DiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var badBtn: UIButton!
    @IBOutlet weak var goodBtn: UIButton!
    @IBOutlet weak var bestBtn: UIButton!
    
    var diary: Diary?
    var token: NSObjectProtocol?
    var Etoken: NSObjectProtocol?
    
    var addCheck = true
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    //var selectedDate = Date()
    let dateFormatter = DateFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataManager.shared.fetchDiary()
        tableView.reloadData()
        
        let evaluation = CoreDataManager.returnDiaryEvaluation(date: (AD?.selectedDate)!)
        
        if evaluation == 1 {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        else if evaluation == 2 {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        else if evaluation == 3 {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
        }
        else {
            buttonInit()
        }
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
        if let Etoken = Etoken {
            NotificationCenter.default.removeObserver(Etoken)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = CoreDataManager.returnDiaryCount(date: (AD?.selectedDate)!)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let target = CoreDataManager.diaryList[indexPath.row]
            CoreDataManager.shared.deleteDiary(target)
            CoreDataManager.diaryList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            buttonInit()
        }
    }
    
    func buttonInit() {
        badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    // 평가
    @IBAction func badBtn(_ sender: Any) {
        if addCheck {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            CoreDataManager.shared.saveEvaluation(1, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    }
    
    @IBAction func goodBtn(_ sender: Any) {
        if addCheck {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            CoreDataManager.shared.saveEvaluation(2, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    
    }
    
    @IBAction func bestBtn(_ sender: Any) {
        if addCheck {
            badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
            
            CoreDataManager.shared.saveEvaluation(3, AD?.selectedDate)
            NotificationCenter.default.post(name: DiaryViewController.newEvaluation, object: nil)
        }
    }
    
    @objc func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        let count = CoreDataManager.returnDiaryCount(date: (AD?.selectedDate)!)
        
        if count != 0 {
            
            var touchPoint = CGPoint()
            
            if gestureRecognizer.state == UIGestureRecognizer.State.began {
                touchPoint = gestureRecognizer.location(in: self.tableView)
            }
            let alert = UIAlertController(title:
                                            "삭제 확인", message: "일기를 삭제할까요?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                print("삭제")
                let indexPath = self.tableView.indexPathForRow(at: touchPoint)
                let target = CoreDataManager.diaryList[indexPath!.row]
                CoreDataManager.shared.deleteDiary(target)
                CoreDataManager.diaryList.remove(at: indexPath!.row)
                self.tableView.reloadData()
                self.buttonInit()
            
            }
            alert.addAction(okAction)
            
            let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancleAction)
            
            present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressGesture))
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        //print(CoreDataManager.returnDiaryEvaluation(date: (AD?.selectedDate)!))

        token = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) {_ in
            //print("new diary")
            self.tableView.reloadData()
        }
        
        Etoken = NotificationCenter.default.addObserver(forName: DiaryViewController.newEvaluation, object: nil, queue: OperationQueue.main) {_ in
            //print("new Evaluation")
            self.tableView.reloadData()
        }

        
        let dateString = AD?.selectedDate
        
        let today = NSDate() //현재 시각 구하기
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let todayString = dateFormatter.string(from: today as Date)
        
        if dateString! >= todayString {
            addCheck = true
        }
        else {
            addCheck = false
        }
        
    }
}

extension DiaryViewController {
    static let newEvaluation = Notification.Name(rawValue: "newEvaluation")
}
