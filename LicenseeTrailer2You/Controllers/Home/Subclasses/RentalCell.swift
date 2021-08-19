//
//  RentalCell.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 08/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

class RentalCell: UITableViewCell {

    @IBOutlet weak var rentalExpiryDate: UILabel!
    @IBOutlet weak var rentalDate: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var rentalCustomer: UIImageView!
    @IBOutlet weak var rentalCard: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
