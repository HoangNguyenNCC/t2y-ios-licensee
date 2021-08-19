//
//  SignUpBViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 11/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import PDFKit
import CoreLocation
import ProgressHUD
import iOSDropDown
import MobileCoreServices
import NotificationCenter
import VisionKit

class SignUpBViewController: UIViewController, UIDocumentBrowserViewControllerDelegate {
    
    let bTypes : [String] = ["individual", "company"]
    var bType : String = ""
    var incorporationData = ""
    var logoData = ""
    var docType = ""
    var imagePicker = UIImagePickerController()
    var addressCore: AddressRequest?
    var status: [Int] = []
    var type = ""
    var details = 0
    var message = ""
    
    @IBOutlet weak var businessNumberField: UITextField!
    @IBOutlet weak var fileAddedStatus: UILabel!
    @IBOutlet weak var incorporationDocBttn: UIButton!
    @IBOutlet weak var businessLocation: UITextField!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var signUpBttn: UIButton!
    @IBOutlet weak var businessEmailTextField: UITextField!
    @IBOutlet weak var logoBttn: UIButton!
    @IBOutlet weak var businessType: DropDown!
    
    let employeeType : Bool = true
    var employeeObj : Employee?
    var licenseeDetails : Licensee?
    var fileURL: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessLocation.delegate = self
        businessType.optionArray = bTypes
        businessType.selectedRowColor = UIColor.lightGray
        overrideUserInterfaceStyle = .light
        
        let prefix = UILabel()
        prefix.text = "  +61 "
        prefix.font = UIFont(name: "Avenir Next Demi Bold", size: 12)
        prefix.textColor = .black
        prefix.sizeToFit()
        
        businessNumberField.leftView = prefix
        businessNumberField.leftViewMode = .always
        
        businessNumberField.delegate = self
        businessNameTextField.delegate = self
        businessEmailTextField.delegate = self
        
        //   setupSameMobileEmail()
    }
    
    override func viewDidLayoutSubviews() {
        logoBttn.layer.cornerRadius = logoBttn.frame.width/2
        logoBttn.clipsToBounds = true
        logoBttn.layer.borderWidth = 2
        logoBttn.layer.borderColor = UIColor.black.cgColor
        signUpBttn.layer.cornerRadius = 14
        self.incorporationDocBttn.layer.cornerRadius = 12
        self.businessEmailTextField.formatField()
        self.businessNameTextField.formatField()
        self.businessType.layer.cornerRadius = 12
        self.businessLocation.formatField()
        self.businessNumberField.formatField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupSameMobileEmail(){
        let mobile = employeeObj?.mobile ?? "91"
        businessNumberField.text = mobile.replacingOccurrences(of: "91", with: "") //TODO
        businessEmailTextField.text = employeeObj?.email
        businessNumberField.textColor = .secondaryLabel
        businessEmailTextField.textColor = .secondaryLabel
        businessNumberField.isEnabled = false
        businessEmailTextField.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressVC = segue.destination as? AddressViewController {
            addressVC.delegate = self
        }
        
        if let paymentVC = segue.destination as? SignUpPaymentViewController {
            let address = Address(text: (addressCore?.text!)!, pincode: (addressCore?.pincode!)!, coordinates: (addressCore?.coordinates!)!, city: (addressCore?.city!)!, state: (addressCore?.state!)!)
            let business = Licensee(name: businessNameTextField.text!, email: businessEmailTextField.text!, mobile: businessNumberField.text!, address: address, proofOfIncorporation: incorporationData, logo: logoData, bsbNumber: "", accountNumber: "", workingDays: [], workingHours: "", country: "Australia", businessType: bType)
            paymentVC.licensee = business
            paymentVC.employee = employeeObj
            paymentVC.country = (self.addressCore?.country!)!
        }
        
        if let scanVC = segue.destination as? PDFViewController {
            scanVC.pdfData = Data(base64Encoded: self.incorporationData) ?? Data()
        }
        
    }
    
    @IBAction func signUpBttnTapped(_ sender: Any) {
        let index = businessType.selectedIndex ?? -1
        //TODO
        self.bType = bTypes[businessType.selectedIndex ?? 0]
        
        if addressCore == nil {
            ProgressHUD.showError("Incorrect Address")
        }
        else if(logoData == "" || incorporationData == "") {
            ProgressHUD.showError("Incorrect Document/Logo")
        }
        if(details > 2 && index >= 0) { 
            signUp()
        } else {
            print("ELSE")
            ProgressHUD.showError(message)
        }
    }
    
    
    
    @IBAction func cancelBttnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "backToSignUp", sender: Any?.self)
    }
    
    @IBAction func incorporationBttnTapped(_ sender: Any) {
        importDocumentAlert()
    }
    
    @IBAction func logoBttnTapped(_ sender: Any) {
        self.importPicture(.photoLibrary)
    }
    
    
    func signUp() {
        // employeeObj?.country = (self.addressCore?.country ?? "Australia")!
        licenseeDetails?.country = (self.addressCore?.country!)!
        self.performSegue(withIdentifier: "payment", sender: Any?.self)
    }
    
    func importDocumentAlert() {
        let action = UIAlertController(title: "Import Document", message: "Please Select a Scan", preferredStyle: .actionSheet)
        if incorporationData != "" {
            action.addAction(UIAlertAction(title: "View Scan", style: .default, handler: { (a) in
                self.performSegue(withIdentifier: "scanDoc", sender: Any?.self)
            }))
        }
        action.addAction(UIAlertAction(title: "Click a scan", style: .default, handler: { (a) in
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            self.present(documentCameraViewController, animated: true)
        }))
        action.addAction(UIAlertAction(title: "Pick a scan", style: .default, handler: { (a) in
            let picker = UIDocumentPickerViewController(documentTypes: ["public.composite-content"], in: .import)
            picker.delegate = self
            picker.allowsMultipleSelection = false
            self.present(picker, animated: true, completion: nil)
        }))
        action.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
        self.present(action, animated: true)
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
}

extension SignUpBViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        let fileURL = selectedFile
        do {
            let mediaD = try Data(contentsOf: fileURL)
            let response = mediaD.base64EncodedString()
            
            incorporationData = response
            fileAddedStatus.text = "File added"
        } catch {
            ProgressHUD.showError(Strings.fileError)
        }
        
    }
}

extension SignUpBViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            guard let image = info[.editedImage] as? UIImage else { return }
            self.logoBttn.setImage(image, for: .normal)
            self.logoData = image.pngData()!.base64EncodedString()
            self.dismiss(animated: true)
        }
    }
}

extension SignUpBViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == businessLocation {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            self.performSegue(withIdentifier: "address", sender: Any?.self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case businessNameTextField:
            let text = businessNameTextField.text ?? ""
            if text.isEmpty {
                message = "Invalid business name"
                ProgressHUD.showError(message)
            } else {
                details = details + 1
            }
            
        case businessEmailTextField:
            let text = businessEmailTextField.text ?? ""
            if text.isValidEmail() {
                details = details + 1
            } else {
                message = "Invalid Email"
                ProgressHUD.showError(message)
            }
            
        case businessNumberField:
            let text = businessNumberField.text ?? ""
            if text.isEmpty {
                message = "Invalid phone number"
                ProgressHUD.showError(message)
            } else {
                details = details + 1
            }
        default:
            break
        }
        
    }
}

extension SignUpBViewController : addressDelegate {
    func didEnterAddress(address: AddressRequest) {
        businessLocation.text = address.text
        self.addressCore = address
    }
}

extension SignUpBViewController : VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        let pdf = PDFDocument()
        let pdfPage = PDFPage(image: scan.imageOfPage(at: 0))
        pdf.insert(pdfPage!, at: 0)
        self.incorporationData = (pdf.dataRepresentation()?.base64EncodedString() ?? "")
        fileAddedStatus.text = "File added"
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        self.dismiss(animated: true, completion: nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
