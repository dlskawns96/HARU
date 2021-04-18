//
//  LocationTableViewCell.swift
//  HARU
//
//  Created by Lee Nam Jun on 2021/04/18.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
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
    
    private func configureCell() {
        locationLabel.text = EventDetailViewController.event.location
    }

}
