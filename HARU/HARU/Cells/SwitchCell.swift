//
//  SwitchCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/18.
//

import UIKit

class SwitchCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class SwitchCellController: AddEventCellController {
    
    fileprivate let item: AddEventCellItem
    let cellItem: SwitchItem
    
    init(item: AddEventCellItem) {
        self.item = item
        cellItem = item as! SwitchItem
    }
    
    fileprivate static var cellIdentifier: String {
        return String(describing: SwitchCell.self)
    }
    
    static func registerCell(on tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: SwitchCell.self)), forCellReuseIdentifier: cellIdentifier)
    }
    
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! SwitchCell
        cell.titleLabel.text = cellItem.titleString
        
        return cell
    }
    
    func didSelectCell() {
        //did select action
    }
}
