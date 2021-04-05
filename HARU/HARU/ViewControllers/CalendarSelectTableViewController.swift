//
//  CalendarSelectTableViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/30.
//

import UIKit
import EventKit

class CalendarSelectTableViewController: UITableViewController {
    let calendarLoader = CalendarLoader()
    var calendars = [EKCalendar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendars = calendarLoader.loadCalendars()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarSelectCell", for: indexPath) as! CalendarSelectCell
        
        cell.calendar = calendars[indexPath.row]
        cell.configureCell()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EventDetailViewController.event.calendar = calendars[indexPath.row]
        do {
            EventDetailViewController.delegate?.eventChanged(event: EventDetailViewController.event)
            try EventHandler.ekEventStore?.save(EventDetailViewController.event, span: .thisEvent)
        } catch {
            
        }
        
        tableView.reloadData()
    }
}
