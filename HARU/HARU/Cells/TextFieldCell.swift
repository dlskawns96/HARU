//
//  TextFieldCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/18.
//

import UIKit

class TextFieldCell: UITableViewCell {
    //TODO: 텍스트필드셀 부터 구현
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.textAlignment = .right
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.textField {
            let value = textField.text!
            if value != "" {
                TextFieldCellController.getChangedValue(value: value)
            }
        }
    }
    
    // Return 버튼 누르면 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - CellController
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
    
    fileprivate static func getChangedValue(value: String) {
        AddEventTableViewModel.newEvent.title = value
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
