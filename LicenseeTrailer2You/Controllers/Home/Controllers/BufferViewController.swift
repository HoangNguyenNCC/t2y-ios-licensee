//
//  BufferViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 21/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit

var controller = 1

class BufferViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAlert()
    }
    
    @objc func showAlert() {
        
        let alert = UIAlertController(title: "Add Data", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        if Defaults.getPrivileges(key: AccessCategory.TRAILER.localized(), access: AccessType.ADD.rawValue) {
            alert.addAction(UIAlertAction(title: "Add Trailer", style: .default , handler:{ (UIAlertAction) in
                self.performSegue(withIdentifier: "addTrailer", sender: Any?.self)
            }))
        }
        
        if Defaults.getPrivileges(key: AccessCategory.UPSELL.localized(), access: AccessType.ADD.rawValue) {
            alert.addAction(UIAlertAction(title: "Add Upsell Item", style: .default , handler:{ (UIAlertAction) in
                self.performSegue(withIdentifier: "addUpsell", sender: Any?.self)
            }))
        }
        
        if Defaults.getPrivileges(key: AccessCategory.EMPLOYEE.localized(), access: AccessType.ADD.rawValue) {
            alert.addAction(UIAlertAction(title: "Add Team Members", style: .default , handler:{ (UIAlertAction)in
                self.performSegue(withIdentifier: "addMembers", sender: Any?.self)
            }))
        }
        
        if Defaults.getPrivileges(key: AccessCategory.BLOCK.localized(), access: AccessType.ADD.rawValue) {
            alert.addAction(UIAlertAction(title: "Add Booking", style: .default , handler:{ (UIAlertAction)in
                self.performSegue(withIdentifier: "addBooking", sender: Any?.self)
            }))
        }
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:{ (UIAlertAction)in
            if controller == 1 {
                self.performSegue(withIdentifier: "backToMyTrailers", sender: Any?.self)
            } else if controller == 2 {
                self.performSegue(withIdentifier: "backToRequests", sender: Any?.self)
            } else if controller == 3 {
                self.performSegue(withIdentifier: "backToReminders", sender: Any?.self)
            } else if controller == 4 {
                self.performSegue(withIdentifier: "backToProfile", sender: Any?.self)
            }
        }))
        
        self.present(alert, animated: true)
    }
}
