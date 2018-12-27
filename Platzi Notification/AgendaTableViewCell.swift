//
//  AgendaTableViewCell.swift
//  Platzi Notification
//
//  Created by Nicolás Rodríguez on 20/12/17.
//  Copyright © 2017 Nicolás Rodríguez. All rights reserved.
//

import UIKit

enum AgendaItemTypeEnum: String {
	case courseLive = "course_live"
	case courseLaunch = "course_launch"
}

class AgendaTableViewCell: UITableViewCell {

    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventNameLabel: UILabel!
	@IBOutlet weak var EventDescriptiion: UILabel!
	@IBOutlet weak var EventTimeLabel: UILabel!
	
	@IBOutlet weak var CourseLaunchLabel: UILabel!
	@IBOutlet weak var LiveSessionsLabel: UILabel!
	@IBOutlet weak var PlatziLiveLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func agendaItemType(type: String) {
		if type == "course_launch" {
			CourseLaunchLabel.isHidden = false
			LiveSessionsLabel.isHidden = true
			PlatziLiveLabel.isHidden = true
		} else if type == "course_live" {
			CourseLaunchLabel.isHidden = true
			LiveSessionsLabel.isHidden = false
			PlatziLiveLabel.isHidden = false
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
