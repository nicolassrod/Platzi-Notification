//
//  AgendaTableViewCell.swift
//  Platzi Notification
//
//  Created by Nicolás Rodríguez on 20/12/17.
//  Copyright © 2017 Nicolás Rodríguez. All rights reserved.
//

import UIKit

class AgendaTableViewCell: UITableViewCell {

    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var EventTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
