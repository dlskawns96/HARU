//
//  LocationSelectCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/14.
//

import UIKit

class LocationSelectCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class LocationSelectCellController: AddEventCellController {
    fileprivate let item: AddEventCellItem
    let cellItem: LocationSelectItem
    
    init(item: AddEventCellItem) {
        self.item = item
        cellItem = item as! LocationSelectItem
    }
    
    fileprivate static var cellIdentifier: String {
        return String(describing: LocationSelectCell.self)
    }
    
    static func registerCell(on tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: LocationSelectCell.self)), forCellReuseIdentifier: cellIdentifier)
    }
    
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! LocationSelectCell
        cell.titleLabel.text = cellItem.titleString
        cell.locationNameLabel.text = AddEventTableViewModel.newEvent.location ?? ""
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func didSelectCell() {
        
    }
    
    
}
