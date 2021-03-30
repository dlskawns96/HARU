//
//  CalendarSelectCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/30.
//

import UIKit
import EventKit

class CalendarSelectCell: UITableViewCell {
    @IBOutlet var calendarView: UIView!
    @IBOutlet var calendarTitleLabel: UILabel!
    @IBOutlet var checkMarkImage: UIImageView!
    var calendar: EKCalendar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        checkIfSelected()
    }
    
    func checkIfSelected() {
        if calendar.calendarIdentifier ==  EventDetailViewController.event.calendar.calendarIdentifier {
            checkMarkImage.isHidden = false
        } else {
            checkMarkImage.isHidden = true
        }
    }
    
    func configureCell() {
        calendarView.backgroundColor = UIColor(cgColor: calendar.cgColor)
        calendarTitleLabel.text = calendar.title
        checkIfSelected()
    }

}
