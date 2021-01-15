//
//  SelectDateController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2020/12/26.
//

import UIKit

class SelectDateController : UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
   
    //var paramDate : String = ""
    var count: Int = HCalendar.calendarList.count
    var token: NSObjectProtocol?
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.date.text = paramDate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        token = NotificationCenter.default.addObserver(forName: AddDiaryController.newDiary, object: nil, queue: OperationQueue.main) {_ in
            self.reloadTableView()
            print("reload")
        }
        
    }
   
    func reloadTableView(){
        
        switch segment.selectedSegmentIndex
        {
        case 0:
            count = HCalendar.calendarList.count
            tableView.reloadData()
        case 1:
            count = Diary.diaryList.count
            tableView.reloadData()
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
   
        //let target = Diary.diaryList[indexPath.row]
        //cell.textLabel?.text = target.content
        
        switch segment.selectedSegmentIndex
        {
        case 0:
            let target = HCalendar.calendarList[indexPath.row]
            cell.textLabel?.text = target.title
        case 1:
            let target = Diary.diaryList[indexPath.row]
            cell.textLabel?.text = target.content
        default:
            break
        }
        
        return cell
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        reloadTableView()
    }
    
    
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addBtn(_ sender: Any) {

        switch segment.selectedSegmentIndex
        {
        case 0:
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddEventViewController") else { return }
            controller.modalPresentationStyle = .pageSheet
            self.present(controller, animated: true, completion: nil)
        case 1:
            guard let controller = self.storyboard?.instantiateViewController(identifier: "AddDiaryController") else { return }
            
            self.present(controller, animated: true, completion: nil)
        default:
            break
        }

    }
    
    
    // 해당 날짜의 전체 일정 보여주기
    
    // 특정 일정 눌렀을 때 그 일정에 대한 세부 정보 표시
    
    // 특정 일정 눌렀을 때 삭제 버튼 추가
    
    // 삭제 버튼 누르면 기본 캘린더에서도 삭제 되게
    
    // 상단부는 일정 표시, 아래는 일기
    
}
