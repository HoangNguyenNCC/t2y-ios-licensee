//
//  FinanceCell.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 09/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

class FinanceCell: UITableViewCell {

    @IBOutlet weak var financeCard: UIView!
    @IBOutlet weak var trailerPrice: UILabel!
    @IBOutlet weak var trailerName: UILabel!
    @IBOutlet weak var trailerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
