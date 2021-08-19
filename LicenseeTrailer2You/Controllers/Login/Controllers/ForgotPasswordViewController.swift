//
//  ForgotPasswordViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 20/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var verifyEmailBttn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidLayoutSubviews() {
        emailTextField.formatField()
        verifyEmailBttn.layer.cornerRadius = 14
    }
    
    @IBAction func backToLoginBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: Any?.self)
    }
    
    @IBAction func verifyEmailBttnTapped(_ sender: Any) {
        if emailTextField.text?.isEmpty ?? true {
            ProgressHUD.showError(Strings.textFieldEmpty)
        } else {
            forgotPass()
        }
    }
    
    func forgotPass() {
        verifyEmailBttn.disable()
        ProgressHUD.show("Sending OTP")
        let forgotPasswordBody = ForgotPassword(email: emailTextField.text!)
        let forgotPasswordObject = try! JSONEncoder().encode(forgotPasswordBody)
        
        PostController.shared.forgotPassword(forgotPasswordObject: forgotPasswordObject) { (message, status) in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }
            if status {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "enterOTP", sender: Any?.self)
                }
            } else {
                DispatchQueue.main.async {
                    self.verifyEmailBttn.enable()
                    ProgressHUD.showError(message)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResetPasswordViewController{
            let vc = segue.destination as! ResetPasswordViewController
           // vc.email = emailTextField.text!
        }
    }
}
