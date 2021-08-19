//
//  ServiceViewController.swift
//  LicenseeTrailer2You
//
//  Created by Pranav Karnani on 22/03/20.
//  Copyright © 2020 Pranav Karnani. All rights reserved.
//

import UIKit
import ProgressHUD
import MobileCoreServices
import NotificationCenter
import PDFKit
import VisionKit

class ServiceViewController: UIViewController {
    
    var titlePhoto = UIImage()
    var serviceData : String?
    var activeTextField = UITextField()
    var datePicker = UIDatePicker()
    var trailer: AddTrailer?
    var service : TrailerService?
    var operation = ""
    var editId = ""
    var titlePhotoURL = ""
    var editingTrailer = ""
    var formatter = DateFormatter()
    var dateFormatter = DateFormatter()
    
    
    @IBOutlet weak var nextServiceDate: UITextField!
    @IBOutlet weak var serviceDate: UITextField!
    @IBOutlet weak var serviceProvider: UITextField!
    @IBOutlet weak var addServicingBttn: UIButton!
    @IBOutlet weak var fileStatus: UILabel!
    @IBOutlet weak var servicingDocBttn: UIButton!
    @IBOutlet weak var nextServiceDateView: UIView!
    @IBOutlet weak var serviceDateView: UIView!
    @IBOutlet weak var serviceNameView: UIView!
    @IBOutlet weak var trailerName: UILabel!
    @IBOutlet weak var trailerPhoto: UIImageView!
    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var subHeader: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        

        
        if operation == OperationType.edit.rawValue {
            trailerPhoto.kf.setImage(with: URL(string: titlePhotoURL))
            trailerName.text = editingTrailer
            addServicingBttn.setTitle("Update Servicing", for: .normal)
            Header.text = "Edit Servicing"
            subHeader.text = "Edit your service request"
        } else if operation == OperationType.add.rawValue{
            trailerPhoto.kf.setImage(with: URL(string: titlePhotoURL))
            trailerName.text = editingTrailer
            addServicingBttn.setTitle("Add Service", for: .normal)
            Header.text = "Add Servicing"
            subHeader.text = "Add new service request"
        } else {
            trailerPhoto.image = titlePhoto
            trailerName.text = trailer?.name
            Header.text = "Add Servicing"
            subHeader.text = "Add new service request"
        }
        
        serviceDate.delegate = self
        nextServiceDate.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if let service = self.service{
            let sdate = formatter.date(from: service.serviceDate)
            let edate = formatter.date(from: service.nextDueDate)
               serviceDate.text = dateFormatter.string(from: sdate!)
               nextServiceDate.text = dateFormatter.string(from: edate!)
                serviceProvider.text = service.name ?? ""
            if let doc = service.document?.data, let url = URL(string: doc) {
                   if let pdf = PDFDocument(url: url){
                       let data = pdf.dataRepresentation()?.base64EncodedString()
                       self.serviceData = data
                       self.fileStatus.text = "File added"
                   }
               }
        }
    }
    
    override func viewDidLayoutSubviews() {
        serviceDateView.makeCard()
        serviceNameView.makeCard()
        nextServiceDateView.makeCard()
        servicingDocBttn.layer.cornerRadius = 14
        addServicingBttn.layer.cornerRadius = 14
        trailerPhoto.layer.cornerRadius = 24
        trailerPhoto.clipsToBounds = true
    }
    
    @IBAction func serviceBttnTapped(_ sender: Any) {
        presentActionSheet()
    }
    
    @IBAction func addServicingBttnTapped(_ sender: Any) {
        var trailerObject = Data()
        if(serviceData == nil || serviceDate.text?.isEmpty ?? true || nextServiceDate.text?.isEmpty ?? true) {
            ProgressHUD.showError(Strings.textFieldEmpty)
        } else {
            if operation == "edit" {
                edit()
            } else if operation == "add"{
                add()
            } else {
                let service = AddService(name: serviceProvider.text!, serviceDate: serviceDate.text!, nextDueDate: nextServiceDate.text!, document: serviceData!)
                trailer?.service = service
                savetrailer(trailerObject: trailer)
            }
        }
    }
    
    func add(){
        addServicingBttn.disable()
        ProgressHUD.show("Adding Servicing")
        let service = ServicingList(itemType: "Trailer", id: nil, serviceDate: serviceDate.text, nextDueDate: nextServiceDate.text, document: Photo(contentType: "application/pdf", data: serviceData), licenseeId: nil, itemId: editId, insuranceRef: nil, name: serviceProvider.text)

        PostController.shared.addServicing(service) { (status, message) in
            ProgressHUD.dismiss()
            if status {
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess("Added Trailer Service")
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.addServicingBttn.enable()
                    ProgressHUD.showError(message ?? "Error")
                }
            }
        }
    }
    
    func edit() {
         addServicingBttn.disable()
          ProgressHUD.show("Updating Service")
   
        let service = ServicingList(itemType: "Trailer", id: self.service?._id, serviceDate: serviceDate.text, nextDueDate: nextServiceDate.text, document: Photo(contentType: "application/pdf", data: serviceData), licenseeId: nil, itemId: editId, insuranceRef: nil, name: serviceProvider.text)

        
          PostController.shared.addServicing(service,  update: true) { (status, message) in
            ProgressHUD.dismiss()
            if status {
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess("Updated Trailer Service")
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.addServicingBttn.enable()
                    ProgressHUD.showError(message ?? "Error")
                }
            }
        }
    }
    
    func presentActionSheet(){
        let action = UIAlertController(title: "", message: "Select Scan", preferredStyle: .actionSheet)
        if serviceData != nil {
            action.addAction(UIAlertAction(title: "View Scan", style: .default, handler: { (a) in
                let storyboard = AppStoryboard.login.instance
                let pdfView = storyboard.instantiateViewController(withIdentifier: "pdfView") as! PDFViewController
                pdfView.navTitle = .Servicing(name: self.service?.name ?? "")
                if let data = Data(base64Encoded: self.serviceData!) {
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
    
    @IBAction func closeBttnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func savetrailer(trailerObject: AddTrailer?) {
        ProgressHUD.show("Saving Trailer Details")
        addServicingBttn.disable()
        PostController.shared.addTrailer(trailerObject!) { (status, message) in
            print(status,message)
            ProgressHUD.dismiss()
            if status {
                DispatchQueue.main.async {
                    ProgressHUD.showSuccess(message ?? "success")
                    self.performSegue(withIdentifier: "close", sender: Any?.self)
                }
            } else {
                DispatchQueue.main.async {
                    self.addServicingBttn.enable()
                    ProgressHUD.showError(message ?? "")
                }
            }
        }
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
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
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

extension ServiceViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFile = urls.first else { return }
        let fileURL = selectedFile
        
        do {
            let mediaD = try Data(contentsOf: fileURL)
            serviceData = mediaD.base64EncodedString()
            self.fileStatus.text = "File added"
        } catch {
            ProgressHUD.showError(Strings.fileError)
        }
    }
}

extension ServiceViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != serviceProvider {
            activeTextField = textField
            showDatePicker(textField: activeTextField)
        }
    }
}

    extension ServiceViewController : VNDocumentCameraViewControllerDelegate {
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            
            let pdf = PDFDocument()
            let pdfPage = PDFPage(image: scan.imageOfPage(at: 0))
            pdf.insert(pdfPage!, at: 0)
            print(pdf.dataRepresentation())
            self.serviceData = (pdf.dataRepresentation()?.base64EncodedString() ?? "")
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
