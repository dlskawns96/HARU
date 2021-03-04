//
//  ScheduleTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/03.
//

import UIKit
import EventKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var eventTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(with item: ScheduleTableViewItem) {
        eventTitleLabel.text = item.eventTitle
        self.layer.borderColor = item.eventColor
        self.layer.borderWidth = 2
        self.backgroundColor = item.eventUIColor
    }
}

struct ScheduleTableViewItem {
    var event: EKEvent
    
    var eventTitle: String? {
        return event.title
    }
    var eventColor: CGColor? {
        return event.calendar.cgColor
    }
    
    var eventUIColor: UIColor? {
        return UIColor(cgColor: eventColor!).withAlphaComponent(0.25)
    }
}
