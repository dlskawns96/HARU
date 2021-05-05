//
//  EventDetailViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/25.
//

import UIKit
import EventKit
import MapKit

class EventDetailViewController: UITableViewController {
    static var event = EKEvent(eventStore: EventHandler.ekEventStore)
    var dateFormatter = DateFormatter()
    static var delegate: EventDetailViewDelegate?
    
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "EventDetailViewController",
                                      bundle: nil)
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE a HH시 mm분"
        self.navigationController?.navigationBar.tintColor = .white
        tableView.removeExtraLine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventModify" {
            guard let vc = segue.destination as? AddNewEventViewController else {
                return
            }
            vc.originalEvent = EventDetailViewController.event
            vc.isModifying = true
        } else if segue.identifier == "EditAlert" {
            guard let vc = segue.destination as? EventAlarmSelectTableViewController else {
                return
            }
            vc.isModifying = true
        } else if segue.identifier == "LocationSet" {
            guard let vc = segue.destination as? LocationViewController else {
                return
            }
            vc.delegate = self
        }
    }
    
    @IBAction func onEditBtnClicked(_ sender: Any) {
    }
    
}

extension EventDetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if EventDetailViewController.event.structuredLocation != nil {
//            return 4
//        }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 3 {
//            return 200
//        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailTableViewCell", for: indexPath) as! EventDetailTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarButtonTableViewCell", for: indexPath) as! CalendarButtonTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as! AlertTableViewCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.performSegue(withIdentifier: "EditCalendar", sender: self)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "EditAlert", sender: self)
        } else if indexPath.row == 3 {
            self.performSegue(withIdentifier: "LocationSet", sender: self)
        }
    }
}

extension EventDetailViewController: LocationViewControllerDelegate {
    func searchFinished(mapItem: MKMapItem, name: String) {
        let structuredLocation = EKStructuredLocation(mapItem: mapItem)
        structuredLocation.geoLocation = mapItem.placemark.location
        structuredLocation.title = name
        EventDetailViewController.event.structuredLocation = structuredLocation
        
        do {
            try EventHandler.ekEventStore.save(EventDetailViewController.event, span: .thisEvent)
        } catch {
            print("Event Location Modifying error")
        }
        EventDetailViewController.delegate?.eventChanged(event: EventDetailViewController.event)
        tableView.reloadData()
        print("Event Location Modified")
    }
}

protocol EventDetailViewDelegate {
    func eventChanged(event: EKEvent)
}
