//
//  AddEventViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/01/12.
//

import UIKit
import DropDown
import EventKit

class AddEventViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var repeatPicker: UIPickerView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var repeatTimeStepper: UIStepper!
    @IBOutlet weak var repeatTimeTextField: UITextField!
    @IBOutlet weak var scrollViewContainer: UIView!
    @IBOutlet weak var calendarSelectBtn: UIButton!
    @IBOutlet weak var selectedCalendarTitle: UILabel!
    @IBOutlet weak var selectedCalendarView: UIView!
    
    var pickerData: [[String]] = [["Every"], ["1", "2", "3", "4", "5", "6", "7"], ["days", "weeks"]]
    var activeField: UITextField!
    var isKeyboardUp: Bool = false
    
    // 캘린더 드랍다운 메뉴를 위한 오브젝트
    var loadedEvents: [CalendarLoader.EVENT] = []
    let calendars = CalendarLoader().loadCalendars()
    let calendarDropDown = DropDown()
    var calendarTitles = [String: CGColor]()
    
    // 새로 생성할 이벤트를 저장할 오브젝트
    var newEvent = NewEvent()
    @IBOutlet weak var eventStartDateLabel: UILabel!
    @IBOutlet weak var eventStartTimeLabel: UILabel!
    @IBOutlet weak var eventEndDateLabel: UILabel!
    @IBOutlet weak var eventEndTimeLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    // 이벤트를 캘린더에 저장하기 위한 오브젝트
    let eventStore: EKEventStore = EKEventStore()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        setPickerView(pickerView: repeatPicker, enable: false, row: 3, inComponent: 1, animated: true)
        
        self.eventTitleTextField.delegate = self
        self.repeatTimeTextField.delegate = self
        
        repeatSwitch.isOn = false
        
        repeatTimeTextField.keyboardType = .numberPad
        repeatTimeStepper.value = 0

        setCalendarDropDown()
        initDateSelectViews()
        // 키보드 숨김, 스크롤 설정
        hideKeyboard()
        registerForKeyboardNotifications()
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
    }
    
    // MARK: - IBActions
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        saveNewEvent()
    }
    
    @IBAction func startDateSelectBtnClicked(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "EventDateSelectViewController")
                as? EventDateSelectViewController else { return }
        uvc.delegate = self
        uvc.viewTitleText = "시작"
        self.present(uvc, animated: true)
    }
    
    @IBAction func endDateSelectBtnClicked(_ sender: Any) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "EventDateSelectViewController")
                as? EventDateSelectViewController else { return }
        uvc.viewTitleText = "종료"
        uvc.delegate = self
        if newEvent.startDate != nil {
            uvc.startDate = newEvent.startDate
        }
        self.present(uvc, animated: true)
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
    func initDateSelectViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let dateString = dateFormatter.string(from: Date())
        eventStartDateLabel.text = dateString
        eventEndDateLabel.text = dateString
    }
    
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
        if (activeField != nil) && rect.contains(activeField.frame.origin) {
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
        calendarDropDown.anchorView = calendarSelectBtn
        calendarDropDown.bottomOffset = CGPoint(x: 0, y: (calendarDropDown.anchorView?.plainView.bounds.height)!)
        
        // 커스텀셀 지정
        calendarDropDown.cellNib = UINib(nibName: "CalendarDropDownCell", bundle: nil)
        calendarDropDown.customCellConfiguration = {(index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CalendarDropDownCell else { return }
            cell.CalendarColorView.backgroundColor = UIColor(cgColor: self.calendarTitles[Array(self.calendarTitles.keys)[index]]!)
            
        }
        calendarDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectedCalendarTitle.text = item
            let color = UIColor(cgColor: self.calendarTitles[Array(self.calendarTitles.keys)[index]]!)
            self.selectedCalendarView.backgroundColor = color
            newEvent.calendar.title = item
            newEvent.calendar.color = color
        }
    }
    
    /// 새로운 이벤트 저장
    func saveNewEvent() {
        
        let event: EKEvent = EKEvent(eventStore: eventStore)
        
        let calendars = eventStore.calendars(for: .event)
            for calendar in calendars {
                if calendar.title == newEvent.calendar.title {
                    event.calendar = calendar
                    event.title = eventTitleTextField.text
                    event.startDate = newEvent.startDate
                    event.endDate = newEvent.endDate
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    }
                    catch {
                       print("Error saving event in calendar")             }
                    }
                print("Event saved!")
                //TODO: 이벤트 저장하고 캘린더 다시로드
            }

    }
}

// MARK: - Extensions

// EventDateSelectViewController로 부터 선택한 날짜 받아오기
extension AddEventViewController: PassSelectDate {
    func passSelectDate(selectedDate: Date, isStart: Bool) {
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        
        if isStart {
            newEvent.startDate = selectedDate
            print(dateFormatter.string(from: newEvent.startDate))
            eventStartDateLabel.text = dateFormatter.string(from: newEvent.startDate)
            eventEndDateLabel.text = dateFormatter.string(from: newEvent.startDate)
            dateFormatter.dateFormat = "a hh:mm"
            eventStartTimeLabel.text = dateFormatter.string(from: newEvent.startDate)
            eventEndTimeLabel.text = dateFormatter.string(from: newEvent.startDate)
        } else {
            newEvent.endDate = selectedDate
            eventEndDateLabel.text = dateFormatter.string(from: newEvent.endDate)
            dateFormatter.dateFormat = "a hh:mm"
            eventEndTimeLabel.text = dateFormatter.string(from: newEvent.endDate)
        }
    }
}

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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
