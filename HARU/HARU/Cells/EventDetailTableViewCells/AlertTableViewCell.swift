//
//  AlertTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/03/30.
//

import UIKit

class AlertTableViewCell: UITableViewCell {
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
        alertStatusLabel.text = "없음"
    }
}
