//
//  OTPViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 19/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//
import UIKit
import ProgressHUD

class OTPViewController: UIViewController {

    @IBOutlet weak var verifyBttn: UIButton!
    @IBOutlet weak var otpContainerView: OTPStackView!
    
    let otpStackView = OTPStackView()
    var token = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        verifyBttn.alpha = 0.6
        verifyBttn.isUserInteractionEnabled = false
        verifyBttn.layer.cornerRadius = 14
        otpContainerView.addSubview(otpStackView)
        otpStackView.delegate = self
        otpStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpContainerView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        verifyBttn.layer.cornerRadius = 14
    }
    
    @IBAction func verifyOtpBttnTapped(_ sender: Any) {
        if(otpStackView.getOTP().isEmpty) {
            ProgressHUD.showError(Strings.textFieldEmpty)
        } else {
            verifyOTP()
        }
    }
    
    
    @IBAction func backtapped(_ sender: Any) {
        self.performSegue(withIdentifier: "resetPassword", sender: Any?.self)
    }
    
    func verifyOTP() {
        verifyBttn.disable()
        ProgressHUD.show("Verifying OTP")
        let verifyBody = VerifyOTP(otp: otpStackView.getOTP(), email: email)
        let verifyObject = try! JSONEncoder().encode(verifyBody)
        
        PostController.shared.verifyOTP(verificationObject: verifyObject) { (message, status) in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                if status {
                    self.performSegue(withIdentifier: "resetPassword", sender: Any?.self)
                } else {
                    self.verifyBttn.enable()
                    ProgressHUD.showError(message)
                }
            }
        }
    }
    
    @IBAction func backToLoginTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "loginFromOTP", sender: Any?.self)
    }
    
    @IBAction func clickedForHighlight(_ sender: UIButton) {
        otpStackView.setAllFieldColor(isWarningColor: true, color: .yellow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResetPasswordViewController {
            let vc = segue.destination as! ResetPasswordViewController
            vc.token = token
        }
    }
    
}

extension OTPViewController: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        verifyBttn.alpha = 1
        verifyBttn.isUserInteractionEnabled = true
    }
}

class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    override public func deleteBackward(){
        if text == "" {
            previousTextField?.becomeFirstResponder()
        }
    }
}



