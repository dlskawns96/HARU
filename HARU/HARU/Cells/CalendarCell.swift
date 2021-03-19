//
//  CalendarCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/18.
//

import UIKit

class CalendarCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarTitleLabel: UILabel!
    @IBOutlet weak var calendarColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class CalendarCellController: AddEventCellController {
    
    fileprivate let item: AddEventCellItem
    let cellItem: CalendarItem
    
    init(item: AddEventCellItem) {
        self.item = item
        cellItem = item as! CalendarItem
    }
    
    fileprivate static var cellIdentifier: String {
        return String(describing: CalendarCell.self)
    }
    
    static func registerCell(on tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: CalendarCell.self)), forCellReuseIdentifier: cellIdentifier)
    }
    
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! CalendarCell
        
        cell.titleLabel.text = cellItem.titleString
        cell.calendarTitleLabel.text = AddEventTableViewModel.newEvent.calendar.title
        cell.calendarColorView.backgroundColor = UIColor(cgColor: AddEventTableViewModel.newEvent.calendar.cgColor)
        
        return cell
    }
    
    func didSelectCell() {
        //did select action
    }
}
