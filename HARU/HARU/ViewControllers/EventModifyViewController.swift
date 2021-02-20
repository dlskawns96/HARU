//
//  EventModifyViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/13.
//

import UIKit
import EventKit
import FSCalendar
import DropDown

class EventModifyViewController: UITableViewController {
    
    var dateFormatter = DateFormatter()
    
    var event: EKEvent? = nil
    var newEvent: EKEvent!
    
    var titles = [
        ["이벤트 제목"],
        ["시작", "종료"],
        ["캘린더"]]
    
    var eventTitleTF = UITextField()
    var startDateBtn = UIButton()
    var endDateBtn = UIButton()
    
    var startDateModifyCell = SetDateTableViewCell()
    var endDateModifyCell = SetDateTableViewCell()
    var setCalendarCell = SetCalendarTableViewCell()
    
    var isStartDateBtnOn = false
    var isEndDateBtnOn = false
    
    var isKeyboardUp = false
    var activeField: UITextField!
    
    let calendarDropDown = DropDown()
    let eventStore = EKEventStore()
    var calendars: [EKCalendar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newEvent = EKEvent(eventStore: eventStore)
        newEvent.startDate = event?.startDate
        newEvent.endDate = event?.endDate
        
        tableView.separatorInset.left = 0
//        tableView.rowHeight = UITableView.automaticDimension;
//        tableView.estimatedRowHeight = 130;
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        initTableView()
        hideKeyboard()
    }
    
    func initTableView() {
        tableView.sectionIndexColor = .lightGray
        calendars = eventStore.calendars(for: .event)
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        print("saveBtnClicked")
        // TODO: 저장 구현
    }
    
    @IBAction func startDateBtnClicked(_ sender: Any) {
        print("startDateBtnClicked")
    }
    
    @IBAction func endDateBtnClicked(_ sender: Any) {
        print("endDateBtnClicked")
    }
    
    func hideKeyboard() {
        let tappy = UITapGestureRecognizer(target: self,
                                       action: #selector(dismissKeyboard))
        
        // 터치 감지를 하면서 감지한 터치 동작 취소하지 않기
        tappy.cancelsTouchesInView = false
        view.addGestureRecognizer(tappy)
    }
    
    @objc func dismissKeyboard() {
        if self.isKeyboardUp {
            view.endEditing(true)
        }
    }
}

extension EventModifyViewController {
    // MARK: - Cell, UI 세팅
    func initSetDateTableViewCell(cell: SetDateTableViewCell) {
        cell.hourTF.delegate = self
        cell.minuteTF.delegate = self
        
        var date: Date!
        let formatter = DateFormatter()
        formatter.dateFormat = "aa hh mm"
        
        if cell == startDateModifyCell { date = event?.startDate }
        if cell == endDateModifyCell { date = event?.endDate }
        
        let dateString = formatter.string(from: date)
        let strings = dateString.components(separatedBy: " ")
        
        if strings[0] == "오전" || strings[0] == "AM"{
            cell.amPmSeg.selectedSegmentIndex = 0
            cell.hourTF.text = strings[1]
            cell.minuteTF.text = strings[2]
        }
        if strings[0] == "오후" || strings[0] == "PM"{
            cell.amPmSeg.selectedSegmentIndex = 1
            cell.hourTF.text = strings[1]
            cell.minuteTF.text = strings[2]
        }
    }
    
    func setDateSelectCell(cell: SetDateTableViewCell, indexPath: IndexPath, title: String) {
        cell.titleLabel.text = title
        setFSCalendar(fsCalendar: cell.fsCalendar)
    }
    
    func setButtonCell(cell: TitleSetTableViewCell, indexPath: IndexPath, text: String, button: UIButton) {
        cell.titleLabel.text = titles[indexPath.section][indexPath.row]
        
        button.setTitle(text, for: .normal)
        button.setTitleColor(.black, for: .normal)
        cell.contentView.addSubview(button)
        
        let safeArea = cell.contentView.safeAreaLayoutGuide
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: cell.titleLabel.centerYAnchor).isActive = true
        
        setButtonAction(button: button)
    }
    
    func setEventTitleCell(cell: TitleSetTableViewCell, indexPath: IndexPath, textField: UITextField) {
        cell.titleLabel.text = titles[indexPath.section][indexPath.row]
        
        textField.text = event?.title
        cell.contentView.addSubview(textField)
        
        let safeArea = cell.contentView.safeAreaLayoutGuide
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: cell.titleLabel.centerYAnchor).isActive = true
    }
    
    func setButtonAction(button: UIButton) {
        if button == startDateBtn {
            button.addTarget(self, action: #selector(onStartDateBtnClicked), for: .touchUpInside)
        }
        if button == endDateBtn {
            button.addTarget(self, action: #selector(onEndDateBtnClicked), for: .touchUpInside)
        }
        
    }
    
    @objc
    func onStartDateBtnClicked(_ sender: UIButton) {
        if isStartDateBtnOn {
            deleteCalendarCell(btn: startDateBtn, title: "시작 날짜")
            startDateModifyCell.fsCalendar.reloadData()
        } else {
            if isEndDateBtnOn {
                deleteCalendarCell(btn: endDateBtn, title: "종료 날짜")
                endDateModifyCell.fsCalendar.reloadData()
                isEndDateBtnOn.toggle()
            }
            insertStartCalendarCell(btn: startDateBtn, title: "시작")
        }
        isStartDateBtnOn.toggle()
    }
    
    @objc
    func onEndDateBtnClicked(_ sender: UIButton) {
        if isEndDateBtnOn {
            deleteCalendarCell(btn: endDateBtn, title: "종료 날짜")
            endDateModifyCell.fsCalendar.reloadData()
        } else {
            if isStartDateBtnOn {
                deleteCalendarCell(btn: startDateBtn, title: "시작 날짜")
                startDateModifyCell.fsCalendar.reloadData()
                isStartDateBtnOn.toggle()
            }
            insertStartCalendarCell(btn: endDateBtn, title: "종료")
        }
        isEndDateBtnOn.toggle()
        
    }
    
    func deleteCalendarCell(btn: UIButton, title: String) {
        let idx = titles[1].firstIndex(of: title)!
        titles[1].remove(at: idx)
        
        let cell = tableView.cellForRow(at: IndexPath(row: idx - 1, section: 1)) as! TitleSetTableViewCell
        cell.titleLabel.textColor = .black
        btn.setTitleColor(.black, for: .normal)
        deleteRow(indexPath: IndexPath(row: idx, section: 1))
    }
    
    func insertStartCalendarCell(btn: UIButton, title: String) {
        var toInsert = ""
        if title == "시작" {
            toInsert = "시작 날짜"
        } else if title == "종료" {
            toInsert = "종료 날짜"
        }
        
        let idx = titles[1].firstIndex(of: title)! + 1
        titles[1].insert(toInsert, at: idx)
        insertRow(indexPath: IndexPath(row: idx, section: 1))
        
        let cell = tableView.cellForRow(at: IndexPath(row: idx - 1, section: 1)) as! TitleSetTableViewCell
        cell.titleLabel.textColor = .red
        btn.setTitleColor(.red, for: .normal)
    }
    
    @objc
    func onCalendarSelectBtnClicked(_ sender: UIButton) {
        calendarDropDown.show()
    }
    
    func insertRow(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteRow(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func setDropDown(btn: UIButton) {
        calendarDropDown.dataSource = Array(calendars.map({(cal: EKCalendar) -> String in return cal.title}))
        calendarDropDown.anchorView = btn
        calendarDropDown.bottomOffset = CGPoint(x: 0, y: (calendarDropDown.anchorView?.plainView.bounds.height)!)
        calendarDropDown.width = 150
        
        // 커스텀셀 지정
        calendarDropDown.cellNib = UINib(nibName: "CalendarDropDownCell", bundle: nil)
        calendarDropDown.customCellConfiguration = {(index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CalendarDropDownCell else { return }
            cell.CalendarColorView.backgroundColor = UIColor(cgColor: self.calendars[index].cgColor)
            
        }
        calendarDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.setCalendarCell.calendarTitleBtn.setTitle(item, for: .normal)
            self.setCalendarCell.calendarColorView.backgroundColor = UIColor(cgColor: calendars[index].cgColor)
        }
        btn.addTarget(self, action: #selector(onCalendarSelectBtnClicked), for: .touchUpInside)
    }
}

extension EventModifyViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
           DispatchQueue.main.async {
            let endPosition = textField.endOfDocument
              textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
           }
        isKeyboardUp = true
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isKeyboardUp = false
        activeField = nil
        if textField == startDateModifyCell.hourTF || textField == endDateModifyCell.hourTF {
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
        if textField == startDateModifyCell.minuteTF || textField == endDateModifyCell.minuteTF {
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
        if textField == startDateModifyCell.hourTF || textField == endDateModifyCell.hourTF || textField == startDateModifyCell.minuteTF || textField == endDateModifyCell.minuteTF {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
         
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
         
            return updatedText.count <= 2
        }
        return true
    }
}


//MARK: - Table View
extension EventModifyViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightGray

        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightGray

        return view
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetTitle", for: indexPath) as! TitleSetTableViewCell
            setEventTitleCell(cell: cell, indexPath: indexPath, textField: eventTitleTF)
            return cell
        case 1:
            switch titles[indexPath.section][indexPath.row] {
            case "시작":
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetTitle", for: indexPath) as! TitleSetTableViewCell
                setButtonCell(cell: cell, indexPath: indexPath, text: dateFormatter.string(from: (event?.startDate)!), button: startDateBtn)
                return cell
            case "종료":
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetTitle", for: indexPath) as! TitleSetTableViewCell
                setButtonCell(cell: cell, indexPath: indexPath, text: dateFormatter.string(from: (event?.endDate)!), button: endDateBtn)
                return cell
            case "시작 날짜":
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetDateTableViewCell", for: indexPath) as! SetDateTableViewCell
                setDateSelectCell(cell: cell, indexPath: indexPath, title: titles[indexPath.section][indexPath.row])
                startDateModifyCell = cell
                initSetDateTableViewCell(cell: startDateModifyCell)
                return cell
            case "종료 날짜":
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetDateTableViewCell", for: indexPath) as! SetDateTableViewCell
                setDateSelectCell(cell: cell, indexPath: indexPath, title: titles[indexPath.section][indexPath.row])
                endDateModifyCell = cell
                initSetDateTableViewCell(cell: endDateModifyCell)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetTitle", for: indexPath) as! TitleSetTableViewCell
                cell.titleLabel.text = titles[indexPath.section][indexPath.row]
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetCalendarTableViewCell") as! SetCalendarTableViewCell
            cell.titleLabel.text = titles[indexPath.section][indexPath.row]
            cell.calendarTitleBtn.setTitle(event?.calendar.title, for: .normal)
            cell.calendarColorView.backgroundColor = UIColor(cgColor: (event?.calendar.cgColor)!)
            setCalendarCell = cell
            setDropDown(btn: cell.calendarTitleBtn)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetTitle", for: indexPath) as! TitleSetTableViewCell
            cell.titleLabel.text = titles[indexPath.section][indexPath.row]
            return cell
        }
    }
}

extension EventModifyViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func getWeekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.weekdaySymbols[Foundation.Calendar.current.component(.weekday, from: date) - 1]
    }
    
    func setFSCalendar(fsCalendar: FSCalendar) {
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
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if date.compare(.isSameDay(as: newEvent.startDate)) {
            return "시작"
        }
        if date.compare(.isSameDay(as: newEvent.endDate)) {
            return "종료"
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if date.compare(.isSameDay(as: newEvent.startDate)) {
            return .green
        }
        if date.compare(.isSameDay(as: newEvent.endDate)) {
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
        if isStartDateBtnOn {
            if date.compare(newEvent.endDate) == .orderedDescending {
                newEvent.endDate = date
                endDateBtn.setTitle(dateFormatter.string(from: date), for: .normal)
            }
            newEvent.startDate = date
            startDateBtn.setTitle(dateFormatter.string(from: date), for: .normal)
        }
        if isEndDateBtnOn {
            if date.compare(newEvent.startDate) == .orderedAscending {
                newEvent.startDate = date
                startDateBtn.setTitle(dateFormatter.string(from: date), for: .normal)
            }
            newEvent.endDate = date
            endDateBtn.setTitle(dateFormatter.string(from: date), for: .normal)
        }
        calendar.reloadData()
    }
}
