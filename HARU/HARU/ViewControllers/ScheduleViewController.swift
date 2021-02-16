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
    var selectedDate = Date()
    
    let eventHandler = EventHandler()
    
    var token: NSObjectProtocol?
    let calendarLoader = CalendarLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScheduleTableView.delegate = self
        ScheduleTableView.dataSource = self
        ScheduleTableView.removeExtraLine()
        guard let controller = self.storyboard?.instantiateViewController(identifier: "SelectDateController") as? SelectDateController else { return }
        
        token = NotificationCenter.default.addObserver(forName: AddEventViewController.eventChangedNoti, object: nil,
                queue: OperationQueue.main) {_ in
            self.dateEvents = self.calendarLoader.loadEvents(ofDay: self.selectedDate)
            self.ScheduleTableView.reloadData()
            print(self.dateEvents)
                    print("reload")
                }
    }
    
    deinit {
            if let token = token {
                NotificationCenter.default.removeObserver(token)
            }
        }
    
    func swipeDelete(indexPath: IndexPath) {
        print("ScheduleViewController - swipeDelete() called")
        if eventHandler.removeEvent(event: dateEvents[indexPath.row]) {
            self.dateEvents.remove(at: indexPath.row)
            self.ScheduleTableView.deleteRows(at: [indexPath], with: .automatic)
            NotificationCenter.default.post(name: AddEventViewController.eventChangedNoti, object: nil)
        }
    }
    
    func swipeModify(event: EKEvent) {
        eventHandler.modifyEvent(event: event)
        guard let controller = self.storyboard!.instantiateViewController(identifier: "EventModifyViewControllerEntry") as UINavigationController? else { return }
        let vc = controller.viewControllers.first as? EventModifyViewController
        if vc != nil { vc?.event = event }
        controller.modalPresentationStyle = .pageSheet
        self.present(controller, animated: true, completion: nil)
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
            self.swipeModify(event: self.dateEvents[indexPath.row])
            completionHandler(true)
        })
        action.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension UITableView {
    func removeExtraLine() {
        tableFooterView = UIView(frame: .zero)
    }
}
