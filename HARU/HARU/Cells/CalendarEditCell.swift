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
    var titleString: String? {
        didSet {
            titleLabel.text = titleString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setFSCalendar()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
}

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
        return cell
    }
    
    func didSelectCell() {
        //did select action
    }
}
