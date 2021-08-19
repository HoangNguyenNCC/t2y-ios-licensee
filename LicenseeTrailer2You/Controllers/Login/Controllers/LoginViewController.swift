//
//  LoginViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 02/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD
import NotificationCenter

class LoginViewController: UIViewController {
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {}
    @IBAction func unwindAfterSignUp(_ unwindSegue: UIStoryboardSegue) {}
    @IBAction func unwindAfterForgot(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBOutlet weak var signUpBttn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var loginBttn: UIButton!
    
    var details : Set<String> = []
    var message = "Enter the below details"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        let string1 = "DON'T HAVE AN ACCOUNT?"
        let string2 = "SIGN UP"
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        let att = NSMutableAttributedString(string: "\(string1) \(string2)");
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: string1.count))
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "darkYellow")!, range: NSRange(location: string1.count+1, length: string2.count))
        signUpBttn.setAttributedTitle(att, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        loginBttn.layer.cornerRadius = CGFloat(14)
        usernameField.formatField()
        passwordField.formatField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
    
    func performLogin() {
        ProgressHUD.show("Hang on! Logging you in")
        let token = Defaults.fcmToken()
        let loginDetails = Login(email: usernameField.text ?? "", password: passwordField.text ?? "", fcmDeviceToken: token)
        let loginObject = (try? JSONEncoder().encode(loginDetails))!
        loginBttn.disable()
        PostController.shared.login(loginObject: loginObject) { (loginResponse, status, error) in
            print("login status:",status)
            if status {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(loginResponse?.employeeObj) {
                    Constant.loginDefaults?.set(encoded, forKey: Keys.userObject)
                }
                if let encoded = try? encoder.encode(loginResponse?.licenseeObj) {
                    Constant.loginDefaults?.set(encoded, forKey: Keys.licenseeObject)
                }
                DispatchQueue.main.async {
                    Constant.loginDefaults?.set(self.usernameField.text!, forKey: Keys.userEmail)
                    Constant.loginDefaults?.set(self.passwordField.text!, forKey: Keys.userPassword)
                    Constant.loginDefaults?.set(true, forKey: Keys.isLoggedIn)
                    Constant.loginDefaults?.set(loginResponse?.token, forKey: Keys.userToken)
                    
                    ProgressHUD.dismiss()
                    let mainStoryboard = AppStoryboard.main.instance
                    if let initialViewController = mainStoryboard.instantiateInitialViewController() {
                        self.view.window?.rootViewController = initialViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loginBttn.enable()
                    ProgressHUD.showError(error!)
                }
            }
        }
    }
    
    @IBAction func loginBttnTapped(_ sender: Any) {
        self.view.endEditing(true)
        if details.count == 2 {
            performLogin()
        } else {
            ProgressHUD.showError(message)
        }
    }
    
    @IBAction func signUpBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignUp", sender: Any?.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case usernameField:
            let text = usernameField.text ?? ""
            if text.isValidEmail() {
                details.insert("mail")
            } else {
                message = "Invalid mail"
                ProgressHUD.showError(message)
            }
            
        case passwordField:
            let text = passwordField.text ?? ""
            if text.count > 0 {
                details.insert("password")
            }
        default:
            break
        }
    }
}
