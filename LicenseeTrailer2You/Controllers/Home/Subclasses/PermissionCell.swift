//
//  PermissionCell.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 27/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

class PermissionCell: UITableViewCell {

    @IBOutlet weak var permissionCard: UIView!
    @IBOutlet weak var permissionLabel: UILabel!
    @IBOutlet weak var addIndicator: UIView!
    @IBOutlet weak var viewIndicator: UIView!
    @IBOutlet weak var updateIndicator: UIView!
    @IBOutlet weak var deleteIndicator: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addIndicator.isHidden = true
        viewIndicator.isHidden = true
        updateIndicator.isHidden = true
        deleteIndicator.isHidden = true

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            
        }
    }
}
