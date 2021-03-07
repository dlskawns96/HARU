//
//  EventDetailViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/25.
//

import UIKit
import EventKit

class EventDetailViewController: UIViewController {
    
    var eventStore = EventHandler.ekEventStore
    var event: EKEvent!
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    static let eventChangedNoti = Notification.Name(rawValue: "eventChangedNoti")
    var token: NSObjectProtocol?
    
    var dataArray = [Any]() {
        didSet {
            tableView.reloadData()
        }
    }
    let dataSource = EventDetailTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE a HH시 mm분"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraLine()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.getNewEventInfo(_:)), name: EventDetailViewController.eventChangedNoti, object: nil)
        
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.requestData(of: event)
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EventModifyViewControllerEntry") as? UINavigationController else { return }
        
        guard let vc = controller.viewControllers.first as? EventModifyViewController else { return }
//        vc.event = (event.copy() as! EKEvent)
        vc.event = event
        vc.originalCalendar = event.calendar
        
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
//    @objc
//    func getNewEventInfo(_ notification: NSNotification) {
//        if let newEvent = notification.userInfo?["EKEvent"] as? EKEvent {
//            event = newEvent
//            tableView.reloadData()
//        }
//    }
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailTableViewCell") as? EventDetailTableViewCell else { return UITableViewCell() }
            
            cell.configureCell(with: dataArray[indexPath.row] as! EventDetailTableViewItem)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as? ButtonTableViewCell else {
                return UITableViewCell() }
            
            cell.configureCell(with: dataArray[indexPath.row] as! ButtonTableViewItem)
            return cell
        }
    }
}

extension EventDetailViewController: EventDetailTableViewModelDelegate {
    func didLoadData(data: [Any]) {
        dataArray = data
    }
}
