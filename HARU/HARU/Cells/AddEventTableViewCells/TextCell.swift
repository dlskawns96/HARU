//
//  TextCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/18.
//

import UIKit

class TextCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class TextCellController: AddEventCellController {
    
    fileprivate let item: AddEventCellItem
    let cellItem: TextItem
    
    init(item: AddEventCellItem) {
        self.item = item
        cellItem = item as! TextItem
    }
    
    fileprivate static var cellIdentifier: String {
        return String(describing: TextCell.self)
    }
    
    static func registerCell(on tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: TextCell.self)), forCellReuseIdentifier: cellIdentifier)
    }
    
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! TextCell
        cell.titleLabel.text = cellItem.titleString
        
        if cellItem.isStartDate {
            cell.contentLabel.text = AddEventTableViewModel.newEvent.startDate.toString(dateFormat: "yyyy년 MM월 dd일 a hh:mm")
        } else {
            cell.contentLabel.text = AddEventTableViewModel.newEvent.endDate.toString(dateFormat: "yyyy년 MM월 dd일 a hh:mm")
        }
        return cell
    }
    
    func didSelectCell() {
        
    }
}
