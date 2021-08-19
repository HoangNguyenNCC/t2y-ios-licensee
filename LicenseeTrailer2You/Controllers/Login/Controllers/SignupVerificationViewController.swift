//
//  SignupVerificationViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 30/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class SignupVerificationViewController: UIViewController {

    @IBOutlet weak var verifyBttn: UIButton!
    @IBOutlet weak var otpView: OTPStackView!
    
    let otpStackView = OTPStackView()
    var type :  Signuptype = .owner
    var mobile : String?
    var country : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == .employee{
            sendOTP()
        }
        
        if type == .licensee{
            sendOTP()
        }
        
        overrideUserInterfaceStyle = .light
        otpView.addSubview(otpStackView)
        otpStackView.delegate = self
        otpStackView.heightAnchor.constraint(equalTo: otpView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpView.centerYAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        verifyBttn.layer.cornerRadius = 14
    }

    @IBAction func verifyBttnTapped(_ sender: Any) {
        let mobile = self.mobile ?? (Constant.loginDefaults?.value(forKey: Keys.signUpMobile) as? String ?? "")
        let country = self.country ?? (Constant.loginDefaults?.value(forKey: Keys.signUpCountry) as? String ?? "")
        let verify = OTPVerification(mobile: mobile, country: country, otp: otpView.getOTP(), user: self.type.stringValue)
        let verificationObject = try! JSONEncoder().encode(verify)
        verifyBttn.disable()
        PostController.shared.verifyOTP(verificationObject: verificationObject) { (message, status) in
            if status {
                DispatchQueue.main.async {
                    Defaults.loginDefaults?.set(true, forKey: Keys.verificationStatus)
                    ProgressHUD.showSuccess(message)
                    if self.type == .licensee {
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        self.performSegue(withIdentifier: "close", sender: Any?.self)
                    }
                }
            } else {
                ProgressHUD.showError(message)
                DispatchQueue.main.async {
                    self.verifyBttn.enable()
                }
            }
        }
    }
   
    @IBAction func resendBttnTapped(_ sender: Any) {
        sendOTP()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        if type == .licensee{
            self.dismiss(animated: true, completion: nil)
        }else  {
        performSegue(withIdentifier: "otpout", sender: nil)
        }
    }
    
    
    func sendOTP() {
        let mobile = self.mobile ?? (Defaults.loginDefaults?.value(forKey: Keys.signUpMobile) as? String ?? "")
        let country = self.country ?? (Defaults.loginDefaults?.value(forKey: Keys.signUpCountry) as? String ?? "")
        let resend = OTPResend(mobile: mobile, country: country, user: self.type.stringValue)
        
        let resendObject = try! JSONEncoder().encode(resend)
        PostController.shared.resendOTP(resendObject: resendObject) { (message, status) in
            if status {
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess(message)
                }
            } else {
                ProgressHUD.showError(message)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension SignupVerificationViewController: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        verifyBttn.alpha = 1
        verifyBttn.isUserInteractionEnabled = true
    }
}
