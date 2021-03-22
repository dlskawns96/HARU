//
//  EventCollectionTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/21.
//

import UIKit
import EventKit

class EventCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var eventDayLabel: UILabel?
    @IBOutlet weak var eventTitleLabel: UILabel?
    @IBOutlet weak var calendarColorView: UIView?
    @IBOutlet weak var shadowView: ShadowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureCell(with model: EventCollectionTableViewItem) {
        eventDayLabel?.text = model.eventDayString
        eventTitleLabel?.text = model.eventTitleString
        calendarColorView?.backgroundColor = model.eventColor
        shadowView.shadowColor = model.eventColor
    }
    
    static var cellIdentifier: String {
        return String(describing: EventCollectionTableViewCell.self)
    }
}

class EventCollectionTableViewItem {
    var calendar = Calendar.current
    var event: EKEvent?
    
    init(event: EKEvent) {
        self.event = event
    }
    
    var eventDayString: String? {
        return String(calendar.component(.day, from: (event?.startDate)!))
    }
    
    var eventMonthString: String? {
        return String(calendar.component(.month, from: (event?.startDate)!)) + "월"
    }
    
    var eventTitleString: String? {
        return event?.title
    }
    
    var eventColor: UIColor? {
        return UIColor(cgColor: (event?.calendar.cgColor)!).withAlphaComponent(0.5)
    }
}
