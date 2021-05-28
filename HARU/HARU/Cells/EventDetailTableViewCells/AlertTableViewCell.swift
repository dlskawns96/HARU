//
//  AlertTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/30.
//

import UIKit

class AlertTableViewCell: UITableViewCell {
    let tails = ["이벤트 당시", "분 전", "시간 전", "일 전"]
    let times = [0, 60, 60 * 60, 60 * 60 * 24]
    
    @IBOutlet weak var alertStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        if EventDetailViewController.event.hasAlarms {
            alertStatusLabel.text = AlertTextGenerator().getAlertText(offset: EventDetailViewController.event.alarms!.first!.relativeOffset)
//
//            for idx in stride(from: times.count - 1, to: 0, by: -1) {
//                if -Int(EventDetailViewController.event.alarms!.first!.relativeOffset) >= times[idx] {
//                    alertStatusLabel.text = String(-Int(EventDetailViewController.event.alarms!.first!.relativeOffset) / times[idx]) + tails[idx]
//                    break
//                }
//            }
            
        } else {
            alertStatusLabel.text = "없음"
        }
        
        self.accessoryType = .disclosureIndicator
    }
}
