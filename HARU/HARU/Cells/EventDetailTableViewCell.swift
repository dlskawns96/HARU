//
//  EventDetailTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/25.
//

import UIKit
import EventKit

class EventDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with item: EventDetailTableViewItem) {
        eventTitleLabel.text = item.eventTitleString
        startDateLabel.text = item.eventStartDateString
        endDateLabel.text = item.eventEndDateString
    }
}

struct EventDetailTableViewItem {
    let dateFormatter = DateFormatter()
    var event: EKEvent?
    
    init() {
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE a HH시 mm분"
    }
    
    var eventTitleString: String? {
        return event?.title
    }
    
    var eventStartDateString: String? {
        return dateFormatter.string(from: (event?.startDate)!)
    }
    
    var eventEndDateString: String? {
        return "~" + dateFormatter.string(from: (event?.endDate)!)
    }
}
