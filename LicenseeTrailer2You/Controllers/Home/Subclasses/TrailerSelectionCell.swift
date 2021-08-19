//
//  TrailerSelectionCell.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 22/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

class TrailerSelectionCell: UITableViewCell {

    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var trailerDetails: UILabel!
    @IBOutlet weak var trailerImage: UIImageView!
    @IBOutlet weak var vinLabel: UILabel!
    
    
    override func prepareForReuse() {
        self.trailerView.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
