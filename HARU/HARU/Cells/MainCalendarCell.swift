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
    let gregorian = Calendar.current
    weak var circleImageView: UIImageView!
    var evaluationLabel: UILabel!
    var evaluations = ["😱", "😀", "🥰"]
    
    var cellDate: Date? {
        didSet {
            indicateToday(date: cellDate!)
            indicateEvaluation()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.borderWidth = 1
        self.borderColor = UIColor.lightGray.withAlphaComponent(0.25)
        initCell()
        insertTodayCirlce()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func initCell() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        let evaluationLabel = UILabel()
        evaluationLabel.text = ""
        evaluationLabel.font = .systemFont(ofSize: 12.5)
        self.evaluationLabel = evaluationLabel
        self.contentView.addSubview(self.evaluationLabel)
        self.evaluationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.evaluationLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.evaluationLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
    
    }
    
    private func indicateToday(date: Date) {
        if self.gregorian.isDateInToday(date) {
            self.borderColor = UIColor(named: AppDelegate.MAIN_COLOR)
        } else {
            self.borderColor = UIColor.lightGray.withAlphaComponent(0.25)
        }
    }
    
    private func indicateEvaluation() {
        let eval = DiaryTableViewModel.requestEvaluation(selectedDate: cellDate!)
        if eval != 0 {
            self.evaluationLabel.text = evaluations[eval - 1]
        } else {
            self.evaluationLabel.text = ""
        }
    }
    
    private func insertTodayCirlce() {
        let circleImageView = UIImageView(image: UIImage(named: "circle")!)
        self.addSubview(circleImageView)
        self.circleImageView = circleImageView
        self.circleImageView.translatesAutoresizingMaskIntoConstraints = false
        self.circleImageView.isHidden = true
        self.circleImageView.backgroundColor = .red
    }
    
    func configureCell(with item: MainCalendarCellItem) {
        indicateEvaluation()
        for view in self.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
        if item.numOfEvents != 0 {
            let height = Double(self.bounds.height / 5.0)
            let posY = height * 2.0
            
            for idx in 0..<item.eventsToIndicate.count {
                if item.eventsToIndicate[idx] == nil {
                    continue
                } else {
                    var lab = UILabel(frame: CGRect(x: 0.0, y: posY + Double(idx) * height, width: Double(self.bounds.width), height: height))
                    if item.date!.isSameAs(as: .day, from: item.eventsToIndicate[idx]!.startDate) && !item.date!.isSameAs(as: .day, from: item.eventsToIndicate[idx]!.endDate){
                        lab = UILabel(frame: CGRect(x: 0.0, y: posY + Double(idx) * height, width: Double(self.bounds.width) * 2.0, height: height))
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
                    lab.backgroundColor = UIColor(cgColor: item.eventsToIndicate[idx]!.calendar.cgColor).withAlphaComponent(0.75)
                }
            }
        }
    }
}

struct MainCalendarCellItem {
    var events: [EKEvent]?
    var date: Date?
    var dateFormatter = DateFormatter()
    var eventsToIndicate: [EKEvent?] = [nil, nil, nil]
    
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
