//
//  EventDetailViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/25.
//

import UIKit
import EventKit

class EventDetailViewController: UITableViewController {
    static var event = EKEvent(eventStore: EventHandler.ekEventStore!)
    var dateFormatter = DateFormatter()
    
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "EventDetailViewController",
                                      bundle: nil)
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE a HH시 mm분"
        tableView.removeExtraLine()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    @IBAction func onCancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditBtnClicked(_ sender: Any) {
    }
}

extension EventDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailTableViewCell", for: indexPath) as! EventDetailTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarButtonTableViewCell", for: indexPath) as! CalendarButtonTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as! AlertTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.performSegue(withIdentifier: "EditCalendar", sender: self)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "EditAlert", sender: self)
        }
    }
}
