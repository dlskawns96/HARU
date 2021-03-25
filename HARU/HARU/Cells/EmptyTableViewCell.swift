//
//  EmptyTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/24.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
