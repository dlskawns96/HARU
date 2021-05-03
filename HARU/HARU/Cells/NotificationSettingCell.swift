//
//  NotificationSettingCell.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/05.
//

import UIKit

class NotificationSettingCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBAction func notificationSwitchClicked(_ sender: Any) {
        UserDefaults.standard.set(notificationSwitch.isOn, forKey: "NotificationAllowState")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
