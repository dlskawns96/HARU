//
//  MainCalendarCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/08.
//

import Foundation
import FSCalendar
import EventKit

class MainCalendarCell: FSCalendarCell {
    
    func configureCell(with item: MainCalendarCellItem) {
        if item.numOfEvents != 0 {
            var posY = 50
            for event in item.events! {
                let lab = UILabel(frame: CGRect(x: 0, y: posY, width: Int(self.bounds.width), height: 15))
                lab.font = .systemFont(ofSize: 12, weight: .regular)
                lab.lineBreakMode = .byCharWrapping
                lab.text = event.title
                lab.textColor = UIColor.init(named: "#32C77F")
                self.addSubview(lab)
                lab.backgroundColor = UIColor(cgColor: event.calendar.cgColor)
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
    
    var numOfEvents: Int? {
        return events?.count
    }
}
