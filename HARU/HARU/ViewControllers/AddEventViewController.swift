//
//  AddEventViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/01/12.
//

import UIKit
import FSCalendar

class AddEventViewController: UIViewController, FSCalendarDelegateAppearance {

    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var repeatPicker: UIPickerView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var repeatTimeStepper: UIStepper!
    @IBOutlet weak var repeatTimeTextField: UITextField!
    
    var pickerData: [[String]] = [[String]]()
    var activeField: UITextField!

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
        
        pickerData = [["Every"], ["1", "2", "3", "4", "5", "6", "7"], ["days", "weeks"]]
        
        self.repeatPicker.dataSource = self
        self.repeatPicker.delegate = self
        self.eventTitleTextField.delegate = self
        self.repeatTimeTextField.delegate = self
        
        repeatPicker.selectRow(3, inComponent: 1, animated: true)
        pickerEnable(picker: repeatPicker, enable: false)
        
        repeatSwitch.isOn = false
        
        repeatTimeTextField.keyboardType = .numberPad
        repeatTimeStepper.value = 0
        
        registerForKeyboardNotifications()
        hideKeyboard()
    }  // viewDidLoad()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
    }
    
    @IBAction func repeatSwitchValueChanged(_ sender: Any) {
        if self.repeatSwitch.isOn {
            pickerEnable(picker: repeatPicker, enable: true)
        } else {
            pickerEnable(picker: repeatPicker, enable: false)
        }
    }
    
    @IBAction func repeatTimeStepperValueChanged(_ sender: UIStepper) {
        repeatTimeTextField.text = Int(sender.value).description
    }
    
    func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
    }
    
    // 텍스트 필드 위치를 키보드 보다 위로 이동시키기
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 이 메서드는 UIKeyboardDidShow 노티피케이션을 받으면 호출된다.
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        // 활성화된 텍스트 필드가 키보드에 의해 가려진다면 가려지지 않도록 스크롤한다.
        var rect = self.view.frame
        rect.size.height -= keyboardFrame.height
        if rect.contains(activeField.frame.origin) {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }

    // 이 메서드는 UIKeyboardWillHide 노티피케이션을 받으면 호출된다.
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

// Implemetation FSCalendar DataSource, Delegate
extension AddEventViewController: FSCalendarDataSource, FSCalendarDelegate {
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
}

// Implemetation UIPickerView DataSource, Delegate
extension AddEventViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerEnable(picker: UIPickerView, enable: Bool) {
        picker.isHidden = !enable
        picker.isUserInteractionEnabled = enable
    }
}

extension AddEventViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    // Return 버튼 누르면 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
