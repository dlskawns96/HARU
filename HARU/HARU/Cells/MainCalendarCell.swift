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
        self.selectedBackgroundView?.translatesAutoresizingMaskIntoConstraints = false
        self.selectedBackgroundView?.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        if item.numOfEvents != 0 {
            var posY = 50
            for idx in 0..<item.eventsToIndicate.count {
                if item.eventsToIndicate[idx] == nil {
                    continue
                } else {
                    var lab = UILabel(frame: CGRect(x: 0, y: Int(posY + idx * 15), width: Int(self.bounds.width + 0.5), height: 15))
                    if item.date!.isSameAs(as: .day, from: item.eventsToIndicate[idx]!.startDate) && !item.date!.isSameAs(as: .day, from: item.eventsToIndicate[idx]!.endDate){
                         lab = UILabel(frame: CGRect(x: 0, y: Int(posY + idx * 15), width: Int(self.bounds.width * 2), height: 15))
                    } else if item.date!.isSameAs(as: .day, from: item.eventsToIndicate[idx]!.startDate.adjust(.day, offset: 1)) && !item.date!.isSunday() {
                        continue
                    }
                    
                    lab.font = .systemFont(ofSize: 12, weight: .regular)
                    lab.lineBreakMode = .byCharWrapping
                    
                    if item.date!.isSameAs(as: .day, from: item.eventsToIndicate[idx]!.startDate) {
                        lab.text = item.eventsToIndicate[idx]!.title
                        lab.textColor = UIColor.init(named: "#32C77F")
                    }
                    self.addSubview(lab)
                    lab.backgroundColor = UIColor(cgColor: item.eventsToIndicate[idx]!.calendar.cgColor)
                }
                
//                posY = posY + 15
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
    var eventsToIndicate: [EKEvent?] = [nil, nil, nil, nil]
    
    init(events: [EKEvent], date: Date) {
        self.events = events
        self.date = date
        for idx in 0..<events.count {
            if !events[idx].startDate.isSameAs(as: .day, from: date) {
                eventsToIndicate[events[idx].calendarIndex] = events[idx]
            } else {
                for i in 0..<eventsToIndicate.count {
                    if eventsToIndicate[i] == nil {
                        eventsToIndicate[i] = events[idx]
                        events[idx].calendarIndex = i
                        break
                    }
                }
            }
        }
        dateFormatter.dateFormat = "ccc"
    }
    
    var numOfEvents: Int? {
        return events?.count
    }
    
    var dayString: String? {
        return dateFormatter.string(from: date!)
    }
}
