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

    
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var repeatPicker: UIPickerView!
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var repeatTimeStepper: UIStepper!
    @IBOutlet weak var repeatTimeTextField: UITextField!
    @IBOutlet weak var calendarSelectBtn: UIButton!
    @IBOutlet weak var selectedCalendarTitle: UILabel!
    @IBOutlet weak var selectedCalendarView: UIView!
    @IBOutlet weak var repeatGroup: UIView!
    
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
    let dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    // 이벤트를 캘린더에 저장하기 위한 오브젝트
    let eventStore: EKEventStore = EKEventStore()
    
    // 반복 횟수를 결정할 변수
    var isRepeat: Bool = false
    var repeatPeriod: Int = 0
    var repeatCycle: String = "days"
    
    // ViewController에 이벤트 변화사항 보내주기 위한 delegate
    var addEventViewControllerDelegate: AddEventViewControllerDelegate?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        setPickerView(pickerView: repeatPicker, enable: false, row: 3, inComponent: 1, animated: true)
        
        self.eventTitleTextField.delegate = self
        self.repeatTimeTextField.delegate = self
        
        repeatSwitch.isOn = false
        
        repeatTimeTextField.keyboardType = .numberPad
        repeatTimeStepper.value = 1

        setCalendarDropDown()
        initDateSelectViews()
        initNewEvent()
        // 키보드 숨김, 스크롤 설정
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideKeyboard()
        keyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //observer해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        saveNewEvent()
        addEventViewControllerDelegate?.newEventAdded()
        self.dismiss(animated: true, completion: nil)
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
            isRepeat = true
            pickerEnable(picker: repeatPicker, enable: true)
            UIView.animate(withDuration: 0.2, animations: { [self] in
                self.repeatGroup.transform = CGAffineTransform(translationX: 0, y: -10)
            })
            enableView(view: repeatGroup, enable: true)
        } else {
            isRepeat = false
            pickerEnable(picker: repeatPicker, enable: false)
            self.repeatGroup.transform = .identity
            enableView(view: repeatGroup, enable: false)
        }
    }
    
    @IBAction func repeatTimeStepperValueChanged(_ sender: UIStepper) {
        repeatTimeTextField.text = Int(sender.value).description
    }
    
    @IBAction func calendarSelectBtnClicked(_ sender: Any) {
        calendarDropDown.show()
    }
    
    // MARK: - Functions
    func enableView(view: UIView, enable: Bool) {
        view.isHidden = !enable
        view.isUserInteractionEnabled = enable
    }
    
    func initDateSelectViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let dateString = dateFormatter.string(from: Date())
        eventStartDateLabel.text = dateString
        eventEndDateLabel.text = dateString
        selectedCalendarTitle.text = calendars[0].title
        selectedCalendarView.backgroundColor = UIColor(cgColor: calendars[0].cgColor)
        repeatTimeTextField.text = "1"
    }
    
    func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
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
    
    func makeRepeatingEvents(creteriaEvent: NewEvent, calendar: EKCalendar) -> [EKEvent] {
        var events: [EKEvent] = []
        
        
        let repeatTime = Int(repeatTimeTextField.text!)!
        let title = eventTitleTextField.text!
        let startDate = creteriaEvent.startDate
        let endDate = creteriaEvent.endDate
        
        for n in 1...repeatTime {
            let event = EKEvent(eventStore: eventStore)
            event.calendar = calendar
            event.title = title + " \(n) / \(repeatTime)"
            
            if repeatCycle == "days" {
                event.startDate = startDate?.adjust(.day, offset: repeatPeriod * (n - 1))
                event.endDate = endDate?.adjust(.day, offset: repeatPeriod * (n - 1))
            }
            if repeatCycle == "weeks" {
                event.startDate = startDate?.adjust(.day, offset: repeatPeriod * (n - 1) * 7)
                event.endDate = endDate?.adjust(.day, offset: repeatPeriod * (n - 1) * 7)
            }
            
            events.append(event)
        }
        return events
    }
    
    /// 새로운 이벤트 저장
    func saveNewEvent() {
        var events: [EKEvent] = []
        
        let calendars = eventStore.calendars(for: .event)
            for calendar in calendars {
                if calendar.title == newEvent.calendar.title {
                    if isRepeat {
                        events = makeRepeatingEvents(creteriaEvent: newEvent, calendar: calendar)
                        print(events)
                    } else {
                        let event = EKEvent(eventStore: eventStore)
                        event.calendar = calendar
                        event.title = eventTitleTextField.text
                        event.startDate = newEvent.startDate
                        event.endDate = newEvent.endDate
                        events.append(event)
                    }
                    do {
                        for event in events {
                            try eventStore.save(event, span: .thisEvent)
                        }
                    }
                    catch {
                       print("Error saving event in calendar")
                    }
                    print("Event saved!")
                    return
                }
            }
    }
    
    func initNewEvent() {
        newEvent.calendar.title = calendars[0].title
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        let now = cal.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!.adjust(.hour, offset: 9)
        newEvent.startDate = now
        newEvent.endDate = now
    }
    
    func keyboard() {
        //observer등록
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewMoveDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func textViewMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: { [self] in
                            print(keyboardSize.origin.y, repeatGroup.globalFrame!.origin.y)
                            let y = keyboardSize.origin.y - repeatGroup.globalFrame!.origin.y
                            self.repeatGroup.transform = CGAffineTransform(translationX: 0, y: 2.0 * y)
                            self.repeatPicker.isHidden = true})
        }
    }

    @objc func textViewMoveDown(_ notification: NSNotification) {
        self.view.endEditing(true)
        self.repeatPicker.isHidden = false
        self.repeatGroup.transform = .identity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true) }
}

// MARK: - Extensions

// EventDateSelectViewController로 부터 선택한 날짜 받아오기
extension AddEventViewController: PassSelectDate {
    func passSelectDate(selectedDate: Date, isStart: Bool) {
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        
        if isStart {
            newEvent.startDate = selectedDate
            newEvent.endDate = selectedDate
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            repeatPeriod = Int(pickerData[component][row])!
        }
        if component == 2 {
            repeatCycle = pickerData[component][row]
        }
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

extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}

extension Date {
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func toStringKST( dateFormat format: String ) -> String {
        return self.toString(dateFormat: format)
    }
    
    func toStringUTC( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}

protocol AddEventViewControllerDelegate {
    func newEventAdded()
    func eventDeleted()
}
