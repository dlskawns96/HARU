//
//  EventModifyViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/13.
//

import UIKit
import EventKit
import FSCalendar

class EventModifyViewController: UITableViewController {
    
    var dateFormatter = DateFormatter()
    
    var event: EKEvent? = nil
    
    var titles = [
        ["이벤트 제목"],
        ["시작", "종료"],
        ["캘린더"]]
    
    var eventTitleTF = UITextField()
    var startDateBtn = UIButton()
    var endDateBtn = UIButton()
    
    var isStartDateBtnOn = false
    var isEndDateBtnOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset.left = 0
//        tableView.rowHeight = UITableView.automaticDimension;
//        tableView.estimatedRowHeight = 130;
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        initTableView()
    }
    
    func initTableView() {
        tableView.sectionIndexColor = .lightGray
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        print("saveBtnClicked")
    }
    
    @IBAction func startDateBtnClicked(_ sender: Any) {
        print("startDateBtnClicked")
    }
    
    @IBAction func endDateBtnClicked(_ sender: Any) {
        print("endDateBtnClicked")
    }
}

extension EventModifyViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
           DispatchQueue.main.async {
            let endPosition = textField.endOfDocument
              textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
           }
    }
}

extension EventModifyViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 { return 0.0 }
//        return 40.0
//    }
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.0
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return ""
//    }
    
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

    // 시작날짜, 종료날짜 커스텀 셀 만들기
    // 시작, 종료 셀에 버튼 코드로 추가 -> 버튼 액션도 만들기
    
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
                return cell
            case "종료 날짜":
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetDateTableViewCell", for: indexPath) as! SetDateTableViewCell
                setDateSelectCell(cell: cell, indexPath: indexPath, title: titles[indexPath.section][indexPath.row])
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetTitle", for: indexPath) as! TitleSetTableViewCell
                cell.titleLabel.text = titles[indexPath.section][indexPath.row]
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SetTitle", for: indexPath) as! TitleSetTableViewCell
            cell.titleLabel.text = titles[indexPath.section][indexPath.row]
            return cell
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
            let idx = titles[1].firstIndex(of: "시작 날짜")!
            titles[1].remove(at: idx)
            
            let cell = tableView.cellForRow(at: IndexPath(row: idx - 1, section: 1)) as! TitleSetTableViewCell
            cell.titleLabel.textColor = .black
            sender.setTitleColor(.black, for: .normal)
            deleteRow(indexPath: IndexPath(row: idx, section: 1))
            
        } else {
            let idx = titles[1].firstIndex(of: "시작")! + 1
            titles[1].insert("시작 날짜", at: idx)
            insertRow(indexPath: IndexPath(row: idx, section: 1))
            
            let cell = tableView.cellForRow(at: IndexPath(row: idx - 1, section: 1)) as! TitleSetTableViewCell
            cell.titleLabel.textColor = .red
            sender.setTitleColor(.red, for: .normal)
        }
        
        isStartDateBtnOn.toggle()
    }
    
    @objc
    func onEndDateBtnClicked(_ sender: UIButton) {
        if isEndDateBtnOn {
            let idx = titles[1].firstIndex(of: "종료 날짜")!
            titles[1].remove(at: idx)
            
            let cell = tableView.cellForRow(at: IndexPath(row: idx - 1, section: 1)) as! TitleSetTableViewCell
            cell.titleLabel.textColor = .black
            sender.setTitleColor(.black, for: .normal)
            deleteRow(indexPath: IndexPath(row: idx, section: 1))
        } else {
            let idx = titles[1].firstIndex(of: "종료")! + 1
            titles[1].insert("종료 날짜", at: idx)
            insertRow(indexPath: IndexPath(row: idx, section: 1))
            
            let cell = tableView.cellForRow(at: IndexPath(row: idx - 1, section: 1)) as! TitleSetTableViewCell
            cell.titleLabel.textColor = .red
            sender.setTitleColor(.red, for: .normal)
        }
        
        isEndDateBtnOn.toggle()
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
//        fsCalendar.headerHeight = 50
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
}
