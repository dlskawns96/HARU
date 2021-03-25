//
//  DiaryCollectionTableViewCell.swift
//  HARU
//
//  Created by Cho Si Yeon on 2021/03/25.
//

import UIKit

class DiaryCollectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shadowView: ShadowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
