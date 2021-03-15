//
//  AddEventTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/15.
//

import UIKit

class AddEventTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

struct AddEventTableViewItem {
    var titleLabelString: String?
    var contentLabelString: String?
}
