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
    @IBOutlet var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startDateLabel.numberOfLines = 2
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        configureCell()
    }
    
    func configureCell() {
        eventTitleLabel.text = EventDetailViewController.event.title
        
        if EventDetailViewController.event.startDate.difference(between: EventDetailViewController.event.endDate) == 0 {
            
            startDateLabel.text = EventDetailViewController.event.startDate.toString(dateFormat: "yyyy년 MM월 dd일 \na hh시 mm분 ~ ") + EventDetailViewController.event.endDate.toString(dateFormat: "a hh시 mm분")
        } else {
            startDateLabel.text = EventDetailViewController.event.startDate.toString(dateFormat: "yyyy년 MM월 dd일 hh시 mm분 ~\n ") + EventDetailViewController.event.endDate.toString(dateFormat: " yyyy년 MM월 dd일 hh시 mm분")
        }
        
        if let location = EventDetailViewController.event.structuredLocation {
            locationLabel.text = location.title
        } else {
            locationLabel.text = ""
        }
    }
}
