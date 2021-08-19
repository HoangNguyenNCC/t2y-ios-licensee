//
//  ResetPasswordViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 20/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class ResetPasswordViewController: UIViewController {

    var token = ""
    
    @IBOutlet weak var resetBttn: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidLayoutSubviews() {
        passwordTextField.formatField()
        confirmPasswordTextField.formatField()
        resetBttn.layer.cornerRadius = 14
    }
    
    @IBAction func resetBttnTapped(_ sender: Any) {
        if passwordTextField.text?.isEmpty ?? true || confirmPasswordTextField.text?.isEmpty ?? true {
            ProgressHUD.showError(Strings.textFieldEmpty)
        } else {
                passwordReset()
        }
    }
    
    func passwordReset() {
        resetBttn.disable()
        ProgressHUD.show("Changing Password")
        let passwordReset = ResetPassword(token: token, password: passwordTextField.text!)
        let passwordResetObject = try! JSONEncoder().encode(passwordReset)
        
        PostController.shared.resetPassword(resetPasswordObject: passwordResetObject) { (message, status) in
            if status {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "close", sender: Any?.self)
                }
            } else {
                DispatchQueue.main.async {
                    self.resetBttn.enable()
                    ProgressHUD.showError(message)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
