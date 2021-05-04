//
//  EventCollectionViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/21.
//

import UIKit
import EventKit

class EventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet var emptyLabel: UILabel!
    
    var tableViewData = [EventCollectionTableViewItem]()
    var delegate: EventCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        cellTitle.textColor = UIColor(named: AppDelegate.MAIN_COLOR)
        
        let nibName = UINib(nibName: EventCollectionTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: EventCollectionTableViewCell.cellIdentifier)
        
        tableView.removeExtraLine()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
    }
}

extension EventCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCollectionTableViewCell", for: indexPath) as! EventCollectionTableViewCell
        
        cell.configureCell(with: tableViewData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pushEventDetailView(event: tableViewData[indexPath.row].event!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

protocol EventCollectionViewCellDelegate: class {
    func pushEventDetailView(event: EKEvent)
}
