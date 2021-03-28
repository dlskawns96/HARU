//
//  DiaryCollectionTableViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/01.
//

import UIKit

class DiaryCollectionTableViewController: UIViewController {

    @IBOutlet weak var lastMonthBtn: UIBarButtonItem!
    @IBOutlet weak var nextMonthBtn: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var list = [Diary]()
    
    var currentYear = Date()
    var dateFormatter = DateFormatter()
    var Rtoken: NSObjectProtocol?
    
    let AD = UIApplication.shared.delegate as? AppDelegate
    let dataSource = DiaryTableViewModel()
    var dataArray = [Diary]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func lastMonthBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.month, offset: -1)
        
        dateFormatter.dateFormat = "MM월"
        lastMonthBtn.title = "< " + dateFormatter.string(from: currentYear.adjust(.month, offset: -1))
        nextMonthBtn.title = dateFormatter.string(from: currentYear.adjust(.month, offset: 1)) + " >"
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleLabel.title = dateFormatter.string(from: currentYear)
        
        dateFormatter.dateFormat = "yyyy-MM"
        dataSource.requestDiaryCollection(date: dateFormatter.string(from: currentYear))
        
    }
    @IBAction func nextMonthBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.month, offset: 1)
        
        dateFormatter.dateFormat = "MM월"
        lastMonthBtn.title = "< " + dateFormatter.string(from: currentYear.adjust(.month, offset: -1))
        nextMonthBtn.title = dateFormatter.string(from: currentYear.adjust(.month, offset: 1)) + " >"
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleLabel.title = dateFormatter.string(from: currentYear)
        
        dateFormatter.dateFormat = "yyyy-MM"
        dataSource.requestDiaryCollection(date: dateFormatter.string(from: currentYear))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoreDataManager.shared.fetchDiary()
        
        dateFormatter.dateFormat = "yyyy-MM"
        dataSource.requestDiaryCollection(date: dateFormatter.string(from: currentYear))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        let nibName = UINib(nibName: "DiaryCollectionTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "diaryCollectionViewCell")
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleLabel.title = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "MM월"
        lastMonthBtn.title = "< " + dateFormatter.string(from: Date().adjust(.month, offset: -1))
        nextMonthBtn.title = dateFormatter.string(from: Date().adjust(.month, offset: 1)) + " >"
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = ThemeVariables.mainUIColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        Rtoken = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) {_ in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if let Rtoken = Rtoken {
            NotificationCenter.default.removeObserver(Rtoken)
        }
    }
}
extension DiaryCollectionTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCollectionViewCell", for: indexPath) as! DiaryCollectionTableViewCell
        
        let target = dataArray[indexPath.section]
        cell.myLabel.text = target.content
        
        let date = target.date
        let startIdx: String.Index = date!.index(date!.startIndex, offsetBy: 8)
        
        cell.dateLabel.text = String(date![startIdx...])
        cell.selectionStyle = .none
        cell.myLabel.sizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let today = NSDate()
        let selectedDate = dataArray[indexPath.section].date
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let todayString = dateFormatter.string(from: today as Date)

        if selectedDate! >= todayString {
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
            self.present(controller, animated: true, completion: nil)

            AddDiaryController.editTarget = dataArray[indexPath.section].content
            AddDiaryController.selectedDate = dataArray[indexPath.section].date
            AddDiaryController.check = true
        }

    }
//
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
}

extension DiaryCollectionTableViewController: DiaryTableViewModelDelegate {
    func didLoadData(data: [Diary]) {
        dataArray = data
    }
}
