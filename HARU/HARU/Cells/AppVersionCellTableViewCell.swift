//
//  AppVersionCellTableViewCell.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/04/10.
//

import UIKit

class AppVersionCellTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
