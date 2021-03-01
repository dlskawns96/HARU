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
    
    var currentYear = Date()
    var dateFormatter = DateFormatter()
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    @IBAction func lastMonthBtnClicked(_ sender: Any) {
        
    }
    @IBAction func nextMonthBtnClicked(_ sender: Any) {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateFormatter.dateFormat = "yyyy-MM"
        let count = CoreDataManager.returnDiaryCount(date: dateFormatter.string(from: currentYear), type: "Month")
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath)
        dateFormatter.dateFormat = "yyyy-MM"
        
        var list =  CoreDataManager.returnDiary(date: dateFormatter.string(from: currentYear), type: 1)
        list = list.sorted(by: {$0.date! < $1.date!})
        
        let target = list[indexPath.row]
        
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = target.date
        
        return cell
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
    }
}
