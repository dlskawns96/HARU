//
//  EventCollectionTableViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/21.
//

import UIKit
import EventKit

class EventCollectionTableViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var lastYearBtn: UIBarButtonItem!
    @IBOutlet weak var nextYearBtn: UIBarButtonItem!
    
    
    var eventsOfYear = [[EKEvent]]()
    var events: [EKEvent] = []
    var calendarLoader = CalendarLoader()
    var currentYear = Date()
    
    var dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        titleLabel.title = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "yyyy년"
        lastYearBtn.title = "< " + dateFormatter.string(from: Date().adjust(.year, offset: -1))
        nextYearBtn.title = dateFormatter.string(from: Date().adjust(.year, offset: 1)) + " >"
        
        eventsOfYear = calendarLoader.loadEvents(ofYear: Date())
        
        collectionView.decelerationRate = .normal
        collectionView.isPagingEnabled = true
        
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: false)
    }
    
    @IBAction func lastYearBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.year, offset: -1)
        eventsOfYear = calendarLoader.loadEvents(ofYear: currentYear)
        titleLabel.title = dateFormatter.string(from: currentYear) + " 1월"
        lastYearBtn.title = "< " + dateFormatter.string(from: currentYear.adjust(.year, offset: -1))
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
        collectionView.reloadData()
    }
    
    @IBAction func nextYearBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.year, offset: 1)
        eventsOfYear = calendarLoader.loadEvents(ofYear: currentYear)
        titleLabel.title = dateFormatter.string(from: currentYear) + " 1월"
        nextYearBtn.title = dateFormatter.string(from: currentYear.adjust(.year, offset: 1)) + " >"
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
        collectionView.reloadData()
    }
}

// MARK: - Collection view extension
extension EventCollectionTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsOfYear.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionCell", for: indexPath) as? EventCollectionCell else {
            return UICollectionViewCell()
        }
            
        events = eventsOfYear[indexPath.item]
        let tableView = UITableView()
        
        let nibName = UINib(nibName: "EventCollectionTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "EventCollectionTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        cell.addSubview(tableView)
        tableView.removeExtraLine()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        tableView.backgroundColor = .orange
        cell.backgroundColor = .brown
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt   section: Int) -> CGFloat {
        return 0
    }

   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt  section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            dateFormatter.dateFormat = "yyyy년"
            titleLabel.title = dateFormatter.string(from: currentYear) + String(indexPath!.item + 1) + "월"
        }
    }
}

// MARK: - Table view extension
extension EventCollectionTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCollectionTableViewCell", for: indexPath) as! EventCollectionTableViewCell
        
        let event = events[indexPath.row]
        cell.eventDayLabel.text = String(Calendar.current.component(.day, from: event.startDate))
        cell.eventMonthLabel.text = String(Calendar.current.component(.month, from: event.startDate)) + "월"
        cell.eventTitleLabel.text = event.title
        cell.calendarColorView.layer.borderColor = event.calendar.cgColor
        cell.calendarColorView.backgroundColor = UIColor(cgColor: event.calendar.cgColor).withAlphaComponent(0.5)
        
        return cell
    }
}

class EventCollectionCell: UICollectionViewCell {
    
}
