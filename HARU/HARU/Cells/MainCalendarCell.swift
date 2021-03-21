//
//  MainCalendarCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/08.
//

import Foundation
import EventKit

class MainCalendarCell: FSCalendarCell {
    static var currentMonth = Date()
    
    func configureCell(with item: MainCalendarCellItem) {
        if item.numOfEvents != 0 {
            var posY = 50
            for event in item.events! {
                let lab = UILabel(frame: CGRect(x: 0, y: posY, width: Int(self.bounds.width), height: 15))
                lab.clipsToBounds = true
                lab.layer.cornerRadius = 2.5
                lab.font = .systemFont(ofSize: 12, weight: .regular)
                lab.lineBreakMode = .byCharWrapping
                lab.text = event.title
                lab.textColor = UIColor.init(named: "#32C77F")
                self.addSubview(lab)
                lab.backgroundColor = UIColor(cgColor: event.calendar.cgColor).withAlphaComponent(0.75)
                posY = posY + 15
            }
        } else {
            for view in self.subviews {
                if view is UILabel {
                    view.removeFromSuperview()
                }
            }
            
        }
    }
}

struct MainCalendarCellItem {
    var events: [EKEvent]?
    var date: Date?
    var dateFormatter = DateFormatter()
    
    init(events: [EKEvent], date: Date) {
        self.events = events
        self.date = date
        dateFormatter.dateFormat = "ccc"
    }
    
    var numOfEvents: Int? {
        return events?.count
    }
    
    var dayString: String? {
        return dateFormatter.string(from: date!)
    }
}
