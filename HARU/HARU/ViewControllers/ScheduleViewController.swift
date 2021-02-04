//
//  ScheduleViewController.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/01/22.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ScheduleTableView: UITableView!
    var dateEvents: [NewEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScheduleTableView.delegate = self
        ScheduleTableView.dataSource = self
        ScheduleTableView.removeExtraLine()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ScheduleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        
        let idx = indexPath.row
        cell.eventTitleLabel.text = dateEvents[idx].eventTitle
        cell.layer.borderWidth = 2
        let eventColor = dateEvents[idx].calendar.color
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
}

extension UITableView {
    func removeExtraLine() {
        tableFooterView = UIView(frame: .zero)
    }
}
