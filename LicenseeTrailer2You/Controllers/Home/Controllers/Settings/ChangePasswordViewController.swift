//
//  ChangePasswordViewController.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 09/07/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ProgressHUD.dismiss()
    }
    
    
    @IBAction func resetTapped(_ sender: UIButton) {
        if check() {
            let object = ChangePassword(newPassword: newPasswordTextField.text!, oldPassword: passwordTextField.text!)
            
            let changePasswordObject = try! JSONEncoder().encode(object)
            
            ProgressHUD.show("Changing Password")
            
            PostController.shared.changePassword(changePasswordObject: changePasswordObject) { (message, status) in
                if status {
                    DispatchQueue.main.async {
                        ProgressHUD.showSuccess(message)
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        ProgressHUD.showError(message)
                    }
                }
            }
        }
    }
    
    func check()-> Bool {
        let text = passwordTextField.text ?? ""

        if passwordTextField.text?.isEmpty ?? false{
            ProgressHUD.showError("Enter password")
            return false
        }
        if newPasswordTextField.text?.isEmpty ?? false{
            ProgressHUD.showError("Enter new password")
            return false
        }
        if !text.isValidPassword() {
            ProgressHUD.showError("Invalid Password. Must contain 1 Uppercase, 1 Lowercase and a special character")
            return false
        }
        return true
    }
}
