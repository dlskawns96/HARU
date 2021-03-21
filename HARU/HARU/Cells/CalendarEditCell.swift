//
//  CalendarEditCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/19.
//

import UIKit

class CalendarEditCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amPmSegmentControl: UISegmentedControl!
    @IBOutlet weak var hourTF: UITextField!
    @IBOutlet weak var minuteTF: UITextField!
    @IBOutlet weak var fsCalendar: FSCalendar!
    var tableView: UITableView?
    
    var titleString: String? {
        didSet {
            titleLabel.text = titleString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        hourTF.delegate = self
        minuteTF.delegate = self
        setFSCalendar()
        setSegmentControl()
        setTextFields()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setTextFields() {
        if amPmSegmentControl.selectedSegmentIndex == 1 {
            hourTF.text = String(AddEventTableViewModel.newEvent.startDate.component(.hour)! - 12)
            minuteTF.text = String(AddEventTableViewModel.newEvent.startDate.component(.minute)!)
        } else {
            hourTF.text = String(AddEventTableViewModel.newEvent.startDate.component(.hour)!)
            minuteTF.text = String(AddEventTableViewModel.newEvent.startDate.component(.minute)!)
        }
        
    }
    
    func setSegmentControl() {
        if titleString == "시작 날짜" {
            if AddEventTableViewModel.newEvent.startDate.component(.hour)! >= 13 {
                amPmSegmentControl.selectedSegmentIndex = 1
            }
        } else {
            if AddEventTableViewModel.newEvent.endDate.component(.hour)! >= 13 {
                amPmSegmentControl.selectedSegmentIndex = 1
            }
        }
    }
    
    func setFSCalendar() {
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
        fsCalendar.locale = Locale(identifier: "ko_KR")
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        fsCalendar.appearance.headerDateFormat = "YYYY년 M월"
        fsCalendar.appearance.headerTitleColor = .black
        fsCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 15)
        fsCalendar.appearance.borderRadius = 5
        
        for weekday in fsCalendar.calendarWeekdayView.weekdayLabels {
            if weekday.text == "일" {
                weekday.textColor = .red
            } else if weekday.text == "토" {
                weekday.textColor = .blue
            } else {
                weekday.textColor = .black
            }
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        if amPmSegmentControl.selectedSegmentIndex == 1 {
            if titleString == "시작 날짜" {
                AddEventTableViewModel.newEvent.startDate = AddEventTableViewModel.newEvent.startDate.adjust(hour: Int(hourTF.text!)! + 12, minute: nil, second: nil)
            } else {
                AddEventTableViewModel.newEvent.endDate = AddEventTableViewModel.newEvent.endDate.adjust(hour: Int(hourTF.text!)! + 12, minute: nil, second: nil)
            }
        } else {
            if titleString == "시작 날짜" {
                AddEventTableViewModel.newEvent.startDate = AddEventTableViewModel.newEvent.startDate.adjust(hour: Int(hourTF.text!)!, minute: nil, second: nil)
            } else {
                AddEventTableViewModel.newEvent.endDate = AddEventTableViewModel.newEvent.endDate.adjust(hour: Int(hourTF.text!)!, minute: nil, second: nil)
            }
        }
        tableView?.reloadData()
    }
}

// MARK: - TextField
extension CalendarEditCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == hourTF {
            guard let time =  textField.text else { return }
            guard let typedTime = Int(time) else { return }
            if typedTime >= 13 && typedTime <= 99 {
                textField.text = "12"
            }
            if self.titleString == "시작 날짜" {
                if amPmSegmentControl.selectedSegmentIndex == 1 {
                    AddEventTableViewModel.newEvent.startDate = AddEventTableViewModel.newEvent.startDate.adjust(hour: Int(textField.text!)! + 12, minute: nil, second: nil)
                } else {
                    AddEventTableViewModel.newEvent.startDate = AddEventTableViewModel.newEvent.startDate.adjust(hour: Int(textField.text!)!, minute: nil, second: nil)
                }
            } else {
                if amPmSegmentControl.selectedSegmentIndex == 1 {
                    AddEventTableViewModel.newEvent.endDate = AddEventTableViewModel.newEvent.endDate.adjust(hour: Int(textField.text!)! + 12, minute: nil, second: nil)
                } else {
                    AddEventTableViewModel.newEvent.endDate = AddEventTableViewModel.newEvent.endDate.adjust(hour: Int(textField.text!)!, minute: nil, second: nil)
                }

            }
        }
        if textField == minuteTF {
            guard let time =  textField.text else { return }
            guard let typedTime = Int(time) else { return }
            if typedTime >= 60 && typedTime <= 99 {
                textField.text = "59"
            }
            if self.titleString == "시작 날짜" {
                AddEventTableViewModel.newEvent.startDate = AddEventTableViewModel.newEvent.startDate.adjust(hour: nil, minute: Int(textField.text!), second: nil)
            } else {
                AddEventTableViewModel.newEvent.endDate = AddEventTableViewModel.newEvent.endDate.adjust(hour: nil, minute: Int(textField.text!), second: nil)
            }
        }
        if AddEventTableViewModel.newEvent.startDate.compare(AddEventTableViewModel.newEvent.endDate) == ComparisonResult.orderedDescending {
            AddEventTableViewModel.newEvent.endDate = AddEventTableViewModel.newEvent.startDate
        }
        tableView?.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == hourTF || textField == minuteTF {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 2
        }
        return true
    }
}

// MARK: - FSCalendar
extension CalendarEditCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if date.compare(.isSameDay(as: AddEventTableViewModel.newEvent.startDate)) {
            return "시작"
        }
        if date.compare(.isSameDay(as: AddEventTableViewModel.newEvent.endDate)) {
            return "종료"
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if date.compare(.isSameDay(as: AddEventTableViewModel.newEvent.startDate)) {
            return .green
        }
        if date.compare(.isSameDay(as: AddEventTableViewModel.newEvent.endDate)) {
            return .green
        }
        
        return nil
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let isSameMon: Bool = date.isSameAs(as: .month, from: calendar.currentPage)
        if !isSameMon {
            return nil
        }
        if getWeekDay(for: date) == "Sunday" {
            return .red
        }
        if getWeekDay(for: date) == "Saturday" {
            return .blue
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if self.titleString == "시작 날짜" {
            if AddEventTableViewModel.newEvent.endDate.compare(date) == .orderedAscending {
                AddEventTableViewModel.newEvent.endDate = AddEventTableViewModel.newEvent.startDate.adjust(hour: nil, minute: nil, second: nil, day: date.component(.day), month: date.component(.month))
            }
            AddEventTableViewModel.newEvent.startDate = AddEventTableViewModel.newEvent.startDate.adjust(hour: nil, minute: nil, second: nil, day: date.component(.day), month: date.component(.month))
        } else {
            if AddEventTableViewModel.newEvent.startDate.compare(date) == .orderedDescending {
                AddEventTableViewModel.newEvent.startDate = AddEventTableViewModel.newEvent.endDate.adjust(hour: nil, minute: nil, second: nil, day: date.component(.day), month: date.component(.month))
            }
            AddEventTableViewModel.newEvent.endDate = AddEventTableViewModel.newEvent.endDate.adjust(hour: nil, minute: nil, second: nil, day: date.component(.day), month: date.component(.month))
        }
        tableView?.reloadData()
        calendar.reloadData()
    }
}

// MARK: - Cell Controller
class CalendarEditCellController: AddEventCellController {
    fileprivate let item: AddEventCellItem
    let cellItem: CalendarEditItem
    
    init(item: AddEventCellItem) {
        self.item = item
        cellItem = item as! CalendarEditItem
    }
    
    fileprivate static var cellIdentifier: String {
        return String(describing: CalendarEditCell.self)
    }
    
    static func registerCell(on tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle(for: TextCell.self)), forCellReuseIdentifier: cellIdentifier)
    }
    
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath) as! CalendarEditCell
        cell.titleString = cellItem.titleString
        cell.tableView = tableView
        return cell
    }
    
    func didSelectCell() {
        //did select action
    }
}
