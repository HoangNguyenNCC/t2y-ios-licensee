//
//  LicenseeDetailsViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 11/05/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD
import SafariServices


protocol licenseeDelegate: class {
    func didEnterLicensee(licensee: LicenseeDetails)
}

//TODO = remove verified logo

class LicenseeDetailsViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    var addressCore : AddressRequest? = nil
    var days: [String] = []
    var daysObject: [String] = []
    var user: UserProfile? = nil
    var original: UserProfile? = nil
    var oldValue = ""
    var save = false
    var wasDLChanged = false
    var wasAddressChanged = false
    var wasPhotoChanged = false
    var hours: [String] = []
    var activeTextField = UITextField()
    
    weak var delegate: licenseeDelegate?
    
    
    @IBOutlet weak var verifyCell: UITableViewCell!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mondayBttn: UIButton!
    @IBOutlet weak var tuesdayBttn: UIButton!
    @IBOutlet weak var wednesdayBttn: UIButton!
    @IBOutlet weak var thursdayBttn: UIButton!
    @IBOutlet weak var fridayBttn: UIButton!
    @IBOutlet weak var saturdayBttn: UIButton!
    @IBOutlet weak var sundayBttn: UIButton!
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var bsbNumber: UITextField!
    @IBOutlet weak var taxId: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var incorporationDoc: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var verifyMobile: UIButton!
    @IBOutlet weak var verifyEmail: UIButton!
    
    var datePicker = UIDatePicker()
    var toolbar = UIToolbar()
    var daysCopy : [String] = []
    
    @IBOutlet weak var starLabel: UILabel!
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        original = user
        overrideUserInterfaceStyle = .light
        name.delegate = self
        name.setPadding()
        email.delegate = self
        email.setPadding()
        mobile.delegate = self
        mobile.setPadding()
        bsbNumber.delegate = self
        bsbNumber.setPadding()
        accountNumber.delegate = self
        accountNumber.setPadding()
        taxId.delegate = self
        taxId.setPadding()
        
        fromField.delegate = self
        toField.delegate = self
        saveButton.disable()
        cancelButton.disable()
        
        print("country",self.user?.employeeObj?.country)
        
        if let rating = original?.employeeObj?.ratingCount {
            starLabel.text = (rating > 0) ? "L I C E N S E E   R A T I N G: \(rating) ⭑" : "E D I T   L I C E N S E E"
        }
        
        if original?.employeeObj?.isOwner ?? false {
            saveButton.enable()
            cancelButton.enable()
        } else {
            fromField.isEnabled = false
            toField.isEnabled = false
            accountNumber.isEnabled = false
            bsbNumber.isEnabled = false
            mondayBttn.isEnabled = false
            tuesdayBttn.isEnabled = false
            thursdayBttn.isEnabled = false
            wednesdayBttn.isEnabled = false
            fridayBttn.isEnabled = false
            saturdayBttn.isEnabled = false
            sundayBttn.isEnabled = false
            name.isEnabled = false
            email.isEnabled = false
            mobile.isEnabled = false
            taxId.isEnabled = false
            self.photo.isUserInteractionEnabled = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImage))
        self.photo.isUserInteractionEnabled = true //TODO
        self.photo.addGestureRecognizer(tapGesture)
        
        let workingdays = user?.licenseeObj?.workingDays ?? ""
        self.days = workingdays.components(separatedBy: ", ")
        setup()
        
    }
    
    func setup() {
        if days.contains("MON") {
            mondayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            daysObject.append("Monday")
        }
        if days.contains("TUE") {
            tuesdayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            daysObject.append("Tuesday")
        }
        if days.contains("WED") {
            wednesdayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            daysObject.append("Wednesday")
        }
        if days.contains("THU") {
            thursdayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            daysObject.append("Thursday")
        }
        if days.contains("FRI") {
            fridayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            daysObject.append("Friday")
        }
        if days.contains("SAT") {
            saturdayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            daysObject.append("Saturday")
        }
        if days.contains("SUN") {
            sundayBttn.backgroundColor = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
            daysObject.append("Sunday")
        }
        
        daysCopy = daysObject
        if let logo = user?.licenseeObj?.logo?.data, let url = URL(string: logo) {
            self.photo.kf.setImage(with: url)
        }
        
        name.text = user?.licenseeObj?.name ?? ""
        email.text = user?.licenseeObj?.email ?? ""
        mobile.text = user?.licenseeObj?.mobile ?? ""
        bsbNumber.text = user?.licenseeObj?.payment?.bsbNumber ?? ""
        accountNumber.text = user?.licenseeObj?.payment?.accountNumber ?? ""
        address.text = user?.licenseeObj?.address?.text
        taxId.text = user?.licenseeObj?.payment?.taxId
        verifyMobile.isHidden = user?.licenseeObj?.isMobileVerified ?? false
        verifyEmail.isHidden = user?.licenseeObj?.isEmailVerified ?? false
        
        hours = (user?.licenseeObj?.workingHours?.components(separatedBy: "-")) ?? ["",""]
        fromField.text = hours[0]
        toField.text = hours[1]
        
        formatTime() //TODO
    }
    
    @objc func timeSelected() {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        activeTextField.text = dateformatter.string(from: datePicker.date)
        let index = activeTextField == fromField ? 0 : 1
        activeTextField.resignFirstResponder()
        dateformatter.dateFormat = "HHmm"
        hours[index] = dateformatter.string(from: datePicker.date)
    }
    
    //TODO remove later
    func formatTime(){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm a"
        
        let times = (user?.licenseeObj?.workingHours?.components(separatedBy: "-")) ?? ["",""]
        let from = dateformatter.date(from: times[0])
        let to = dateformatter.date(from: times[1])
        
        dateformatter.dateFormat = "HH:mm"
        if from != nil && to != nil {
        fromField.text = dateformatter.string(from: from!)
        toField.text = dateformatter.string(from: to!)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        incorporationDoc.layer.cornerRadius = 14
        verifyMobile.layer.cornerRadius = 14
        verifyEmail.layer.cornerRadius = 14
        
        saveButton.layer.cornerRadius = 14
        cancelButton.layer.cornerRadius = 14
        mondayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        tuesdayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        wednesdayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        thursdayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        fridayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        saturdayBttn.layer.cornerRadius = mondayBttn.frame.width/2
        sundayBttn .layer.cornerRadius = mondayBttn.frame.width/2
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        let action = UIAlertController(title: "", message: "Pick an image", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (a) in
            picker.sourceType = .camera
            self.present(picker, animated: true)
        }))
        action.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (a) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }))
        action.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
        self.present(action, animated: true)
    }
    
    @IBAction func incorporationBttnTapped(_ sender: Any) {
        if let doc = user?.licenseeObj?.proofOfIncorporation?.doc, let url = URL(string: doc) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func monday(_ sender: Any) {
        let color = dayHandler(day: "Monday")
        mondayBttn.backgroundColor = color
    }
    
    @IBAction func tuesday(_ sender: Any) {
        let color = dayHandler(day: "Tuesday")
        tuesdayBttn.backgroundColor = color
    }
    
    @IBAction func wednesday(_ sender: Any) {
        let color = dayHandler(day: "Wednesday")
        wednesdayBttn.backgroundColor = color
    }
    
    @IBAction func thursday(_ sender: Any) {
        let color = dayHandler(day: "Thursday")
        thursdayBttn.backgroundColor = color
    }
    
    @IBAction func friday(_ sender: Any) {
        let color = dayHandler(day: "Friday")
        fridayBttn.backgroundColor = color
    }
    
    @IBAction func saturday(_ sender: Any) {
        let color = dayHandler(day: "Saturday")
        saturdayBttn.backgroundColor = color
    }
    
    @IBAction func sunday(_ sender: Any) {
        let color = dayHandler(day: "Sunday")
        sundayBttn.backgroundColor = color
    }
    
    @IBAction func verifyMobile(_ sender: Any) {
        let storyboard = AppStoryboard.login.instance
        let otpVC = storyboard.instantiateViewController(withIdentifier: "SignupVerificationViewController") as! SignupVerificationViewController
        let mobile = (self.user?.licenseeObj?.mobile ?? "+61")
        otpVC.mobile = String(mobile.dropFirst(3))
        otpVC.country = self.user?.employeeObj?.country
        otpVC.type = .licensee
        present(otpVC, animated: true, completion: nil)
    }
    
    @IBAction func verifyEmail(_ sender: Any) {
        let body = EmailVerification(email: self.user?.licenseeObj?.email, user: "licensee")
        let reqBody = try! JSONEncoder().encode(body)
        
        PostController.shared.resendEmail(resendObject: reqBody) { (error, success) in
            if success {
                ProgressHUD.showSuccess("Verification Email Sent")
            } else {
                ProgressHUD.showError((error ?? "Error"))
            }
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
        //TODO cacel action
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        toolBar.barTintColor = .secondarySystemBackground
        toolBar.sizeToFit()
        
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
    }
    
    func dayHandler(day: String) -> UIColor {
        if daysObject.contains(day) {
            daysObject = daysObject.filter { $0 != day }
            return #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        } else {
            daysObject.append(day)
            return #colorLiteral(red: 1, green: 0.8392156863, blue: 0.1529411765, alpha: 1)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        print("SAVE") //TODO
        
        let updatedLicensee = Licensee(name: nil, email: nil, mobile: nil, address: nil, proofOfIncorporation: "", logo: "", bsbNumber: nil, accountNumber: nil, workingDays: nil, workingHours: nil, country: nil, businessType: nil)
        
        if wasPhotoChanged {
            updatedLicensee.logo = (self.photo.image?.pngData()?.base64EncodedString() ?? "")
        }
        
        if wasAddressChanged {
            updatedLicensee.address = Address(text: (addressCore?.text!)!, pincode: addressCore!.pincode!, coordinates: (addressCore?.coordinates!)!, city: (addressCore?.city!)!,state: (addressCore?.state!)!)
        }
        if name.text != "" && name.text != user?.licenseeObj?.name {
            updatedLicensee.name = name.text!
        }
        
        if  email.text != "" && email.text != user?.licenseeObj?.email ?? "" {
            updatedLicensee.email = email.text!
        }
        
        if mobile.text != user?.licenseeObj?.mobile! {
            updatedLicensee.mobile = mobile.text!
            updatedLicensee.country = user?.employeeObj?.country ?? "Australia"
        }
        
        if bsbNumber.text != user?.licenseeObj?.payment?.bsbNumber! {
            updatedLicensee.bsbNumber = bsbNumber.text!
        }
        
        if accountNumber.text != user?.licenseeObj?.payment?.accountNumber! {
            updatedLicensee.accountNumber = accountNumber.text!
        }
        
        if taxId.text != user?.licenseeObj?.payment?.taxId {
            updatedLicensee.taxId = taxId.text
        }
        
        if daysObject.count != daysCopy.count {
            updatedLicensee.workingDays = daysObject
        } else {
            for item in daysObject {
                if !daysCopy.contains(item) {
                    updatedLicensee.workingDays = daysObject
                    break
                }
            }
        }
        
        updatedLicensee.workingHours = hours[0] + "-" + hours[1]
        updatedLicensee.workingHours = updatedLicensee.workingHours?.replacingOccurrences(of: ":", with: "")
        
        PostController.shared.updateLicensee(updatedLicensee, logo: wasPhotoChanged) { (status, message,licensee) in
            if status {
                ProgressHUD.showSuccess(message)
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(licensee) {
                    Constant.loginDefaults?.set(encoded, forKey: Keys.licenseeObject)
                }
                if licensee != nil {
                    self.delegate?.didEnterLicensee(licensee: licensee!)
                }
            } else {
                ProgressHUD.showError(message)
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
            }
        }
        
        if indexPath.section == 1 {
            let storyboard = AppStoryboard.login.instance
            let addressVC = storyboard.instantiateViewController(withIdentifier: "addressVC") as! AddressViewController
            let address = user?.licenseeObj?.address
            addressVC.addressCore.text = address?.text
            addressVC.addressCore.coordinates = address?.coordinates
            addressVC.delegate = self
            present(addressVC, animated: true, completion: nil)
        }
        
        if indexPath.section == 2 {
            //TODO
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            return 150
        case IndexPath(row: 9, section: 0):
            return verifyHeight()
        default:
            return 60
        }
    }
    
    func verifyHeight()->CGFloat{
        if (user?.licenseeObj?.isEmailVerified ?? false) && (user?.licenseeObj?.isMobileVerified ?? false){
            return CGFloat(80)
        } else {
            return CGFloat(190)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension LicenseeDetailsViewController : addressDelegate {
    func didEnterAddress(address: AddressRequest) {
        wasAddressChanged = true
        self.addressCore = address
        self.address.text = address.text
    }
}

extension LicenseeDetailsViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if textField == fromField || textField == toField {
            setupDatePicker(textField: textField)
        }
        
        oldValue = textField.text ?? ""
        activeTextField = textField
        activeTextField.layer.cornerRadius = 8
        activeTextField.backgroundColor = .secondarySystemBackground
        //textField.inputAccessoryView = toolbar
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        if save {
        //            oldValue = ""
        //        }
        //        else {
        //            textField.text = oldValue
        //        }
        //TODO
        activeTextField.backgroundColor = .clear
    }
}

extension LicenseeDetailsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            guard let image = info[.editedImage] as? UIImage else { return }
            self.photo.image = image
            self.wasPhotoChanged = true
            self.dismiss(animated: true)
        }
    }
}
