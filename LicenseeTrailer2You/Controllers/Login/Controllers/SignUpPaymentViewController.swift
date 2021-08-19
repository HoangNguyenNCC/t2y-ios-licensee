//
//  SignUpPaymentViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 16/04/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD

class SignUpPaymentViewController: UIViewController {
    
    @IBOutlet weak var operatingTo: UITextField!
    @IBOutlet weak var operatingFrom: UITextField!
    @IBOutlet weak var mondayBttn: UIButton!
    @IBOutlet weak var tuesdayBttn: UIButton!
    @IBOutlet weak var wednesdayBttn: UIButton!
    @IBOutlet weak var thursdayBttn: UIButton!
    @IBOutlet weak var fridayBttn: UIButton!
    @IBOutlet weak var saturdayBttn: UIButton!
    @IBOutlet weak var sundayBttn: UIButton!
    @IBOutlet weak var closeBttn: UIButton!
    @IBOutlet weak var accountNumberfield: UITextField!
    @IBOutlet weak var bsbNumberfield: UITextField!
    @IBOutlet weak var taxIdNumberField: UITextField!
    @IBOutlet weak var signUpBttn: UIButton!
    
    var country = ""
    var datePicker = UIDatePicker()
    var activeTextField = UITextField()
    var days: [String] = []
    var employee: Employee? = nil
    var licensee: Licensee? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        operatingFrom.delegate = self
        operatingTo.delegate = self
        taxIdNumberField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        overrideUserInterfaceStyle = .light
        accountNumberfield.formatField()
        bsbNumberfield.formatField()
        taxIdNumberField.formatField()
        signUpBttn.layer.cornerRadius = 14
        self.operatingFrom.formatField()
        self.operatingTo.formatField()
        mondayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        tuesdayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        wednesdayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        thursdayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        fridayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        saturdayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        sundayBttn .layer.cornerRadius = mondayBttn.frame.width/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func monday(_ sender: Any) {
        let day = "Monday"
        if days.contains(day) {
            days = days.filter { $0 != day }
            mondayBttn.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        } else {
            days.append(day)
            mondayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    @IBAction func tuesday(_ sender: Any) {
        let day = "Tuesday"
        if days.contains(day) {
            days = days.filter { $0 != day }
            tuesdayBttn.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        } else {
            days.append(day)
            tuesdayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    @IBAction func wednesday(_ sender: Any) {
        let day = "Wednesday"
        if days.contains(day) {
            days = days.filter { $0 != day }
            wednesdayBttn.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        } else {
            days.append(day)
            wednesdayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    @IBAction func thursday(_ sender: Any) {
        let day = "Thursday"
        if days.contains(day) {
            days = days.filter { $0 != day }
            thursdayBttn.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        } else {
            days.append(day)
            thursdayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    @IBAction func friday(_ sender: Any) {
        let day = "Friday"
        if days.contains(day) {
            days = days.filter { $0 != day }
            fridayBttn.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        } else {
            days.append(day)
            fridayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    @IBAction func saturday(_ sender: Any) {
        let day = "Saturday"
        if days.contains(day) {
            days = days.filter { $0 != day }
            saturdayBttn.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        } else {
            days.append(day)
            saturdayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    @IBAction func sunday(_ sender: Any) {
        let day = "Sunday"
        if days.contains(day) {
            days = days.filter { $0 != day }
            sundayBttn.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        } else {
            days.append(day)
            sundayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    func setupDatePicker(textField: UITextField) {
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 216))
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 15
        datePicker.backgroundColor = .secondarySystemBackground
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(timeSelected))
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        toolBar.barTintColor = .secondarySystemBackground
        toolBar.sizeToFit()
        
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
    }
    
    @objc func timeSelected() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HHmm"
        activeTextField.text = dateformatter.string(from: datePicker.date)
        activeTextField.resignFirstResponder()
    }
    
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        // self.performSegue(withIdentifier: "close", sender: Any?.self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBttnTapped(_ sender: Any) {
        if(accountNumberfield.text?.isEmpty ?? true || bsbNumberfield.text?.isEmpty ?? true || operatingFrom.text?.isEmpty ?? true || operatingTo.text?.isEmpty ?? true || taxIdNumberField.text?.isEmpty ?? true) {
            ProgressHUD.showError(Strings.textFieldEmpty)
        } else {
            licensee?.accountNumber = accountNumberfield.text!
            licensee?.bsbNumber = bsbNumberfield.text!
            licensee?.taxId = taxIdNumberField.text!
            licensee?.workingDays = days
            licensee?.workingHours = convertToGMT(operatingFrom.text!) + "-" + convertToGMT(operatingTo.text!)
            signUp()
        }
    }
    
    func convertToGMT(_ time : String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        formatter.timeZone = .current
        let date = formatter.date(from: time)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = date {
            return formatter.string(from: date)
        }else{
            return time
        }
    }
    
    func signUp() {
        signUpBttn.disable()
        let signUpData = SignUp(employee: employee!, licensee: licensee!)
        ProgressHUD.show("Signin up")
        PostController.shared.signup(signUpData) { (status , message) in
            if status {
                ProgressHUD.dismiss()
                DispatchQueue.main.async {
                    Constant.loginDefaults?.set(self.employee?.mobile, forKey: Keys.signUpMobile)
                    Constant.loginDefaults?.set(self.country, forKey: Keys.signUpCountry)
                    self.performSegue(withIdentifier: "verify", sender: Any?.self)
                }
            } else {
                DispatchQueue.main.async {
                    self.signUpBttn.enable()
                    ProgressHUD.showError(message ?? "Error")
                }
            }
        }
    }
}

extension SignUpPaymentViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == operatingFrom || textField == operatingTo {
            activeTextField = textField
            setupDatePicker(textField: textField)
        }
    }
}
