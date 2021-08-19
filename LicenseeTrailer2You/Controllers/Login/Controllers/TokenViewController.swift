//
//  TokenViewController.swift
//  LicenseeTrailer2You
//
//  Created by Aaryan Kothari on 29/06/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class TokenViewController: UIViewController {
    
    @IBOutlet weak var tokenTextField: UITextField!
    
    @IBOutlet weak var signUpBttn: UIButton!
    
    var employee : Employee?
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        if let token = tokenTextField.text {
            employeeSignup(token)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let otpViewController = segue.destination as? SignupVerificationViewController {
            otpViewController.type = .employee
                     }
    }
    
    func employeeSignup(_ token : String){
        self.view.endEditing(true)
        if let employee = self.employee {
            signUpBttn.disable()
            ProgressHUD.show("Signin up")
            PostController.shared.signup(employee,token: token) { (status, message) in
                if status {
                    ProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        Constant.loginDefaults?.set(employee.mobile, forKey: Keys.signUpMobile)
                        Constant.loginDefaults?.set(employee.address.country, forKey: Keys.signUpCountry)
                        self.performSegue(withIdentifier: "employeeotp", sender: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.signUpBttn.enable()
                        ProgressHUD.showError(message ?? "Error")
                    }
                }
            }
            
        } else {
            ProgressHUD.showError("Please try again")
        }
    }
        
}
