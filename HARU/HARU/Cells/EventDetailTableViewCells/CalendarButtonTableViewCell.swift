//
//  CalendarButtonTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/25.
//

import UIKit
import EventKit

class CalendarButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonContentLabel: UILabel!
    @IBOutlet weak var calendarView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("@@@@")
        configureCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        print("@@@@")
        configureCell()
    }
    
    func configureCell() {
        buttonContentLabel.text = EventDetailViewController.event.calendar.title
        calendarView.backgroundColor = UIColor(cgColor: EventDetailViewController.event.calendar.cgColor)
    }
}
