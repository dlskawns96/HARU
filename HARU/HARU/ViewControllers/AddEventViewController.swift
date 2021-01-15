//
//  AddEventViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/01/12.
//

import UIKit
import FSCalendar

class AddEventViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    @IBOutlet weak var fsCalendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
        fsCalendar.locale = Locale(identifier: "ko_KR")
        fsCalendar.headerHeight = 50
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        fsCalendar.appearance.headerDateFormat = "YYYY년 M월"
        fsCalendar.appearance.headerTitleColor = .black
        fsCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        fsCalendar.appearance.borderRadius = 0
        
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
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
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
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
    }
    
    func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
    }

}
