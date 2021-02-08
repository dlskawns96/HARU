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
    var dateEvents: [EKEvent] = []
    let eventHandler = EventHandler()
    var scheduleVCDelegate: ScheduleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScheduleTableView.delegate = self
        ScheduleTableView.dataSource = self
        ScheduleTableView.removeExtraLine()
        guard let controller = self.storyboard?.instantiateViewController(identifier: "SelectDateController") as? SelectDateController else { return }
        controller.delegate = self
    }
    
    func swipeDelete(indexPath: IndexPath) {
        print("ScheduleViewController - swipeDelete() called")
        if eventHandler.removeEvent(event: dateEvents[indexPath.row]) {
            self.scheduleVCDelegate?.eventModified()
            self.dateEvents.remove(at: indexPath.row)
            self.ScheduleTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func swipeModify() {
        print("ScheduleViewController - swipeModify() called")
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScheduleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        
        let idx = indexPath.row
        cell.eventTitleLabel.text = dateEvents[idx].title
        cell.layer.borderWidth = 2
        let eventColor = UIColor(cgColor: dateEvents[idx].calendar.cgColor)
        cell.layer.borderColor = eventColor.cgColor
        cell.backgroundColor = eventColor.withAlphaComponent(0.25)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
            self.swipeModify()
            completionHandler(true)
        })
        action.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension ScheduleViewController: SelectDateControllerDelegate {
    func SelectDateControllerDidCancel(_ selectDateController: SelectDateController) {
        
    }
    
    func SelectDateControllerDidFinish(_ selectDateController: SelectDateController) {
        
    }
    
    func insertNewEventToTable(events: [EKEvent]) {
        print(events)
        dateEvents = events
        ScheduleTableView.reloadData()
    }
}

extension UITableView {
    func removeExtraLine() {
        tableFooterView = UIView(frame: .zero)
    }
}

protocol ScheduleViewControllerDelegate {
    func eventModified()
}
