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
    let calendarLoader = CalendarLoader()
    
    let dataSource = ScheduleTableViewModel()
    var dataArray = [ScheduleTableViewItem]() {
        didSet {
            ScheduleTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(true)
        dataSource.requestData(of: self.selectedDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScheduleTableView.delegate = self
        ScheduleTableView.dataSource = self
        ScheduleTableView.removeExtraLine()
        dataSource.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onEventAddedNotification(notification:)), name:MainCalendarModel.mainCalendarAddEventNoti, object: nil)
    }
    
    @objc func onEventAddedNotification(notification:Notification) {
        dataSource.requestData(of: self.selectedDate)
    }
    
    func swipeDelete(indexPath: IndexPath) {
        print("ScheduleViewController - swipeDelete() called")
        dataSource.removeData(event: dataArray[indexPath.row].event, date: self.selectedDate)
    }
    
    func swipeModify(event: EKEvent) {
        guard let controller = self.storyboard!.instantiateViewController(identifier: "EventModifyViewControllerEntry") as UINavigationController? else { return }
        let vc = controller.viewControllers.first as? EventModifyViewController
        if vc != nil {
            vc?.event = event.copy() as! EKEvent
            vc?.originalCalendar = event.calendar
        } else { return }
        controller.modalPresentationStyle = .pageSheet
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: - TableView
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let naviController = EventDetailViewController.storyboardInstance()
        EventDetailViewController.event = dataArray[indexPath.row].event
        self.present(naviController!, animated: true, completion: nil)
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
            self.swipeModify(event: self.dateEvents[indexPath.row])
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
