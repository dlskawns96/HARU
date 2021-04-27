//
//  EventAlarmSelectTableViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/06.
//

import UIKit
import EventKit
import AFDateHelper

class EventAlarmSelectTableViewController: UITableViewController {
    var isModifying = false
    static let items = [["없음"], ["이벤트 당시", "5분 전", "10분 전", "15분 전", "30분 전", "1시간 전", "2시간 전", "1일 전", "2일 전", "1주 전"]]
    
    
    var event: EKEvent!
    let alarmTime = [Time(type: DateComponentType.minute, offset: 0),
                     Time(type: DateComponentType.minute, offset: -5),
                     Time(type: DateComponentType.minute, offset: -10),
                     Time(type: DateComponentType.minute, offset: -15),
                     Time(type: DateComponentType.minute, offset: -30),
                     Time(type: DateComponentType.hour, offset: -1),
                     Time(type: DateComponentType.hour, offset: -2),
                     Time(type: DateComponentType.day, offset: -1),
                     Time(type: DateComponentType.day, offset: -2),
                     Time(type: DateComponentType.day, offset: -7)]
    
    static var selectedIndex = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isModifying {
            event = AddEventTableViewModel.newEvent
        } else {
            event = EventDetailViewController.event
        }
        guard let index = event.getAlarmIndex() else {
            EventAlarmSelectTableViewController.selectedIndex = IndexPath(row: 0, section: 0)
            return
        }
        EventAlarmSelectTableViewController.selectedIndex = index
    }
    
    func removeExistingAlarm() {
        if event.hasAlarms {
            let alarm = (event.alarms?.first)!
            event.removeAlarm(alarm)
        }
        if isModifying {
            do {
                try EventHandler.ekEventStore.save(event, span: .thisEvent)
            } catch {
                print("Event Alarm Modifying Error")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EventAlarmSelectTableViewController.selectedIndex = indexPath
        var alarm = EKAlarm()
        switch indexPath.section {
        case 0:
            removeExistingAlarm()
        case 1:
            alarm = EKAlarm(absoluteDate: event.startDate.adjust(alarmTime[indexPath.row].type, offset: alarmTime[indexPath.row].offset))
            removeExistingAlarm()
            event.addAlarm(alarm)
            if isModifying {
                do {
                    try EventHandler.ekEventStore.save(event, span: .thisEvent)
                } catch {
                    print("Event Alarm Modifying Error")
                }
            }
        default:
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventAlarmSelectTableViewCell", for: indexPath) as! EventAlarmSelectTableViewCell
        cell.titleLabel.text = EventAlarmSelectTableViewController.items[indexPath.section][indexPath.row]
        if indexPath == EventAlarmSelectTableViewController.selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

class EventAlarmSelectTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
    }
    
    func configureCell() {
    }

}
