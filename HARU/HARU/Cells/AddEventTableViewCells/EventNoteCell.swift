//
//  EventNoteCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/29.
//

import UIKit

class EventNoteCell: UITableViewCell {
    
    @IBOutlet var textView: UITextView!
    
    var textChanged: ((String) -> Void)?
    var beginEditing: ((String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//MARK: - UITextViewDelegate
extension EventNoteCell: UITextViewDelegate {
    func beginEditing(action: @escaping (String) -> Void) {
        self.beginEditing = action
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        beginEditing?(textView.text)
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceHolder()
        } else {
            AddEventTableViewModel.newEvent.notes = textView.text
        }
    }
    
    func setPlaceHolder() {
        textView.text = "메모"
        textView.textColor = UIColor.lightGray
    }
}

//MARK: - CellController
class EventNoteCellController: AddEventCellController {
    fileprivate let item: AddEventCellItem
    let cellItem: EventNoteItem
    
    init(item: AddEventCellItem) {
        self.item = item
        cellItem = item as! EventNoteItem
    }
    
    fileprivate static var cellIdentifier: String {
        return String(describing: EventNoteCell.self)
    }
    
    static func registerCell(on tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! EventNoteCell
        
        cell.beginEditing {[weak tableView] (_) in
            DispatchQueue.main.async {
                tableView?.contentOffset = CGPoint(x: 0, y: cell.bounds.height)
            }
        }
        return cell
    }
    
    func didSelectCell() {
        
    }
    
    
}
