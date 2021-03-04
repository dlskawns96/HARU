//
//  DiaryCollectionTableViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/01.
//

import UIKit

class DiaryCollectionTableViewController: UITableViewController {
    
    @IBOutlet weak var lastMonthBtn: UIBarButtonItem!
    @IBOutlet weak var nextMonthBtn: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    var list = [Diary]()
    
    var currentYear = Date()
    var dateFormatter = DateFormatter()
    var Rtoken: NSObjectProtocol?
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    deinit {
        if let token = Rtoken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    @IBAction func lastMonthBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.month, offset: -1)
        
        dateFormatter.dateFormat = "MM월"
        lastMonthBtn.title = "< " + dateFormatter.string(from: currentYear.adjust(.month, offset: -1))
        nextMonthBtn.title = dateFormatter.string(from: currentYear.adjust(.month, offset: 1)) + " >"
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleLabel.title = dateFormatter.string(from: currentYear)
        
        tableView.reloadData()
        
    }
    @IBAction func nextMonthBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.month, offset: 1)
        
        dateFormatter.dateFormat = "MM월"
        lastMonthBtn.title = "< " + dateFormatter.string(from: currentYear.adjust(.month, offset: -1))
        nextMonthBtn.title = dateFormatter.string(from: currentYear.adjust(.month, offset: 1)) + " >"
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleLabel.title = dateFormatter.string(from: currentYear)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dateFormatter.dateFormat = "yyyy-MM"
//        let count = CoreDataManager.returnDiaryCount(date: dateFormatter.string(from: currentYear), type: "Month")
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath)
        dateFormatter.dateFormat = "yyyy-MM"
        
        list =  CoreDataManager.returnDiary(date: dateFormatter.string(from: currentYear), type: 1)
        list = list.sorted(by: {$0.date! < $1.date!})
        
        //let target = list[indexPath.row]
        
        let target = list[indexPath.section]
        
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = target.date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
        self.present(controller, animated: true, completion: nil)
        
        AddDiaryController.editTarget = list[indexPath.section].content
        AddDiaryController.selectedDate = list[indexPath.section].date
        AddDiaryController.check = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        dateFormatter.dateFormat = "yyyy-MM"
        let count = CoreDataManager.returnDiaryCount(date: dateFormatter.string(from: currentYear), type: "Month")
        
        return count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataManager.shared.fetchDiary()
        tableView.reloadData()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleLabel.title = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "MM월"
        lastMonthBtn.title = "< " + dateFormatter.string(from: Date().adjust(.month, offset: -1))
        nextMonthBtn.title = dateFormatter.string(from: Date().adjust(.month, offset: 1)) + " >"
        
        Rtoken = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) {_ in
            self.tableView.reloadData()
        }
        
        
    }
}
