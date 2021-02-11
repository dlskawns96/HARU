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
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.fetchDiary()
        tableView.reloadData()
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
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
        }
    }
    // 평가
    
    
    @IBAction func badBtn(_ sender: Any) {
        badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
        goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
    }
    
    @IBAction func goodBtn(_ sender: Any) {
        badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
        bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    @IBAction func bestBtn(_ sender: Any) {
        badBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        goodBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        bestBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 45)
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
            
            let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (action) in
                print("삭제")
                let indexPath = self?.tableView.indexPathForRow(at: touchPoint)
                let target = CoreDataManager.diaryList[indexPath!.row]
                CoreDataManager.shared.deleteDiary(target)
                CoreDataManager.diaryList.remove(at: indexPath!.row)
                self?.tableView.reloadData()
            
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
        
        token = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) {_ in
            print("new diary")
            self.tableView.reloadData()
        }
    }
}
