//
//  ProfileDetailsViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 07/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import WebKit
import ProgressHUD

// MARK: - Protocols


class ProfileDetailsViewController: UIViewController {
    
    var employeeId = ""
    var licenseToggle = false
    var editToggle = false
    var profile : UserProfile? = nil
    var employee : EmployeeDetails? = nil
    var licenseDetails : DriverLicense? = nil
    var addressCore : AddressRequest? = nil
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var dlTextfield: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var verifyEmail: UIButton!
    @IBOutlet weak var verifyMobile: UIButton!
    var activeTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        interaction(interactable: false)
        if let user = Constant.loginDefaults?.value(forKey: Keys.userObject) as? Data {
            do {
                let userObject = try JSONDecoder().decode(EmployeeDetails.self, from: user)
                self.employeeId = userObject.id!
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if self.employee == nil {
            self.employee = self.profile?.employeeObj
        } else {
            self.saveButton.isHidden = true
            self.changePasswordButton.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.name.text = self.employee?.name
            self.email.text = self.employee?.email
            self.mobile.text = self.employee?.mobile
            self.verifyMobile.isHidden = self.employee?.isMobileVerified ?? false
            self.verifyEmail.isHidden = self.employee?.isEmailVerified ?? false
            if let photo = self.employee?.photo?.data,let url = URL(string: photo) {
                self.photo.kf.setImage(with: url)
            }
            if let license = self.employee?.driverLicense {
                self.dlTextfield.text = license.card!
            //    self.webView.load(URLRequest(url: URL(string: license.scan?.data ?? "")!)) //TODO
                self.licenseDetails = license
            } else {
                self.dlTextfield.text = "No License Added"
            }
            if let address = self.employee?.address {
                self.addressTextField.text = address.text
            } else {
                self.addressTextField.text = "No Address Added"
            }
        }
        
        setupAddress()
        
        let editPhotoTap = UITapGestureRecognizer()
        editPhotoTap.addTarget(self, action: #selector(ProfileDetailsViewController.importImage))
        photo.addGestureRecognizer(editPhotoTap)
        
        overrideUserInterfaceStyle = .light
        name.delegate = self
        email.delegate = self
        mobile.delegate = self
        dlTextfield.delegate = self
        addressTextField.delegate = self
    }
    
    
    
    func setupAddress(){
        addressCore = AddressRequest()
        addressCore?.text = profile?.employeeObj?.address?.text
        addressCore?.coordinates = profile?.employeeObj?.address?.location.coordinates
        addressCore?.country = profile?.employeeObj?.address?.country
        addressCore?.state = profile?.employeeObj?.address?.state
        addressCore?.city = profile?.employeeObj?.address?.city
        addressCore?.pincode = profile?.employeeObj?.address?.pincode
    }
    
    override func viewDidLayoutSubviews() {
        changePasswordButton.layer.cornerRadius = 8
        verifyEmail.layer.cornerRadius = 8
        verifyMobile.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
        photo.layer.cornerRadius = photo.frame.height/2
        webView.layer.cornerRadius = 14
    }
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "close", sender: Any?.self)
    }
    
    @objc func viewLicense() {
        view.addBlurToView()
        view.bringSubviewToFront(webView)
        webView.alpha = 1
        licenseToggle = true
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if(!editToggle) {
            editToggle = true
            saveButton.setTitle("SAVE PROFILE", for: .normal)
            interaction(interactable: true)
        } else {
            editToggle = false
            saveButton.setTitle("UPDATE PROFILE", for: .normal)
            updateProfile()
        }
    }
    
    func updateProfile() {
        //todo
        // let baseImage =  photo.image!.pngData()?.base64EncodedString()
        
        
        //let address = addressCore ?? AddressRequest()
        
        let address = AddressRequest()
        
        let number = mobile.text?.replacingOccurrences(of: "+61", with: "") //TODO
        
        let employee = Employee(name: name.text!, mobile: number!, email: email.text!, password: nil, photo: "", dob: "", driverLicense: licenseDetails!, address: address) //TODO DOB
        
        PostController.shared.editProfile(employee) { (status, employee, message) in
            print(status,message)
            DispatchQueue.main.async {
                if status {
                    self.interaction(interactable: false)
                    self.editToggle = false
                    self.saveButton.setTitle("UPDATE PROFILE", for: .normal)
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(employee) {
                        print("saving employee")
                        Constant.loginDefaults?.set(encoded, forKey: Keys.userObject)
                    }
                    self.performSegue(withIdentifier: "close", sender: Any?.self)
                } else {
                    ProgressHUD.showError(message)
                }
            }
        }
        editToggle = false
    }
    
    
    @IBAction func mobileVerifyTapped(_ sender: Any) {
        let storyboard = AppStoryboard.login.instance
        let otpVC = storyboard.instantiateViewController(withIdentifier: "SignupVerificationViewController") as! SignupVerificationViewController
        let mobile = (self.employee?.mobile ?? "+61")
        otpVC.mobile = String(mobile.dropFirst(3))
        otpVC.country = self.employee?.country
        otpVC.type = .employee
        present(otpVC, animated: true, completion: nil)
    }
    
    @IBAction func emailVerifyTapped(_ sender: Any) {
        let body = EmailVerification(email: self.employee?.email, user: "licensee")
        let reqBody = try! JSONEncoder().encode(body)
        
        PostController.shared.resendEmail(resendObject: reqBody) { (error, success) in
            if success {
                ProgressHUD.showSuccess("Verification Email Sent")
            } else {
                ProgressHUD.showError(error)
            }
        }
    }
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileVC = segue.destination as? ProfileViewController {
            print("YOLO")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if licenseToggle {
            view.sendSubviewToBack(webView)
            webView.alpha = 0
            view.removeBlur()
            licenseToggle = false
        }
    }
    
    func interaction(interactable: Bool) {
        name.isUserInteractionEnabled = interactable
        email.isUserInteractionEnabled = interactable
        mobile.isUserInteractionEnabled = interactable
        photo.isUserInteractionEnabled = interactable
    }
}

extension ProfileDetailsViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dlTextfield {
            dlTextfield.resignFirstResponder()
            self.view.endEditing(true)
            licenseToggle = true
            
            if editToggle == true {
                let storyboard = AppStoryboard.login.instance
                let dlVC = storyboard.instantiateViewController(withIdentifier: "dlView") as! DLViewController
                dlVC.delegate = self
                present(dlVC, animated: true, completion: nil)
            } else {
                viewLicense()
            }
        }
        
        if textField == addressTextField {
            addressTextField.resignFirstResponder()
            self.view.endEditing(true)
            if editToggle == true {
                let storyboard = AppStoryboard.login.instance
                let addressVC = storyboard.instantiateViewController(withIdentifier: "addressVC") as! AddressViewController
                if let address = addressCore{
                    addressVC.addressCore = address
                }
                addressVC.delegate = self
                present(addressVC, animated: true, completion: nil)
            }
        }
    }
    
}

extension ProfileDetailsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            guard let image = info[.editedImage] as? UIImage else { return }
            self.photo.image = image
            self.dismiss(animated: true)
        }
    }
}

extension ProfileDetailsViewController : DLDelegate  {
    func returnDLData(License: DriverLicense) {
        self.licenseDetails = License
        dlTextfield.isSecureTextEntry = false
        dlTextfield.text = License.card
        view.removeBlur()
    }
}

extension ProfileDetailsViewController : addressDelegate {
    func didEnterAddress(address: AddressRequest) {
        self.addressCore = address
    }
}
