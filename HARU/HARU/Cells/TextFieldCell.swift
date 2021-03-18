//
//  TextFieldCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/18.
//

import UIKit

class TextFieldCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class TextFieldCellController: AddEventCellController {
    
    fileprivate let item: AddEventCellItem
    let cellItem: TextFieldItem
    
    init(item: AddEventCellItem) {
        self.item = item
        cellItem = item as! TextFieldItem
    }
    
    fileprivate static var cellIdentifier: String {
        return String(describing: TextFieldCell.self)
    }
    
    static func registerCell(on tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: TextFieldCell.self)), forCellReuseIdentifier: cellIdentifier)
    }
    
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! TextFieldCell
        
        cell.titleLabel.text = cellItem.titleString
        cell.textField.placeholder = AddEventTableViewModel.newEvent.title
        return cell
    }
    
    func didSelectCell() {
        //did select action
    }
}
