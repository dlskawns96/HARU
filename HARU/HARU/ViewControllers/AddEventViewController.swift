//
//  AddEventViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/01/12.
//

import UIKit
import FSCalendar
import DropDown

class AddEventViewController: UIViewController, FSCalendarDelegateAppearance {

    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var repeatPicker: UIPickerView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var repeatTimeStepper: UIStepper!
    @IBOutlet weak var repeatTimeTextField: UITextField!
    @IBOutlet weak var scrollViewContainer: UIView!
    @IBOutlet weak var calendarSelectBtn: UIButton!
    
    var pickerData: [[String]] = [["Every"], ["1", "2", "3", "4", "5", "6", "7"], ["days", "weeks"]]
    var activeField: UITextField!
    var isKeyboardUp: Bool = false
    
    // 캘린더 드랍다운 메뉴를 위한 오브젝트
    var loadedEvents: [CalendarLoader.EVENT] = []
    let calendars = CalendarLoader().loadCalendars()
    let calendarDropDown = DropDown()
    var calendarTitles = [String: CGColor]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        setFSCalendar()
        setPickerView(pickerView: repeatPicker, enable: false, row: 3, inComponent: 1, animated: true)
        
        self.eventTitleTextField.delegate = self
        self.repeatTimeTextField.delegate = self
        
        repeatSwitch.isOn = false
        
        repeatTimeTextField.keyboardType = .numberPad
        repeatTimeStepper.value = 0
        
        registerForKeyboardNotifications()
        hideKeyboard()
        
        setCalendarDropDown()
    }
    
    // MARK: - IBActions
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
    
    @IBAction func calendarSelectBtnClicked(_ sender: Any) {
        calendarDropDown.show()
    }
    
    // MARK: - Functions
    
    func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
    }
    
    
    /// 텍스트 필드 위치를 키보드 보다 위로 이동시키기
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// 이 메서드는 UIKeyboardDidShow 노티피케이션을 받으면 호출된다.
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

    /// 이 메서드는 UIKeyboardWillHide 노티피케이션을 받으면 호출된다.
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func setCalendarDropDown() {
        for calendar in calendars {
            calendarTitles[calendar.title] = calendar.cgColor
        }
        calendarDropDown.dataSource = Array(calendarTitles.keys)
        print("DATASOURCE", calendarDropDown.dataSource)
        calendarDropDown.anchorView = calendarSelectBtn
        calendarDropDown.bottomOffset = CGPoint(x: calendarSelectBtn.fs_width / 2.0, y: (calendarDropDown.anchorView?.plainView.bounds.height)!)
        
        // 커스텀셀 지정
        calendarDropDown.cellNib = UINib(nibName: "CalendarDropDownCell", bundle: nil)
        calendarDropDown.customCellConfiguration = {(index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CalendarDropDownCell else { return }
            print("INDEX", index)
            cell.CalendarColorView.backgroundColor = UIColor(cgColor: self.calendarTitles[Array(self.calendarTitles.keys)[index]]!)
            
        }
    }
}

// MARK: - Extensions

extension AddEventViewController {
    /// 화면 아무데나 터치하면 키보드 숨기기
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
}

// Implemetation FSCalendar DataSource, Delegate
extension AddEventViewController: FSCalendarDataSource, FSCalendarDelegate {
    func setFSCalendar() {
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
    func setPickerView(pickerView: UIPickerView, enable: Bool,
                       row: Int = 0, inComponent: Int = 0, animated: Bool = true) {
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(row, inComponent: inComponent, animated: animated)
        pickerEnable(picker: pickerView, enable: enable)
    }
    
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
        isKeyboardUp = true
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isKeyboardUp = false
        activeField = nil
    }
    
    // Return 버튼 누르면 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
