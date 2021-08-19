//
//  SignUpViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 02/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD
import MobileCoreServices
import NotificationCenter

class SignUpViewController: UIViewController {
    
    var license: DriverLicense?
    var addressCore: AddressRequest?
    var profileImage = ""
    var imagePicker = UIImagePickerController()
    var type :  Signuptype = .owner
    var datePickerView : UIDatePicker = UIDatePicker()
    var DOB = Date()
    
    
    var details : Set<String> = []
    var message = "Enter the below details"
    
    @IBAction func unwindToSignUp(_ unwindSegue: UIStoryboardSegue) {}
    
    @IBOutlet weak var DLTextField: UITextField!
    @IBOutlet weak var logoBttn: UIButton!
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var AddressTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextField.delegate = self
        passwordTextField.delegate = self
        mobileTextField.delegate = self
        DLTextField.delegate = self
        AddressTextField.delegate = self
        dobTextField.delegate = self
        dobTextField.inputView = datePickerView
        
        datePickerView.maximumDate = Date().addYears(n: -16)
        if #available(iOS 13.4, *) { datePickerView.preferredDatePickerStyle = .wheels }

    }
    
    override func viewDidLayoutSubviews() {
        logoBttn.layer.cornerRadius = logoBttn.frame.width/2
        logoBttn.layer.borderColor = UIColor.black.cgColor
        logoBttn.layer.borderWidth = 2
        logoBttn.clipsToBounds = true
        self.nameTextField.formatField()
        self.passwordTextField.formatField()
        self.mobileTextField.formatField()
        self.dobTextField.formatField()
        self.emailTextField.formatField()
        self.confirmPasswordTextField.formatField()
        
        let prefix = UILabel()
        prefix.text = "  +61 "
        prefix.font = UIFont(name: "Avenir Next Demi Bold", size: 12)
        prefix.textColor = .black
        prefix.sizeToFit()
        
        mobileTextField.leftView = prefix
        mobileTextField.leftViewMode = .always
        
        self.nextBttn.layer.cornerRadius = 14
        let title = type == .owner ? "N E X T : B U S I N E S S" : "TOKEN VERIFICATION"
        self.nextBttn.setTitle(title, for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is SignUpBViewController {
            let vc = segue.destination as! SignUpBViewController
            let employee = Employee(name: nameTextField.text!,
                                    mobile: mobileTextField.text!, //TODO
                                    email: emailTextField.text!,
                                    password: passwordTextField.text!,
                                    photo: profileImage,
                                    dob: DOB.getDOB(),
                driverLicense: license!,
                address: addressCore!)
            
            vc.employeeObj = employee
        }
        
        if let LicenseVC = segue.destination as? DLViewController {
            nameTextField.resignFirstResponder()
            mobileTextField.resignFirstResponder()
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.resignFirstResponder()
            DLTextField.resignFirstResponder()
            LicenseVC.delegate = self
            LicenseVC.license = self.license
        }
        
        if let addressVC = segue.destination as? AddressViewController {
            addressVC.delegate = self
        }
        
        if let tokenVC = segue.destination as? TokenViewController {
            let employee = Employee(name: nameTextField.text!,
                                    mobile: "91"+mobileTextField.text!,
                                    email: emailTextField.text!,
                                    password: passwordTextField.text!,
                                    photo: profileImage,
                                    dob : DOB.getDOB(),
                driverLicense: license!,
                address: addressCore!)
            tokenVC.employee = employee
        }
    }
    
    @IBAction func nameInfo(_ sender: Any) {
        
    }
    
    @IBAction func cancelBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "backToLogin", sender: Any?.self)
    }
    
    @IBAction func nextBttnTapped(_ sender: Any) {
        self.view.endEditing(true)
        signingUp()
    }
    
    @IBAction func logoTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Import Profile Picture", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction) in
            self.importPicture(.camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Photos", style: .default , handler:{ (UIAlertAction) in
            self.importPicture(.photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction) in
            
        }))
        self.present(alert, animated: true)
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
    
    func importPicture(_ type : UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true)
    }
    
    func importPDF() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String, kUTTypePNG as String, kUTTypeImage as String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func signingUp() {
        if details.count >= 4 {
            switch type {
            case .owner:
                if license != nil && addressCore != nil {
                    self.performSegue(withIdentifier: "signingUp", sender: Any?.self)
                } else {
                    let error = license==nil ? "Enter driving license details" : "Enter address details"
                    ProgressHUD.showError(error)
                }
            case .employee:
                performSegue(withIdentifier: "token", sender: Any?.self)
            case .licensee:
                print("NIL")
            }
        } else {
            ProgressHUD.showError(message)
        }
    }
}

extension SignUpViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        let fileURL = selectedFile
        do {
            let mediaD = try Data(contentsOf: fileURL)
            let response = mediaD.base64EncodedString()
            profileImage = response
            logoBttn.setImage(UIImage(data: mediaD), for: .normal)
        } catch {
            ProgressHUD.showError(Strings.fileError)
        }
    }
}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            guard let image = info[.editedImage] as? UIImage else { return }
            self.logoBttn.setImage(image, for: .normal)
            self.profileImage = image.pngData()!.base64EncodedString()
            self.dismiss(animated: true)
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == DLTextField {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            self.performSegue(withIdentifier: "DL", sender: Any?.self)
        }
        if textField == AddressTextField {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            self.performSegue(withIdentifier: "myaddress", sender: Any?.self)
        }
        if textField == dobTextField {
            datePickerView.datePickerMode = .date
            
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
            let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(donePressed))
            toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: true)
            textField.inputAccessoryView = toolBar
            
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            if nameTextField.text?.isEmpty ?? false {
                message = "Enter valid name"
                ProgressHUD.showError(message)
            } else {
                details.insert("name")
            }
            
        case mobileTextField:
            let text = mobileTextField.text ?? ""
                details.insert("mobile")
            
        case emailTextField:
            let text = emailTextField.text ?? ""
            if text.isValidEmail() {
                details.insert("mail")
            } else {
                message = "Invalid mail"
                ProgressHUD.showError(message)
            }
            
        case passwordTextField:
            let text = passwordTextField.text ?? ""
            if text.isValidPassword() {
                details.insert("password")
            } else {
                message = "Invalid Password. Must contain 1 Uppercase, 1 Lowercase and a special character"
                ProgressHUD.showError(message)
            }
            
        case confirmPasswordTextField:
            if confirmPasswordTextField.text != passwordTextField.text {
                message = "Passwords do not match"
                ProgressHUD.showError(message)
            } else {
                details.insert("confirm")
            }
        case dobTextField:
                details.insert("dob")
        default:
            textField.resignFirstResponder()
        }
    }
}

extension SignUpViewController : DLDelegate  {
    func returnDLData(License: DriverLicense) {
        self.license = License
        DLTextField.isSecureTextEntry = false
        DLTextField.text = License.card
    }
}

extension SignUpViewController : addressDelegate {
    func didEnterAddress(address: AddressRequest) {
        AddressTextField.text = address.text
        self.addressCore = address
    }
}

extension SignUpViewController {
    
    @objc func cancelPressed() {
        dobTextField.resignFirstResponder()
    }
    
    @objc
    func donePressed() {
        dobTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dobTextField.text = formatter.string(from: datePickerView.date)
        self.DOB = datePickerView.date
    }
    
}

extension Date {
    func addYears(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .year, value: n, to: self)!
    }
    
    func getDOB()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let date = formatter.string(from: self)
        return date
    }

}

extension String {
    func convertExpiry()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        if let date = formatter.date(from: self){
            formatter.dateFormat = "yyyy-MM-dd"
            let returnDate = formatter.string(from: date)
            return returnDate
        } else {
            return self
        }
    }
}


