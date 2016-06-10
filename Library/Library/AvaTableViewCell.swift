//
//  AvaTableViewCell.swift
//  Library
//
//  Created by Johnson Zhou on 5/23/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit

class AvaTableViewCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
