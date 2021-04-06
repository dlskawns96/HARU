//
//  ScheduleViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/22.
//

import UIKit
import EventKit

class ScheduleViewController: UIViewController {

    @IBOutlet weak var ScheduleTableView: UITableView!
    @IBOutlet var centerLabel: UILabel!
    
    var dateEvents: [EKEvent] = []
    var selectedDate = Date()
    
    let eventHandler = EventHandler()
    let calendarLoader = CalendarLoader()
    
    let dataSource = ScheduleTableViewModel()
    
    let emptyComments = ["일정이 없습니다!", "스케줄이 비어 있어요.", "계획이 없는 하루에요."]
    
    var dataArray = [ScheduleTableViewItem]() {
        didSet {
            ScheduleTableView.reloadData()
        }
    }
    
    var selectedEvent: EKEvent?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.requestData(of: self.selectedDate)
        if dataArray.isEmpty {
            centerLabel.text = emptyComments.randomElement()
        } else {
            centerLabel.text = ""
        }
        ScheduleTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerLabel.text = ""
        ScheduleTableView.delegate = self
        ScheduleTableView.dataSource = self
        ScheduleTableView.removeExtraLine()
        selectedEvent = nil
        dataSource.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventModify" {
            guard let vc = segue.destination as? AddNewEventViewController else {
                return
            }
            vc.isModifying = true
            vc.originalEvent = selectedEvent
        }
    }
    
    func swipeDelete(indexPath: IndexPath) {
        print("ScheduleViewController - swipeDelete() called")
        dataSource.removeData(event: dataArray[indexPath.row].event, date: self.selectedDate)
    }
    
    func swipeModify(event: EKEvent) {
        selectedEvent = event
        self.performSegue(withIdentifier: "EventModify", sender: nil)
    }
}

// MARK: - TableView
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EventDetailViewController.event = dataArray[indexPath.row].event
        self.performSegue(withIdentifier: "ShowDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScheduleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        
        cell.configureCell(with: dataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // leading swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "삭제", handler: {(action, view, completionHandler) in
            self.swipeDelete(indexPath: indexPath)
            completionHandler(true)
        })
        action.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // trailing swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "수정", handler: {(action, view, completionHandler) in
            self.swipeModify(event: self.dataArray[indexPath.row].event)
            completionHandler(true)
        })
        action.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension ScheduleViewController: ScheduleTableViewModelDelegate {
    func didLoadData(data: [ScheduleTableViewItem]) {
        dataArray = data
    }
}
