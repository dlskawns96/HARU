//
//  AddNewEventViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/15.
//

import UIKit
import EventKit
import DropDown

class AddNewEventViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    let eventStore = EventHandler.ekEventStore
    var newEvent = EKEvent(eventStore: EventHandler.ekEventStore!)
    let calendarLoader = CalendarLoader()
    var calendars = [EKCalendar]()
    var selectedDate = Date()
    
    let dataSource = AddEventTableViewModel()
    var dataArray = [AddEventTableViewItem]()
    
    let calendarDropDown = DropDown()
    
    var cells = [AddEventTableViewCell]()
    
    var isCellLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = ThemeVariables.mainUIColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        isCellLoaded = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        calendars = calendarLoader.loadCalendars()
        newEvent.title = "새로운 이벤트"
        newEvent.startDate = selectedDate
        newEvent.endDate = selectedDate
        newEvent.calendar = calendars[0]
        AddEventTableViewModel.newEvent = newEvent
        dataSource.delegate = self
        dataSource.initData(newEvent: newEvent)
        
        tableView.rowHeight = 44
        tableView.removeExtraLine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        dataSource.saveNewEvent()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancleBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setCalendarDropDown() {
        var titles: [String] = []
        for calendar in calendars {
            titles.append(calendar.title)
        }
        
        calendarDropDown.dataSource = Array(titles)
        calendarDropDown.anchorView = cells[1]
        calendarDropDown.bottomOffset = CGPoint(x: 0, y: (calendarDropDown.anchorView?.plainView.bounds.height)!)
        
        // 커스텀셀 지정
        calendarDropDown.cellNib = UINib(nibName: "CalendarDropDownCell", bundle: nil)
        calendarDropDown.customCellConfiguration = {(index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CalendarDropDownCell else { return }
            cell.CalendarColorView.backgroundColor = UIColor(cgColor: self.calendars[index].cgColor)
            
        }
        calendarDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            dataSource.selectCalendar(newCalendar: calendars[index])
        }
    }
}

// MARK: - UI 동작 reaction
extension AddNewEventViewController {
    
}

// MARK: - Model Delegate
extension AddNewEventViewController: AddEventTableViewModelDelegate {
    func didLoadData(data: [AddEventTableViewItem]) {
        dataArray = data
    }
    
    func didElementChanged() {
        cells = []
        tableView.reloadData()
    }
}

// MARK: - TableView
extension AddNewEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddEventTableViewCell.identifier) as? AddEventTableViewCell else { return UITableViewCell() }
        if !isCellLoaded {
            cell.configureCell(with: dataArray[cells.count])
        } else {
            cell.reConfigureCell(with: dataArray[cells.count])
        }
        cells.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                calendarDropDown.show()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
                if indexPath == lastVisibleIndexPath {
                    isCellLoaded = true
                    setCalendarDropDown()
                }
            }
    }
}