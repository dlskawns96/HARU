//
//  EventDetailViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/25.
//

import UIKit
import EventKit

class EventDetailViewController: UIViewController {

    var eventStore = EKEventStore()
    var event: EKEvent!
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE a HH시 mm분"
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailTableViewCell") as? EventDetailTableViewCell else { return UITableViewCell() }

            cell.eventTitleLabel.text = event.title
            cell.startDateLabel.text = dateFormatter.string(from: event.startDate)
            cell.endDateLabel.text = "~" + dateFormatter.string(from: event.endDate)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell") as? ButtonTableViewCell else {
                return UITableViewCell() }

            if indexPath.row == 1 {
                cell.buttonTitleLabel.text = "캘린더"
                cell.buttonContentLabel.text = event.calendar.title
                let view = UIView()
                cell.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.trailingAnchor.constraint(equalTo: cell.buttonContentLabel.leadingAnchor, constant: -10).isActive = true
                view.centerYAnchor.constraint(equalTo: cell.buttonContentLabel.centerYAnchor).isActive = true
                view.heightAnchor.constraint(equalToConstant: 10).isActive = true
                view.widthAnchor.constraint(equalToConstant: 10).isActive = true
                view.backgroundColor = UIColor(cgColor: event.calendar.cgColor)
            } else if indexPath.row == 2 {
                cell.buttonTitleLabel.text = "알림"
                cell.buttonContentLabel.text = "없음"
            }
            
            return cell
        }
    }
}
