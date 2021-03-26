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
    
    var calendarLoader = CalendarLoader()
    var currentYear = Date()
    
    var dateFormatter = DateFormatter()
    
    var dataSource = EventCollectionTableViewModel()
    var dataArray = [[EventCollectionTableViewItem]]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var tableViews = [UITableView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        dateFormatter.dateFormat = "yyyy년"
        titleLabel.title = dateFormatter.string(from: Date())
        lastYearBtn.title = "< " + dateFormatter.string(from: Date().adjust(.year, offset: -1))
        nextYearBtn.title = dateFormatter.string(from: Date().adjust(.year, offset: 1)) + " >"
        
        collectionView.decelerationRate = .normal
        collectionView.isPagingEnabled = true
        
        collectionView.layoutIfNeeded()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSource.requestData(ofYear: currentYear)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.scrollToItem(at:IndexPath(item: Calendar.current.component(.month, from: Date()) - 1, section: 0), at: .right, animated: true)
    }
    
    @IBAction func lastYearBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.year, offset: -1)
        dataSource.requestData(ofYear: currentYear)
        titleLabel.title = dateFormatter.string(from: currentYear)
        lastYearBtn.title = "< " + dateFormatter.string(from: currentYear.adjust(.year, offset: -1))
        nextYearBtn.title = dateFormatter.string(from: currentYear.adjust(.year, offset: 1)) + " >"
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
        collectionView.reloadData()
    }
    
    @IBAction func nextYearBtnClicked(_ sender: Any) {
        currentYear = currentYear.adjust(.year, offset: 1)
        dataSource.requestData(ofYear: currentYear)
        titleLabel.title = dateFormatter.string(from: currentYear)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.cellTitle.text = String(indexPath.item + 1) + "월"
        cell.tableViewData = dataArray[indexPath.item]
        cell.tableView.reloadData()
        
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
}

extension EventCollectionTableViewController: EventCollectionTableViewModelDelegate {
    func didLoadData(data: [[EventCollectionTableViewItem]]) {
        dataArray = data
    }
}
