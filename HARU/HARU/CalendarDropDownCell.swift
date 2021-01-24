//
//  CalendarDropDownCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/01/20.
//

import UIKit
import DropDown

class CalendarDropDownCell: DropDownCell {

    @IBOutlet weak var CalendarColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
