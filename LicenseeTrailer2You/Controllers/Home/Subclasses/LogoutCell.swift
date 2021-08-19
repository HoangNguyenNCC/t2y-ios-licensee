//
//  FinancialCell.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 26/06/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

protocol LogoutDelegate{
    func logoutTapped()
}

class LogoutCell: UITableViewCell {
    
    var delegate:LogoutDelegate!
    
    @IBAction func logout(_ sender: Any) {
        self.delegate?.logoutTapped()
    }
}
