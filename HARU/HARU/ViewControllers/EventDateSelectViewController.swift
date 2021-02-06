//
//  EventDateSelectViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/01/21.
//

import UIKit
import FSCalendar
import AFDateHelper

class EventDateSelectViewController: UIViewController {
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var amPm: UISegmentedControl!
    
    var isKeyboardUp = false
    var activeField: UITextField!
    var viewTitleText = ""
    var selectedDate: Date! = nil
    var startDate: Date! = nil
    
    var delegate: PassSelectDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitle.text = viewTitleText
        setFSCalendar()
        setTimeSelectViews()
        hideKeyboard()
    }
    
    func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
    }
    
    func setTimeSelectViews() {
        self.hourTextField.delegate = self
        self.minuteTextField.delegate = self
        hourTextField.keyboardType = .numberPad
        minuteTextField.keyboardType = .numberPad
    }
    
    func hideKeyboard()
    {
        let tappy = UITapGestureRecognizer(target: self,
                                       action: #selector(dismissKeyboard))
        
        // 터치 감지를 하면서 감지한 터치 동작 취소하지 않기
        tappy.cancelsTouchesInView = false
        view.addGestureRecognizer(tappy)
    }
    
    @objc func dismissKeyboard()
    {
        if self.isKeyboardUp {
            view.endEditing(true)
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if self.selectedDate != nil {
            var h: Int = 9
            var m: Int = 0
            if hourTextField.text != nil && hourTextField.text != "" {
                h = Int(hourTextField.text!)!
                if minuteTextField.text != nil && minuteTextField.text != "" {
                    m = Int(minuteTextField.text!)!
                } else { m = 0 }
            }
            if amPm.selectedSegmentIndex == 1 {
                h = h + 12
            }
            var date = selectedDate.adjust(.hour, offset: h)
            date = date.adjust(.minute, offset: m)
            delegate?.passSelectDate(selectedDate: date, isStart: viewTitleText == "시작")
        }
        dismiss(animated: true)
    }
}

// Implemetation FSCalendar DataSource, Delegate
extension EventDateSelectViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func setFSCalendar() {
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
        fsCalendar.locale = Locale(identifier: "ko_KR")
        fsCalendar.headerHeight = 50
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        fsCalendar.appearance.headerDateFormat = "YYYY년 M월"
        fsCalendar.appearance.headerTitleColor = .black
        fsCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20)
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
    
    // 날짜 선택 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        selectedDate = date.adjust(.day, offset: 1)
//        selectedDate = selectedDate.adjust(hour: -15, minute: 0, second: 0)
        selectedDate = date
    }
 
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = nil
    }
    
    // 특정 날짜 셀에 색 적용
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if startDate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            if dateFormatter.string(from: startDate) == dateFormatter.string(from: date) {
                return .systemIndigo
            }
        }
        return nil
    }
}

extension EventDateSelectViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isKeyboardUp = true
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isKeyboardUp = false
        activeField = nil
        if textField == hourTextField {
            guard let time =  textField.text else { return }
            guard let typedTime = Int(time) else { return }
            switch typedTime {
                case 0...12:
                    return
                case 13...99:
                    textField.text = "12"
                default:
                    return
            }
        }
        if textField == minuteTextField {
            guard let time =  textField.text else { return }
            guard let typedTime = Int(time) else { return }
            switch typedTime {
                case 0...59:
                    return
                case 60...99:
                    textField.text = "59"
                default:
                    return
            }
        }
    }
    
    // Return 버튼 누르면 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == hourTextField || textField == minuteTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
         
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
         
            return updatedText.count <= 2
        }
        return true
    }
}

protocol PassSelectDate {
    func passSelectDate(selectedDate: Date, isStart: Bool)
}
