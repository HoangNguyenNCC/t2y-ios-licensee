//
//  ReminderCell.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 19/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var trailerDetails: UILabel!
    @IBOutlet weak var trailerName: UILabel!
    @IBOutlet weak var trailerImage: UIImageView!
    @IBOutlet weak var reminderCard: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
