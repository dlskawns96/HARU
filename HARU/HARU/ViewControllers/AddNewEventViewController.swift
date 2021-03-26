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
    fileprivate var cellControllers = [[AddEventCellController]]()
    fileprivate let cellControllerFactory = AddEventCellControllerFactory()
    fileprivate var items = [[AddEventCellItem]]() {
        didSet {
            cellControllers = cellControllerFactory.cellControllers(with: items)
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    let eventStore = EventHandler.ekEventStore
    let calendarLoader = CalendarLoader()
    var calendars = [EKCalendar]()
    var selectedDate = Date()
    
    let dataSource = AddEventTableViewModel()
    var dataArray = [AddEventTableViewItem]()
    
    let calendarDropDown = DropDown()
    
    var cells = [UITableViewCell]()
    
    var isCellLoaded = false
    var isStartDateCalendarInserted = false
    var isEndDateCalendarInserted = false
    var cellOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = ThemeVariables.mainUIColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        isCellLoaded = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        cellControllerFactory.registerCells(on: tableView)
        calendars = calendarLoader.loadCalendars()
        
        dataSource.delegate = self
        dataSource.initData(selectedDate: selectedDate, calendar: calendars[0])
        
        cellControllers = cellControllerFactory.cellControllers(with: items)
        
        
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.removeExtraLine()
        
        tableView.keyboardDismissMode = .onDrag
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
    func calenadrEditItemAdded(item: AddEventCellItem) {
        let cellItem = item as! CalendarEditItem
        if cellItem.titleString == "시작 날짜" {
            items[1].insert(cellItem, at: 2)
        } else if cellItem.titleString == "종료 날짜" {
            items[1].insert(cellItem, at: 3)
        }
    }
    
    func didLoadData(items: [[AddEventCellItem]]) {
        self.items = items
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44.0))
        returnedView.backgroundColor = .white
        
        return returnedView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellControllers[indexPath.section][indexPath.row].cellFromTableView(tableView, forIndexPath: indexPath)
        cells.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                calendarDropDown.show()
            } else if indexPath.row == 1 {
                if !isStartDateCalendarInserted {
                    if isEndDateCalendarInserted {
                        items[1].remove(at: 3)
                        isEndDateCalendarInserted = false
                    }
                    dataSource.addCalendarEditItem(title: "시작 날짜")
                    isStartDateCalendarInserted = true
                    cellOffset += 1
                } else {
                    items[1].remove(at: 2)
                    isStartDateCalendarInserted = false
                    cellOffset -= 1
                }
            } else if indexPath.row == 2 + cellOffset {
                if !isEndDateCalendarInserted {
                    if isStartDateCalendarInserted {
                        items[1].remove(at: 2)
                        isStartDateCalendarInserted = false
                    }
                    dataSource.addCalendarEditItem(title: "종료 날짜")
                    isEndDateCalendarInserted = true
                } else {
                    items[1].remove(at: 3)
                    isEndDateCalendarInserted = false
                }
                cellOffset = 0
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
