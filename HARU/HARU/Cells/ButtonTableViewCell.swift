//
//  ButtonTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/25.
//

import UIKit
import EventKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonTitleLabel: UILabel!
    @IBOutlet weak var buttonContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(with item: ButtonTableViewItem) {
        buttonTitleLabel.text = item.buttonTitleString
        buttonContentLabel.text = item.buttonContentString
        
        if item.isCalendar {
            let view = UIView()
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.trailingAnchor.constraint(equalTo: self.buttonContentLabel.leadingAnchor, constant: -10).isActive = true
            view.centerYAnchor.constraint(equalTo: self.buttonContentLabel.centerYAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 10).isActive = true
            view.widthAnchor.constraint(equalToConstant: 10).isActive = true
            view.backgroundColor = item.eventUIColor
        }
    }
}

struct ButtonTableViewItem {
    var event: EKEvent?
    var isCalendar = false
    var isAlarmOn = false
    
    var buttonTitleString: String?
    var buttonContentString: String? {
        if isCalendar { return event?.calendar.title }
        if isAlarmOn { return "있음" }
        if !isAlarmOn { return "없음" }
        return ""
    }
    
    var eventUIColor: UIColor {
        return UIColor(cgColor: event!.calendar.cgColor)
    }
}
