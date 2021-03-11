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
    
    static func storyboardInstance() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "EventCollectionTableViewController",
                                           bundle: nil)
        return storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
//    var eventsOfYear = [[EKEvent]]()
    var events: [EventCollectionTableViewItem] = []
    var calendarLoader = CalendarLoader()
    var currentYear = Date()
    var currentMonth = 1
    
    var dateFormatter = DateFormatter()
    
    var dataSource = EventCollectionTableViewModel()
    var dataArray = [[EventCollectionTableViewItem]]() {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy년 1월"
        titleLabel.title = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "yyyy년"
        lastYearBtn.title = "< " + dateFormatter.string(from: Date().adjust(.year, offset: -1))
        nextYearBtn.title = dateFormatter.string(from: Date().adjust(.year, offset: 1)) + " >"
        
        collectionView.decelerationRate = .normal
        collectionView.isPagingEnabled = true
        
        collectionView.layoutIfNeeded()
//        let cal = Calendar.current
//        collectionView.scrollToItem(at: IndexPath(item: cal.component(.month, from: Date()), section: 0), at: .right, animated: false)
        
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.requestData(ofYear: currentYear)
    }
    
    @IBAction func lastYearBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.year, offset: -1)
//        eventsOfYear = calendarLoader.loadEvents(ofYear: currentYear)
        dataSource.requestData(ofYear: currentYear)
        currentMonth = 1
        titleLabel.title = dateFormatter.string(from: currentYear) + " 1월"
        lastYearBtn.title = "< " + dateFormatter.string(from: currentYear.adjust(.year, offset: -1))
        nextYearBtn.title = dateFormatter.string(from: currentYear.adjust(.year, offset: 1)) + " >"
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
        collectionView.reloadData()
    }
    
    @IBAction func nextYearBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.year, offset: 1)
//        eventsOfYear = calendarLoader.loadEvents(ofYear: currentYear)
        dataSource.requestData(ofYear: currentYear)
        currentMonth = 1
        titleLabel.title = dateFormatter.string(from: currentYear) + " 1월"
        lastYearBtn.title = "< " + dateFormatter.string(from: currentYear.adjust(.year, offset: -1))
        nextYearBtn.title = dateFormatter.string(from: currentYear.adjust(.year, offset: 1)) + " >"
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
        collectionView.reloadData()
    }
}

// MARK: - Collection view extension
extension EventCollectionTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionCell", for: indexPath) as? EventCollectionCell else {
            return UICollectionViewCell()
        }
            
        events = dataArray[indexPath.item]
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
            titleLabel.title = dateFormatter.string(from: currentYear) + " " + String(indexPath!.item + 1) + "월"
            currentMonth = indexPath!.item + 1
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
        
//        let event =
//        let model = EventCollectionTableViewItem(event: event)
        cell.configureCell(with: events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(identifier: "EventDetailViewController") as UINavigationController? else { return }
        controller.modalPresentationStyle = .fullScreen
        guard let vc = controller.viewControllers.first as? EventDetailViewController else {
            return
        }
        vc.event = dataArray[currentMonth - 1][indexPath.row].event
        present(controller, animated: true, completion: nil)
    }
}

extension EventCollectionTableViewController: EventCollectionTableViewModelDelegate {
    func didLoadData(data: [[EventCollectionTableViewItem]]) {
        dataArray = data
    }
}

class EventCollectionCell: UICollectionViewCell {
    
}
