//
//  RequestCell.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 21/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

protocol RequestCellDelegate : class {
    func didPressAccessoryButton(_ tag: Int)
    func didPressPrimaryButton(_ tag: Int)
}

class RequestCell: UITableViewCell {
    
     var cellDelegate: RequestCellDelegate?

    @IBOutlet weak var deadlineDescription: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var trailerDetails: UILabel!
    @IBOutlet weak var trailerName: UILabel!
    @IBOutlet weak var trailerImage: UIImageView!
    @IBOutlet weak var requestCard: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.deadline.text = ""
        self.deadlineDescription.text = ""
        self.trailerImage.image = nil
    }
    
    @IBAction func accessoryBttnTapped(_ sender: UIButton) {
        cellDelegate!.didPressAccessoryButton(sender.tag)
    }
    
    @IBAction func primaryBttnTapped(_ sender: UIButton) {
        cellDelegate!.didPressPrimaryButton(sender.tag)
    }
}
