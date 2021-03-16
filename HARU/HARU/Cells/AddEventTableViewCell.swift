//
//  AddEventTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/15.
//

import UIKit
import EventKit

class AddEventTableViewCell: UITableViewCell {

    static let identifier = "AddEventTableViewCell"
    static let TITLE_TF_TAG = 111
    static let CALENDAR_VIEW_TAG = 222
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var cellContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with item: AddEventTableViewItem) {
        self.cellTitleLabel.text = item.titleLabelString
        
        switch item.titleLabelString {
        case "캘린더":
            configureCalendarCell(item: item)
        case "타이틀":
            configureTitleCell(item: item)
        case "반복":
            configureRepeatCell(item: item)
        default:
            self.cellContentLabel.text = item.contentLabelString()
            
        }
    }
    
    func reConfigureCell(with item: AddEventTableViewItem) {
        switch item.titleLabelString {
        case "캘린더":
            let cal = self.viewWithTag(AddEventTableViewCell.CALENDAR_VIEW_TAG)
            cal?.backgroundColor = UIColor(cgColor: AddEventTableViewModel.newEvent.calendar.cgColor)
            self.cellContentLabel.text = AddEventTableViewModel.newEvent.calendar.title
        case "타이틀":
            let tf = self.viewWithTag(AddEventTableViewCell.TITLE_TF_TAG) as! UITextField
            tf.placeholder = AddEventTableViewModel.newEvent.title
        case "반복":
            print("")
//            configureRepeatCell(item: item)
        default:
            self.cellContentLabel.text = item.contentLabelString()
            
        }
    }
    
    func configureTitleCell(item: AddEventTableViewItem) {
        // 리로드 할 때 configure 고려하기
        self.cellContentLabel.removeFromSuperview()
        let tf = UITextField()
        tf.tag = AddEventTableViewCell.TITLE_TF_TAG
        self.addSubview(tf)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.centerYAnchor.constraint(equalTo: self.cellTitleLabel.centerYAnchor).isActive = true
        tf.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17).isActive = true
        tf.placeholder = AddEventTableViewModel.newEvent.title
    }
    
    func configureCalendarCell(item: AddEventTableViewItem) {
        self.cellContentLabel.text = AddEventTableViewModel.newEvent.calendar.title
        let view = UIView()
        view.tag = AddEventTableViewCell.CALENDAR_VIEW_TAG
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 15).isActive = true
        view.widthAnchor.constraint(equalToConstant: 15).isActive = true
        view.trailingAnchor.constraint(equalTo: cellContentLabel.leadingAnchor, constant: -10).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        view.backgroundColor = UIColor(cgColor: AddEventTableViewModel.newEvent.calendar.cgColor)
    }
    
    func configureRepeatCell(item: AddEventTableViewItem) {
        self.cellContentLabel.removeFromSuperview()
        let uiSwitch = UISwitch()
        self.addSubview(uiSwitch)
        uiSwitch.isOn = false
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        uiSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17).isActive = true
    }
}

struct AddEventTableViewItem {
    var titleLabelString: String?
    
    func contentLabelString() -> String {
        switch titleLabelString {
        case "타이틀":
            return AddEventTableViewModel.newEvent.title
        case "캘린더":
            return AddEventTableViewModel.newEvent.calendar.title
        case "시작":
            return AddEventTableViewModel.newEvent.startDate.toString(dateFormat: "yyyy년 MM월 dd일 a hh:mm")
        case "종료":
            return AddEventTableViewModel.newEvent.endDate.toString(dateFormat: "yyyy년 MM월 dd일 a hh:mm")
        default:
            return ""
        }
    }
}
