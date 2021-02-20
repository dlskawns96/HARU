//
//  SetCalendarTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/02/18.
//

import UIKit

class SetCalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarColorView: UIView!
    @IBOutlet weak var calendarTitleBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
