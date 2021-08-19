//
//  InsuranceViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 22/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import VisionKit
import PDFKit
import ProgressHUD
import MobileCoreServices
import NotificationCenter

class InsuranceViewController: UIViewController {
    
    var titlePhoto: UIImage = UIImage()
    var trailer : AddTrailer?
    var insuranceData : String?
    var activeTextField = UITextField()
    var operation = ""
    var editId = ""
    var titlePhotoURL = ""
    var editingTrailer = ""
    var insurance : TrailerInsurance?
    var formatter = DateFormatter()
    var dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var expiryDate: UITextField!
    @IBOutlet weak var issueDate: UITextField!
    @IBOutlet weak var addInsuranceBttn: UIButton!
    @IBOutlet weak var fileStatus: UILabel!
    @IBOutlet weak var insuranceDocBttn: UIButton!
    @IBOutlet weak var expiryDateView: UIView!
    @IBOutlet weak var issueDateView: UIView!
    @IBOutlet weak var trailerName: UILabel!
    @IBOutlet weak var trailerPhoto: UIImageView!
    @IBOutlet weak var Header: UILabel!
    
    @IBOutlet weak var subHeader: UILabel!
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if operation == OperationType.edit.rawValue {
            trailerPhoto.kf.setImage(with: URL(string: titlePhotoURL))
            trailerName.text = editingTrailer
            addInsuranceBttn.setTitle("Update Insurance", for: .normal)
            Header.text = "Edit Insurance"
            subHeader.text = "Edit your Insurance"
        } else if operation == OperationType.add.rawValue{
            addInsuranceBttn.setTitle("Add Insurance", for: .normal)
            trailerName.text = editingTrailer
            trailerPhoto.kf.setImage(with: URL(string: titlePhotoURL))
            Header.text = "Add Insurance"
            subHeader.text = "Add new Insurance"
        } else {
            trailerPhoto.image = titlePhoto
            trailerName.text = trailer?.name
            Header.text = "Add Insurance"
            subHeader.text = "Add new trailer"
        }
        
        issueDate.delegate = self
        expiryDate.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let insurance = self.insurance {
            let sdate = formatter.date(from: insurance.issueDate)
            let edate = formatter.date(from: insurance.expiryDate)
            issueDate.text = dateFormatter.string(from: sdate!)
            expiryDate.text = dateFormatter.string(from: edate!)
            if let doc = insurance.document?.data{
                if let url = URL(string: doc){
                    print("URL:",url)
                    if let pdf = PDFDocument(url: url) {
                        if let data = pdf.dataRepresentation()?.base64EncodedString() {
                            print("PDF: ",data)
                            self.insuranceData = data
                            self.fileStatus.text = "File added"
                        }
                    }
                }}
        }
    }
        
        override func viewDidLayoutSubviews() {
            issueDateView.makeCard()
            expiryDateView.makeCard()
            insuranceDocBttn.layer.cornerRadius = 8
            addInsuranceBttn.layer.cornerRadius = 14
            trailerPhoto.layer.cornerRadius = 24
            trailerPhoto.clipsToBounds = true
        }
        
        @IBAction func closeBttnTapped(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }
        
        func showDatePicker(textField : UITextField) {
            datePicker.backgroundColor = .secondarySystemBackground
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 216))
            datePicker.datePickerMode = .date
            if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
            
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            
            textField.inputAccessoryView = toolbar
            textField.inputView = datePicker
        }
        
        @objc func donedatePicker() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            activeTextField.text = formatter.string(from: datePicker.date)
            activeTextField.resignFirstResponder()
            print(issueDate.text!)
            print(expiryDate.text!)
        }
        
        @objc func cancelDatePicker() {
            self.view.endEditing(true)
        }
        
        @IBAction func insuranceBttnTapped(_ sender: Any) {
            presentActionSheet()
        }
        
        func presentActionSheet(){
            let action = UIAlertController(title: "", message: "Select Scan", preferredStyle: .actionSheet)
            if insuranceData != nil {
                action.addAction(UIAlertAction(title: "View Scan", style: .default, handler: { (a) in
                    let storyboard = AppStoryboard.login.instance
                    let pdfView = storyboard.instantiateViewController(withIdentifier: "pdfView") as! PDFViewController
                    pdfView.navTitle = .Insurance
                    if let data = Data(base64Encoded: self.insuranceData!) {
                        pdfView.pdfData = data
                    }
                    self.present(pdfView, animated: true, completion: nil)
                }))
            }
            action.addAction(UIAlertAction(title: "Click a scan", style: .default, handler: { (a) in
                let documentCameraViewController = VNDocumentCameraViewController()
                documentCameraViewController.delegate = self
                self.present(documentCameraViewController, animated: true)
            }))
            action.addAction(UIAlertAction(title: "Pick a scan", style: .default, handler: { (a) in
                
                let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String, kUTTypePNG as String, kUTTypeImage as String], in: .import)
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                self.present(documentPicker, animated: true, completion: nil)
            }))
            action.addAction(UIAlertAction(title: "Canel", style: .cancel, handler: nil))
            self.present(action, animated: true)
        }
        
        @IBAction func addInsuranceBttnTapped(_ sender: Any) {
            if issueDate.text?.isEmpty ?? true || expiryDate.text?.isEmpty ?? true || insuranceData == nil || insuranceData == "" {
                ProgressHUD.showError(Strings.textFieldEmpty)
            } else {
                if operation == "edit" {
                    edit()
                } else if operation == "add" {
                    add()
                } else {
                    self.performSegue(withIdentifier: "service", sender: Any?.self)
                }
            }
        }
        
        func edit() {
            addInsuranceBttn.disable()
            ProgressHUD.show("Updating Insurance")
            let insurance = InsuranceList(itemType: "Trailer", id: self.insurance?._id ?? "", issueDate: issueDate.text!, expiryDate: expiryDate.text!, document: Photo(contentType: "application/pdf", data: insuranceData), licenseeId: nil, itemId: editId, insuranceRef: nil)
            
            PostController.shared.addInsurance(insurance,  update: true) { (status, message) in
                ProgressHUD.dismiss()
                if status {
                    DispatchQueue.main.async {
                        ProgressHUD.showSuccess("Updated Trailer insurance")
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.addInsuranceBttn.enable()
                        ProgressHUD.showError(message ?? "Error")
                    }
                }
            }
        }
        
        func add(){
            addInsuranceBttn.disable()
            ProgressHUD.show("Adding Insurance")
            let insurance = InsuranceList(itemType: "Trailer", id: nil, issueDate: issueDate.text!, expiryDate: expiryDate.text!, document: Photo(contentType: "application/pdf", data: insuranceData), licenseeId: nil, itemId: editId, insuranceRef: nil)
            
            PostController.shared.addInsurance(insurance) { (status, message) in
                ProgressHUD.dismiss()
                if status {
                    DispatchQueue.main.async {
                        ProgressHUD.showSuccess("Added Trailer insurance")
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.addInsuranceBttn.enable()
                        ProgressHUD.showError(message ?? "Error")
                    }
                }
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let insurance = AddInsurance(issueDate: issueDate.text!, expiryDate: expiryDate.text!, document: insuranceData!)
            trailer?.insurance = insurance
            if let vc = segue.destination as? ServiceViewController {
                vc.trailer = trailer
                vc.titlePhoto = titlePhoto
            }
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
    
    extension InsuranceViewController: UIDocumentPickerDelegate {
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedFile = urls.first else { return }
            let fileURL = selectedFile
            do {
                let mediaD = try Data(contentsOf: fileURL)
                let response = mediaD.base64EncodedString()
                insuranceData = response
                self.fileStatus.text = "File added"
            } catch {
                ProgressHUD.showError(Strings.fileError)
            }
        }
    }
    
    extension InsuranceViewController: UITextFieldDelegate {
        func textFieldDidBeginEditing(_ textField: UITextField) {
            activeTextField = textField
            showDatePicker(textField: textField)
        }
    }
    
    extension InsuranceViewController : VNDocumentCameraViewControllerDelegate {
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            
            let pdf = PDFDocument()
            let pdfPage = PDFPage(image: scan.imageOfPage(at: 0))
            pdf.insert(pdfPage!, at: 0)
            print(pdf.dataRepresentation())
            self.insuranceData = (pdf.dataRepresentation()?.base64EncodedString() ?? "")
            // self.addScanBttn.setTitle("View Scan", for: .normal)
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

