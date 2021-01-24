//
//  DiaryViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/22.
//

import UIKit

class DiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var token: NSObjectProtocol?
    let AD = UIApplication.shared.delegate as? AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.fetchDiary()
        //        textView.text = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
        tableView.reloadData()
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        textView.text = CoreDataManager.returnDiary(date: (AD?.selectedDate)!)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        token = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) {_ in
            print("new diary")
            self.tableView.reloadData()
        }
    }
}
