//
//  BookFloorTableViewCell.swift
//  Library
//
//  Created by Johnson Zhou on 5/27/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit

class BookFloorTableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
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
