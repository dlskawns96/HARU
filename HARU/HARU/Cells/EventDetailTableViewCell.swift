//
//  EventDetailTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/25.
//

import UIKit

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

}
