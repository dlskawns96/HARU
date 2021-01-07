//
//  ViewController.swift
//  HARU
//
//  Created by Lee Nam Jun on 2020/12/24.
//

import UIKit
import FSCalendar
import AFDateHelper

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    var eventStartDates: [NSDate] = []
    var eventEndDates: [NSDate] = []
    var eventTitles: [String] = []
    var loadedEvents: [CalendarLoader.EVENT] = []
    var labels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarLoader = CalendarLoader()
        self.loadedEvents = calendarLoader.loadedEvents
        
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        
        fsCalendar.locale = Locale(identifier: "ko_KR")
        fsCalendar.headerHeight = 50
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
        fsCalendar.appearance.headerDateFormat = "YYYY년 M월"
        fsCalendar.appearance.headerTitleColor = .black
        fsCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        fsCalendar.appearance.borderRadius = 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print(dateFormatter.string(from: date))
        
        guard let controller = self.storyboard?.instantiateViewController(identifier: "SelectDateController") as? SelectDateController else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        controller.paramDate = dateFormatter.string(from: date)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let eves = loadedEvents.filter({$0.startDate.compare(.isSameDay(as: date))})
        
        if eves.count != 0 {
            var posY = 50
            for eve in eves {
                let lab = UILabel(frame: CGRect(x: 0, y: posY, width: Int(cell.bounds.width), height: 15))
                lab.font = .systemFont(ofSize: 12, weight: .regular)
                lab.text = eve.title
                lab.textColor = UIColor.init(named: "#32C77F")
                cell.addSubview(lab)
                lab.backgroundColor = eve.color
                posY = posY + 15
            }
            
        } else {
            for view in cell.subviews {
                if view is UILabel {
                    view.removeFromSuperview()
                }
            }
        }
    }
}

