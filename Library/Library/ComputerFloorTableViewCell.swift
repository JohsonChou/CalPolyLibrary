//
//  ComputerFloorTableViewCell.swift
//  Library
//
//  Created by Johnson Zhou on 5/24/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit

class ComputerFloorTableViewCell: UITableViewCell {

    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        statusView.clipsToBounds = true
        statusView.layer.cornerRadius = statusView.layer.frame.width / 2.0
        // Configure the view for the selected state
    }

}
