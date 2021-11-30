//
//  EventAlarmSelectTableViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/06.
//

import UIKit
import EventKit

class EventAlarmSelectTableViewController: UITableViewController {
    var items = [["없음"], ["이벤트 당시", "5분 전", "10분 전", "15분 전", "30분 전", "1시간 전", "2시간 전", "1일 전", "2일 전", "1주 전"]]
    
    var isModifying = false
    var currentAlert: String?
    var currentOffset: TimeInterval?
    
    var event: EKEvent!
    var delegate: EventAlarmSelectTableViewControllerDelegate?
    
    var intervals = [TimeInterval(0),
                     TimeInterval(-5 * 60), TimeInterval(-10 * 60), TimeInterval(-15 * 60), TimeInterval(-30 * 60),
                     TimeInterval(-1 * 60 * 60), TimeInterval(-2 * 60 * 60),
                     TimeInterval(-1 * 60 * 60 * 24), TimeInterval(-2 * 60 * 60 * 24), TimeInterval(-7 * 60 * 60 * 24)]
    
    static var selectedIndex = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isModifying {
            event = AddEventTableViewModel.newEvent
        } else {
            event = EventDetailViewController.event
        }
        
        if event.hasAlarms {
            var interval = event.alarms!.first!.relativeOffset
            
            if !intervals.contains(interval) {
                items[1].insert(currentAlert!, at: 0)
                intervals.insert(currentOffset!, at: 0)
                EventAlarmSelectTableViewController.selectedIndex = IndexPath(row: 0, section: 1)
                return
            }
            
            if let date = event.alarms?.first?.absoluteDate {
                interval = date.timeIntervalSince(event.startDate)
            }
            var row = 0
            for idx in 0..<intervals.count {
                if intervals[idx] == interval {
                    row = idx
                    break
                }
            }
            EventAlarmSelectTableViewController.selectedIndex = IndexPath(row: row, section: 1)
        } else {
            EventAlarmSelectTableViewController.selectedIndex = IndexPath(row: 0, section: 0)
        }
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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
            alarm = EKAlarm(relativeOffset: intervals[indexPath.row])
            removeExistingAlarm()
            event.addAlarm(alarm)
            if isModifying {
                do {
                    try EventHandler.ekEventStore.save(event, span: .thisEvent)
                } catch {
                    print("Event Alarm Modifying Error")
                }
            } else {
                delegate?.didSelectAlert(offset: intervals[indexPath.row])
            }
        default:
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventAlarmSelectTableViewCell", for: indexPath) as! EventAlarmSelectTableViewCell
        cell.titleLabel.text = items[indexPath.section][indexPath.row]
        
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

protocol EventAlarmSelectTableViewControllerDelegate {
    func didSelectAlert(offset: TimeInterval)
}
