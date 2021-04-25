//
//  AlertTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/30.
//

import UIKit

class AlertTableViewCell: UITableViewCell {
    let items = [["없음"], ["이벤트 당시", "5분 전", "10분 전", "15분 전", "30분 전", "1시간 전", "2시간 전", "1일 전", "2일 전", "1주 전"]]
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
        if let index = EventDetailViewController.event.getAlarmIndex() {
            alertStatusLabel.text = items[index.section][index.row]
        } else {
            alertStatusLabel.text = "없음"
        }
        
        self.accessoryType = .disclosureIndicator
    }
}
